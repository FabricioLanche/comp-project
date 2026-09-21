#ifndef SSTR_OPS_H
#define SSTR_OPS_H

#include "SstrDialect.h"
#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

#define GET_OP_CLASSES
#include "../gen/SstrOps.h.inc"

#endif // SSTR_OPS_H