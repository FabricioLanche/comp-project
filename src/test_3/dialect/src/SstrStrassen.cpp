// =============================================================
// SstrStrassen.cpp — dialecto sstr + pass sstr-expand + driver sstr-opt
//
// 1) Verifier de sstr.matmul (ODS declara hasVerifier).
// 2) Pass sstr-expand: baja sstr.matmul a linalg/tensor/arith.
//    * method="strassen" -> expansion recursiva de Strassen hasta cutoff
//      (los cuadrantes se copian con tensor.extract_slice — igual que la
//      funcion qcpy() del C — y se recomponen con tensor.insert_slice).
//    * method="naive"    -> un linalg.matmul directo.
// 3) main(): sstr-opt, un mini-mlir-opt con nuestro dialecto registrado.
// =============================================================

#include "SstrDialect.h"
#include "SstrOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/IR/BuiltinDialect.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CommandLine.h"

#include <system_error>

using namespace mlir;

// ------------------------------------------------------------------ //
// 0. codigo generado por mlir-tblgen (definiciones); los .cpp.inc ya
//    abren/cierran su propio namespace sstr y declaran el TypeID.
// ------------------------------------------------------------------ //
#define GET_OP_CLASSES
#include "../gen/SstrOps.cpp.inc"
#define GET_DIALECT_CLASSES
#include "../gen/SstrDialect.cpp.inc"

// registro de las operaciones del dialecto (obligatorio: el constructor
// generado llama a initialize(); sin esto el dialecto queda "a medio"),
void sstr::SstrDialect::initialize() {
  addOperations<sstr::MatmulOp>();
}

// ------------------------------------------------------------------ //
// 1. verifier de sstr.matmul: tensores estaticos, cuadrados, pot. de 2
// ------------------------------------------------------------------ //
static LogicalResult checkSquarePow2(Type t, const char *what) {
  auto rtt = llvm::dyn_cast<RankedTensorType>(t);
  if (!rtt || !rtt.hasStaticShape())
    return emitError(UnknownLoc::get(t.getContext()))
           << what << " debe ser un tensor con forma estatica";
  if (rtt.getRank() != 2 || rtt.getDimSize(0) != rtt.getDimSize(1))
    return emitError(UnknownLoc::get(t.getContext()))
           << what << " debe ser cuadrado (nxm con n==m)";
  if (llvm::isPowerOf2_64(static_cast<uint64_t>(rtt.getDimSize(0))))
    return success();
  return emitError(UnknownLoc::get(t.getContext()))
         << what << " debe tener tamano potencia de 2 (para Strassen)";
}

LogicalResult sstr::MatmulOp::verify() {
  if (failed(checkSquarePow2(getA().getType(), "a")))
    return failure();
  if (failed(checkSquarePow2(getB().getType(), "b")))
    return failure();
  if (getInit().getType() != getA().getType())
    return emitError() << "init debe tener el mismo tipo que a";
  if (getResult().getType() != getA().getType())
    return emitError() << "result debe tener el mismo tipo que a";
  return success();
}

