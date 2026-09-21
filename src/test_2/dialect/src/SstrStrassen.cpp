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
#define GET_OP_CLASSES
#include "../gen/SstrOps.cpp.inc"
#define GET_DIALECT_CLASSES
#include "../gen/SstrDialect.cpp.inc"

// ------------------------------------------------------------------ //
// 1. registro del dialecto y verifier de sstr.matmul
// ------------------------------------------------------------------ //
// 1.1 registra la operacion MatmulOp en el dialecto.
void sstr::SstrDialect::initialize() {
  addOperations<sstr::MatmulOp>();
}

// 1.2 checkSquarePow2: comprueba forma estatica, cuadrada y
//     potencia de 2 (requisitos de Strassen) de un tensor.
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

// 1.3 verifica las invariantes de sstr.matmul (a, b, init y result).
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
// 2. expansion de sstr.matmul a linalg/tensor/arith
// ------------------------------------------------------------------ //
namespace {
  // 2.1 suma o resta dos tensores elemento a elemento (linalg.generic).
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

  // 2.2 extrae el cuadrante (row, col) de orden m (tensor.extract_slice).
  static Value getQuadrant(OpBuilder &b, Location loc, Value T, int64_t row,
                          int64_t col, int64_t m) {
    RankedTensorType full = cast<RankedTensorType>(T.getType());
    RankedTensorType quad = RankedTensorType::get({m, m}, full.getElementType());
    SmallVector<OpFoldResult> offs{b.getIndexAttr(row * m), b.getIndexAttr(col * m)};
    SmallVector<OpFoldResult> sz{b.getIndexAttr(m), b.getIndexAttr(m)};
    SmallVector<OpFoldResult> st{b.getIndexAttr(1), b.getIndexAttr(1)};
    return b.create<tensor::ExtractSliceOp>(loc, quad, T, offs, sz, st);
  }

  // 2.3 inserta un cuadrante en la posicion (row, col) de un tensor
  //     grande (tensor.insert_slice).
  static Value setQuadrant(OpBuilder &b, Location loc, Value Big, Value Quad, int64_t row, int64_t col, int64_t m) {
    SmallVector<OpFoldResult> offs{b.getIndexAttr(row * m), b.getIndexAttr(col * m)};
    SmallVector<OpFoldResult> sz{b.getIndexAttr(m), b.getIndexAttr(m)};
    SmallVector<OpFoldResult> st{b.getIndexAttr(1), b.getIndexAttr(1)};
    return b.create<tensor::InsertSliceOp>(loc, Quad, Big, offs, sz, st);
  }

  // 2.4 crea un tensor m x m lleno de ceros (init de los subproblemas).
  static Value zeroSquare(OpBuilder &b, Location loc, int64_t m) {
    RankedTensorType t = RankedTensorType::get({m, m}, b.getF32Type());
    Value empty = b.create<tensor::EmptyOp>(loc, ArrayRef<int64_t>{m, m}, b.getF32Type());
    Value zero = b.create<arith::ConstantOp>(loc, b.getF32FloatAttr(0.0f));
    return b.create<linalg::FillOp>(loc, TypeRange{Type(t)}, ValueRange{zero}, ValueRange{empty}).getResult(0);
  }

  // 2.5 producto de matrices clasico (linalg.matmul, destination passing).
  static Value naiveMul(OpBuilder &b, Location loc, Value A, Value B, Value init) {
    return b.create<linalg::MatmulOp>(loc, TypeRange{init.getType()}, ValueRange{A, B}, ValueRange{init}).getResult(0);
  }

