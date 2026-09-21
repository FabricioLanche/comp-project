#ifndef SSTR_DIALECT_H
#define SSTR_DIALECT_H

#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"

#define GET_DIALECT_CLASSES
#include "../gen/SstrDialect.h.inc"

#endif // SSTR_DIALECT_H