// ------------------------------------------------------------------ //
// 2. helpers de expansion (tensor level)
// ------------------------------------------------------------------ //
namespace {

// suma/resta elemento a elemento via linalg.generic (identidad 1:1 con
// add_sub() del C).
static Value addSub(OpBuilder &b, Location loc, Value X, Value Y, bool isAdd) {
  RankedTensorType t = cast<RankedTensorType>(X.getType());
  auto id = b.getMultiDimIdentityMap(2);
  SmallVector<AffineMap> maps(3, id);
  SmallVector<utils::IteratorType> iters(2, utils::IteratorType::parallel);
  Value empty = b.create<tensor::EmptyOp>(loc, t.getShape(), t.getElementType());
  auto gen = b.create<linalg::GenericOp>(
      loc, TypeRange{Type(t)}, ValueRange{X, Y}, ValueRange{empty}, maps, iters,
      [&](OpBuilder &nb, Location nl, ValueRange args) {
        Value r;
        if (isAdd)
          r = nb.create<arith::AddFOp>(nl, args[0], args[1]);
        else
          r = nb.create<arith::SubFOp>(nl, args[0], args[1]);
        nb.create<linalg::YieldOp>(nl, r);
      });
  return gen.getResult(0);
}

// extrae el cuadrante (row, col) de orden m de un tensor nxn.
// (1:1 con qcpy() del C.)
static Value getQuadrant(OpBuilder &b, Location loc, Value T, int64_t row,
                         int64_t col, int64_t m) {
  RankedTensorType full = cast<RankedTensorType>(T.getType());
  RankedTensorType quad =
      RankedTensorType::get({m, m}, full.getElementType());
  SmallVector<OpFoldResult> offs{b.getIndexAttr(row * m), b.getIndexAttr(col * m)};
  SmallVector<OpFoldResult> sz{b.getIndexAttr(m), b.getIndexAttr(m)};
  SmallVector<OpFoldResult> st{b.getIndexAttr(1), b.getIndexAttr(1)};
  return b.create<tensor::ExtractSliceOp>(loc, quad, T, offs, sz, st);
}

// inserta el cuadrante en la posicion (row, col) de un tensor nxn.
// (1:1 con la recomposicion final del C.)
static Value setQuadrant(OpBuilder &b, Location loc, Value Big, Value Quad,
                         int64_t row, int64_t col, int64_t m) {
  SmallVector<OpFoldResult> offs{b.getIndexAttr(row * m), b.getIndexAttr(col * m)};
  SmallVector<OpFoldResult> sz{b.getIndexAttr(m), b.getIndexAttr(m)};
  SmallVector<OpFoldResult> st{b.getIndexAttr(1), b.getIndexAttr(1)};
  return b.create<tensor::InsertSliceOp>(loc, Quad, Big, offs, sz, st);
}

// fill de ceros para un tensor m x m (init de los subproblemas).
static Value zeroSquare(OpBuilder &b, Location loc, int64_t m) {
  RankedTensorType t = RankedTensorType::get({m, m}, b.getF32Type());
  Value empty = b.create<tensor::EmptyOp>(loc, ArrayRef<int64_t>{m, m},
                                          b.getF32Type());
  Value zero = b.create<arith::ConstantOp>(loc, b.getF32FloatAttr(0.0f));
  return b.create<linalg::FillOp>(loc, TypeRange{Type(t)}, ValueRange{zero},
                                  ValueRange{empty})
      .getResult(0);
}

// producto de matrices clasico (linalg.matmul, destination passing).
static Value naiveMul(OpBuilder &b, Location loc, Value A, Value B,
                      Value init) {
  return b.create<linalg::MatmulOp>(loc, TypeRange{init.getType()},
                                    ValueRange{A, B}, ValueRange{init})
      .getResult(0);
}

// --- expansion Strassen recursiva (unroll en tiempo de compilacion) ---
static Value emitStrassen(OpBuilder &b, Location loc, Value A, Value B,
                          Value init, int64_t n, int64_t cutoff) {
  // caso base: producto clasico.
  if (n <= cutoff)
    return naiveMul(b, loc, A, B, init);

  const int64_t m = n / 2;

  // cuadrantes de A y B (como qcpy del C).
  Value a = getQuadrant(b, loc, A, 0, 0, m);
  Value c = getQuadrant(b, loc, A, 1, 0, m);
  Value bq = getQuadrant(b, loc, A, 0, 1, m);
  Value d = getQuadrant(b, loc, A, 1, 1, m);
  Value e = getQuadrant(b, loc, B, 0, 0, m);
  Value g = getQuadrant(b, loc, B, 1, 0, m);
  Value f = getQuadrant(b, loc, B, 0, 1, m);
  Value h = getQuadrant(b, loc, B, 1, 1, m);

  // los 7 productos M1..M7 (Strassen, 1969).
  Value z0 = zeroSquare(b, loc, m);
  Value p1 = emitStrassen(b, loc, addSub(b, loc, a, d, true),
                          addSub(b, loc, e, h, true), z0, m, cutoff);
  Value p2 = emitStrassen(b, loc, addSub(b, loc, c, d, true), e, z0, m, cutoff);
  Value p3 = emitStrassen(b, loc, a, addSub(b, loc, f, h, false), z0, m, cutoff);
  Value p4 = emitStrassen(b, loc, d, addSub(b, loc, g, e, false), z0, m, cutoff);
  Value p5 = emitStrassen(b, loc, addSub(b, loc, a, bq, true), h, z0, m, cutoff);
  Value p6 = emitStrassen(b, loc, addSub(b, loc, c, a, false),
                          addSub(b, loc, e, f, true), z0, m, cutoff);
  Value p7 = emitStrassen(b, loc, addSub(b, loc, bq, d, false),
                          addSub(b, loc, g, h, true), z0, m, cutoff);

  // recombinar cuadrantes (1:1 con la recomposicion del C).
  Value c11 = addSub(b, loc, addSub(b, loc, addSub(b, loc, p1, p4, true),
                                    p5, false),
                     p7, true);
  Value c12 = addSub(b, loc, p3, p5, true);
  Value c21 = addSub(b, loc, p2, p4, true);
  Value c22 = addSub(b, loc,
                     addSub(b, loc, addSub(b, loc, p1, p2, false), p3, true),
                     p6, true);

  // ir llenando el resultado (init viene de ceros del llamador).
  Value out = init;
  out = setQuadrant(b, loc, out, c11, 0, 0, m);
  out = setQuadrant(b, loc, out, c12, 0, 1, m);
  out = setQuadrant(b, loc, out, c21, 1, 0, m);
  out = setQuadrant(b, loc, out, c22, 1, 1, m);
  return out;
}

// --- rewrite pattern: cada sstr.matmul se reemplaza por su expansion ---
struct MatmulExpandPattern : public OpRewritePattern<sstr::MatmulOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(sstr::MatmulOp op,
                                PatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    RankedTensorType t = cast<RankedTensorType>(op.getA().getType());
    int64_t n = t.getDimSize(0);
    int64_t cutoff = op.getCutoff();

    Value result;
    if (op.getMethod() == "naive") {
      result = naiveMul(rewriter, loc, op.getA(), op.getB(), op.getInit());
    } else if (op.getMethod() == "strassen") {
      result = emitStrassen(rewriter, loc, op.getA(), op.getB(), op.getInit(),
                            n, cutoff);
    } else {
      return op.emitError() << "method desconocido: '" << op.getMethod() << "'";
    }

    rewriter.replaceOp(op, result);
    return success();
  }
};