  // 2.6 expansion recursiva de Strassen hasta el corte de tamano.
  static Value emitStrassen(OpBuilder &b, Location loc, Value A, Value B, Value init, int64_t n, int64_t cutoff) {
    if (n <= cutoff)
      return naiveMul(b, loc, A, B, init);

    const int64_t m = n / 2;

    // 2.6.1 cuadrantes de A y B.
    Value a = getQuadrant(b, loc, A, 0, 0, m);
    Value c = getQuadrant(b, loc, A, 1, 0, m);
    Value bq = getQuadrant(b, loc, A, 0, 1, m);
    Value d = getQuadrant(b, loc, A, 1, 1, m);
    Value e = getQuadrant(b, loc, B, 0, 0, m);
    Value g = getQuadrant(b, loc, B, 1, 0, m);
    Value f = getQuadrant(b, loc, B, 0, 1, m);
    Value h = getQuadrant(b, loc, B, 1, 1, m);

    // 2.6.2 los siete productos M1..M7.
    Value z0 = zeroSquare(b, loc, m);
    Value p1 = emitStrassen(b, loc, addSub(b, loc, a, d, true), addSub(b, loc, e, h, true), z0, m, cutoff);
    Value p2 = emitStrassen(b, loc, addSub(b, loc, c, d, true), e, z0, m, cutoff);
    Value p3 = emitStrassen(b, loc, a, addSub(b, loc, f, h, false), z0, m, cutoff);
    Value p4 = emitStrassen(b, loc, d, addSub(b, loc, g, e, false), z0, m, cutoff);
    Value p5 = emitStrassen(b, loc, addSub(b, loc, a, bq, true), h, z0, m, cutoff);
    Value p6 = emitStrassen(b, loc, addSub(b, loc, c, a, false), addSub(b, loc, e, f, true), z0, m, cutoff);
    Value p7 = emitStrassen(b, loc, addSub(b, loc, bq, d, false), addSub(b, loc, g, h, true), z0, m, cutoff);

    // 2.6.3 recombinacion de los cuadrantes C11..C22.
    Value c11 = addSub(b, loc, addSub(b, loc, addSub(b, loc, p1, p4, true), p5, false), p7, true);
    Value c12 = addSub(b, loc, p3, p5, true);
    Value c21 = addSub(b, loc, p2, p4, true);
    Value c22 = addSub(b, loc, addSub(b, loc, addSub(b, loc, p1, p2, false), p3, true), p6, true);

    // 2.6.4 armado del tensor resultado sobre el init.
    Value out = init;
    out = setQuadrant(b, loc, out, c11, 0, 0, m);
    out = setQuadrant(b, loc, out, c12, 0, 1, m);
    out = setQuadrant(b, loc, out, c21, 1, 0, m);
    out = setQuadrant(b, loc, out, c22, 1, 1, m);
    return out;
  }

  // 2.7 patrón de reescritura que sustituye cada sstr.matmul por su expansión.
  struct MatmulExpandPattern : public OpRewritePattern<sstr::MatmulOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(sstr::MatmulOp op, PatternRewriter &rewriter) const override {
      Location loc = op.getLoc();
      RankedTensorType t = cast<RankedTensorType>(op.getA().getType());
      int64_t n = t.getDimSize(0);
      int64_t cutoff = op.getCutoff();

      Value result;
      if (op.getMethod() == "naive") {
        result = naiveMul(rewriter, loc, op.getA(), op.getB(), op.getInit());
      } else if (op.getMethod() == "strassen") {
        result = emitStrassen(rewriter, loc, op.getA(), op.getB(), op.getInit(), n, cutoff);
      } else {
        return op.emitError() << "method desconocido: '" << op.getMethod() << "'";
      }

      rewriter.replaceOp(op, result);
      return success();
    }
  };

  // 2.8 pase que aplica el patrón sobre cada función.
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
} 

// 2.9 factoría pública del pase sstr-expand.
std::unique_ptr<Pass> createSstrExpandPass() {
  return std::make_unique<SstrExpandPass>();
}

// ------------------------------------------------------------------ //
// 3. driver: sstr-opt  (mini-mlir-opt con el dialecto sstr registrado)
// ------------------------------------------------------------------ //
int main(int argc, char **argv) {
  // 3.1 inicializa LLVM y define las opciones de linea de comandos.
  llvm::InitLLVM initLLVM(argc, argv);

  static llvm::cl::opt<std::string> input(llvm::cl::Positional, llvm::cl::desc("<input .mlir>"), llvm::cl::init(""));
  static llvm::cl::opt<std::string> output("o", llvm::cl::desc("archivo de salida (default: stdout)"), llvm::cl::value_desc("filename"));
  llvm::cl::ParseCommandLineOptions(argc, argv, "sstr-opt\n");

  if (input.empty()) {
    llvm::errs() << "uso: sstr-opt [-o out.mlir] entrada.mlir\n";
    return 1;
  }

  // 3.2 registra los dialectos y crea el contexto MLIR.
  DialectRegistry registry;
  registry.insert<BuiltinDialect, func::FuncDialect, arith::ArithDialect, tensor::TensorDialect, linalg::LinalgDialect, sstr::SstrDialect>();
  MLIRContext context(registry);
  context.loadAllAvailableDialects();

  // 3.3 lee y verifica el modulo de entrada.
  OwningOpRef<ModuleOp> module = parseSourceFile<ModuleOp>(input, &context);
  if (!module) {
    llvm::errs() << "no se pudo parsear: " << input << "\n";
    return 1;
  }

  if (failed(verify(*module)))
    return 1;

  // 3.4 ejecuta el pase sstr-expand sobre las funciones del modulo.
  PassManager pm(&context, ModuleOp::getOperationName());
  pm.addNestedPass<func::FuncOp>(createSstrExpandPass());
  if (failed(pm.run(module.get())))
    return 1;

  // 3.5 imprime el resultado a stdout o al archivo pedido.
  if (output.empty()) {
    module->print(llvm::outs());
  } else {
    std::error_code ec;
    llvm::raw_fd_ostream os(output, ec);
    if (ec) {
      llvm::errs() << "no se pudo abrir " << output << ": " << ec.message() << "\n";
      return 1;
    }
    module->print(os);
  }
  return 0;
}