// --- el pass: corre el pattern sobre cada funcion ---
struct SstrExpandPass
    : public PassWrapper<SstrExpandPass, OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(SstrExpandPass)

  StringRef getArgument() const final { return "sstr-expand"; }
  StringRef getDescription() const final {
    return "Expande sstr.matmul (Strassen o naive) a linalg/tensor/arith";
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<tensor::TensorDialect, linalg::LinalgDialect,
                    arith::ArithDialect>();
  }

  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<MatmulExpandPattern>(&getContext());
    if (failed(applyPatternsAndFoldGreedily(getOperation(),
                                            std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace

// factoria publica del pass
std::unique_ptr<Pass> createSstrExpandPass() {
  return std::make_unique<SstrExpandPass>();
}

// ------------------------------------------------------------------ //
// 3. driver: sstr-opt  (mini-mlir-opt con el dialecto sstr registrado)
// ------------------------------------------------------------------ //
int main(int argc, char **argv) {
  llvm::InitLLVM initLLVM(argc, argv);

  static llvm::cl::opt<std::string> input(llvm::cl::Positional,
                                          llvm::cl::desc("<input .mlir>"),
                                          llvm::cl::init(""));
  static llvm::cl::opt<std::string> output(
      "o", llvm::cl::desc("archivo de salida (default: stdout)"),
      llvm::cl::value_desc("filename"));
  llvm::cl::ParseCommandLineOptions(argc, argv, "sstr-opt\n");

  if (input.empty()) {
    llvm::errs() << "uso: sstr-opt [-o out.mlir] entrada.mlir\n";
    return 1;
  }

  // Contexto con el dialecto sstr + los dialectos estandar que aparecen
  // en el archivo de entrada (builtin, func, arith, tensor, linalg).
  DialectRegistry registry;
  registry.insert<BuiltinDialect, func::FuncDialect, arith::ArithDialect,
                  tensor::TensorDialect, linalg::LinalgDialect,
                  sstr::SstrDialect>();
  MLIRContext context(registry);
  context.loadAllAvailableDialects();

  OwningOpRef<ModuleOp> module = parseSourceFile<ModuleOp>(input, &context);
  if (!module) {
    llvm::errs() << "no se pudo parsear: " << input << "\n";
    return 1;
  }

  // verificar + correr el pass sstr-expand
  if (failed(verify(*module)))
    return 1;

  PassManager pm(&context, ModuleOp::getOperationName());
  pm.addNestedPass<func::FuncOp>(createSstrExpandPass());
  if (failed(pm.run(module.get())))
    return 1;

  // imprimir (a stdout o al archivo pedido)
  if (output.empty()) {
    module->print(llvm::outs());
  } else {
    std::error_code ec;
    llvm::raw_fd_ostream os(output, ec);
    if (ec) {
      llvm::errs() << "no se pudo abrir " << output << ": " << ec.message()
                   << "\n";
      return 1;
    }
    module->print(os);
  }
  return 0;
}