//===- BuiltinTypes.h - MLIR Builtin Type Classes ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_IR_BUILTINTYPES_H
#define MLIR_IR_BUILTINTYPES_H

#include "mlir/IR/Attributes.h"
#include "mlir/IR/Types.h"

namespace llvm {
struct fltSemantics;
} // namespace llvm

namespace mlir {
class AffineExpr;
class AffineMap;
class FloatType;
class Identifier;
class IndexType;
class IntegerType;
class TypeRange;

//===----------------------------------------------------------------------===//
// FloatType
//===----------------------------------------------------------------------===//

class FloatType : public Type {
public:
  using Type::Type;

  // Convenience factories.
  static FloatType getBF16(MLIRContext *ctx);
  static FloatType getF16(MLIRContext *ctx);
  static FloatType getF32(MLIRContext *ctx);
  static FloatType getF64(MLIRContext *ctx);
  static FloatType getF80(MLIRContext *ctx);
  static FloatType getF128(MLIRContext *ctx);

  /// Methods for support type inquiry through isa, cast, and dyn_cast.
  static bool classof(Type type);

  /// Return the bitwidth of this float type.
  unsigned getWidth();

  /// Get or create a new FloatType with bitwidth scaled by `scale`.
  /// Return null if the scaled element type cannot be represented.
  FloatType scaleElementBitwidth(unsigned scale);

  /// Return the floating semantics of this float type.
  const llvm::fltSemantics &getFloatSemantics();
};

//===----------------------------------------------------------------------===//
// ShapedType
//===----------------------------------------------------------------------===//

/// This is a common base class between Vector, UnrankedTensor, RankedTensor,
/// and MemRef types because they share behavior and semantics around shape,
/// rank, and fixed element type. Any type with these semantics should inherit
/// from ShapedType.
class ShapedType : public Type {
public:
  using Type::Type;

  // TODO: merge these two special values in a single one used everywhere.
  // Unfortunately, uses of `-1` have crept deep into the codebase now and are
  // hard to track.
  static constexpr int64_t kDynamicSize = -1;
  static constexpr int64_t kDynamicStrideOrOffset =
      std::numeric_limits<int64_t>::min();

  /// Return clone of this type with new shape and element type.
  ShapedType clone(ArrayRef<int64_t> shape, Type elementType);
  ShapedType clone(ArrayRef<int64_t> shape);
  ShapedType clone(Type elementType);

  /// Return the element type.
  Type getElementType() const;

  /// If an element type is an integer or a float, return its width. Otherwise,
  /// abort.
  unsigned getElementTypeBitWidth() const;

  /// If it has static shape, return the number of elements. Otherwise, abort.
  int64_t getNumElements() const;

  /// If this is a ranked type, return the rank. Otherwise, abort.
  int64_t getRank() const;

  /// Whether or not this is a ranked type. Memrefs, vectors and ranked tensors
  /// have a rank, while unranked tensors do not.
  bool hasRank() const;

  /// If this is a ranked type, return the shape. Otherwise, abort.
  ArrayRef<int64_t> getShape() const;

  /// If this is unranked type or any dimension has unknown size (<0), it
  /// doesn't have static shape. If all dimensions have known size (>= 0), it
  /// has static shape.
  bool hasStaticShape() const;

  /// If this has a static shape and the shape is equal to `shape` return true.
  bool hasStaticShape(ArrayRef<int64_t> shape) const;

  /// If this is a ranked type, return the number of dimensions with dynamic
  /// size. Otherwise, abort.
  int64_t getNumDynamicDims() const;

  /// If this is ranked type, return the size of the specified dimension.
  /// Otherwise, abort.
  int64_t getDimSize(unsigned idx) const;

  /// Returns true if this dimension has a dynamic size (for ranked types);
  /// aborts for unranked types.
  bool isDynamicDim(unsigned idx) const;

  /// Returns the position of the dynamic dimension relative to just the dynamic
  /// dimensions, given its `index` within the shape.
  unsigned getDynamicDimIndex(unsigned index) const;

  /// Get the total amount of bits occupied by a value of this type.  This does
  /// not take into account any memory layout or widening constraints, e.g. a
  /// vector<3xi57> is reported to occupy 3x57=171 bit, even though in practice
  /// it will likely be stored as in a 4xi64 vector register.  Fail an assertion
  /// if the size cannot be computed statically, i.e. if the type has a dynamic
  /// shape or if its elemental type does not have a known bit width.
  int64_t getSizeInBits() const;

  /// Methods for support type inquiry through isa, cast, and dyn_cast.
  static bool classof(Type type);

  /// Whether the given dimension size indicates a dynamic dimension.
  static constexpr bool isDynamic(int64_t dSize) {
    return dSize == kDynamicSize;
  }
  static constexpr bool isDynamicStrideOrOffset(int64_t dStrideOrOffset) {
    return dStrideOrOffset == kDynamicStrideOrOffset;
  }
};

//===----------------------------------------------------------------------===//
// TensorType
//===----------------------------------------------------------------------===//

/// Tensor types represent multi-dimensional arrays, and have two variants:
/// RankedTensorType and UnrankedTensorType.
class TensorType : public ShapedType {
public:
  using ShapedType::ShapedType;

  /// Return true if the specified element type is ok in a tensor.
  static bool isValidElementType(Type type);

  /// Methods for support type inquiry through isa, cast, and dyn_cast.
  static bool classof(Type type);
};

//===----------------------------------------------------------------------===//
// BaseMemRefType
//===----------------------------------------------------------------------===//

/// Base MemRef for Ranked and Unranked variants
class BaseMemRefType : public ShapedType {
public:
  using ShapedType::ShapedType;

  /// Return true if the specified element type is ok in a memref.
  static bool isValidElementType(Type type);

  /// Methods for support type inquiry through isa, cast, and dyn_cast.
  static bool classof(Type type);

  /// Returns the memory space in which data referred to by this memref resides.
  Attribute getMemorySpace() const;

  /// [deprecated] Returns the memory space in old raw integer representation.
  /// New `Attribute getMemorySpace()` method should be used instead.
  unsigned getMemorySpaceAsInt() const;
};

} // end namespace mlir

//===----------------------------------------------------------------------===//
// Tablegen Type Declarations
//===----------------------------------------------------------------------===//

#define GET_TYPEDEF_CLASSES
#include "mlir/IR/BuiltinTypes.h.inc"

namespace mlir {
//===----------------------------------------------------------------------===//
// MemRefType
//===----------------------------------------------------------------------===//

/// This is a builder type that keeps local references to arguments. Arguments
/// that are passed into the builder must out-live the builder.
class MemRefType::Builder {
public:
  // Build from another MemRefType.
  explicit Builder(MemRefType other)
      : shape(other.getShape()), elementType(other.getElementType()),
        affineMaps(other.getAffineMaps()), memorySpace(other.getMemorySpace()) {
  }

  // Build from scratch.
  Builder(ArrayRef<int64_t> shape, Type elementType)
      : shape(shape), elementType(elementType), affineMaps() {}

  Builder &setShape(ArrayRef<int64_t> newShape) {
    shape = newShape;
    return *this;
  }

  Builder &setElementType(Type newElementType) {
    elementType = newElementType;
    return *this;
  }

  Builder &setAffineMaps(ArrayRef<AffineMap> newAffineMaps) {
    affineMaps = newAffineMaps;
    return *this;
  }

  Builder &setMemorySpace(Attribute newMemorySpace) {
    memorySpace = newMemorySpace;
    return *this;
  }

  // [deprecated] `setMemorySpace(Attribute)` should be used instead.
  Builder &setMemorySpace(unsigned newMemorySpace);

  operator MemRefType() {
    return MemRefType::get(shape, elementType, affineMaps, memorySpace);
  }

private:
  ArrayRef<int64_t> shape;
  Type elementType;
  ArrayRef<AffineMap> affineMaps;
  Attribute memorySpace;
};

//===----------------------------------------------------------------------===//
// Deferred Method Definitions
//===----------------------------------------------------------------------===//

inline bool BaseMemRefType::classof(Type type) {
  return type.isa<MemRefType, UnrankedMemRefType>();
}

inline bool BaseMemRefType::isValidElementType(Type type) {
  return type.isIntOrIndexOrFloat() || type.isa<ComplexType, VectorType>();
}

inline bool FloatType::classof(Type type) {
  return type.isa<BFloat16Type, Float16Type, Float32Type, Float64Type,
                  Float80Type, Float128Type>();
}

inline FloatType FloatType::getBF16(MLIRContext *ctx) {
  return BFloat16Type::get(ctx);
}

inline FloatType FloatType::getF16(MLIRContext *ctx) {
  return Float16Type::get(ctx);
}

inline FloatType FloatType::getF32(MLIRContext *ctx) {
  return Float32Type::get(ctx);
}

inline FloatType FloatType::getF64(MLIRContext *ctx) {
  return Float64Type::get(ctx);
}

inline FloatType FloatType::getF80(MLIRContext *ctx) {
  return Float80Type::get(ctx);
}

inline FloatType FloatType::getF128(MLIRContext *ctx) {
  return Float128Type::get(ctx);
}

inline bool ShapedType::classof(Type type) {
  return type.isa<RankedTensorType, VectorType, UnrankedTensorType,
                  UnrankedMemRefType, MemRefType>();
}

inline bool TensorType::classof(Type type) {
  return type.isa<RankedTensorType, UnrankedTensorType>();
}

//===----------------------------------------------------------------------===//
// Type Utilities
//===----------------------------------------------------------------------===//

/// Returns the strides of the MemRef if the layout map is in strided form.
/// MemRefs with layout maps in strided form include:
///   1. empty or identity layout map, in which case the stride information is
///      the canonical form computed from sizes;
///   2. single affine map layout of the form `K + k0 * d0 + ... kn * dn`,
///      where K and ki's are constants or symbols.
///
/// A stride specification is a list of integer values that are either static
/// or dynamic (encoded with getDynamicStrideOrOffset()). Strides encode the
/// distance in the number of elements between successive entries along a
/// particular dimension. For example, `memref<42x16xf32, (64 * d0 + d1)>`
/// specifies a view into a non-contiguous memory region of `42` by `16` `f32`
/// elements in which the distance between two consecutive elements along the
/// outer dimension is `1` and the distance between two consecutive elements
/// along the inner dimension is `64`.
///
/// Returns whether a simple strided form can be extracted from the composition
/// of the layout map.
///
/// The convention is that the strides for dimensions d0, .. dn appear in
/// order to make indexing intuitive into the result.
LogicalResult getStridesAndOffset(MemRefType t,
                                  SmallVectorImpl<int64_t> &strides,
                                  int64_t &offset);
LogicalResult getStridesAndOffset(MemRefType t,
                                  SmallVectorImpl<AffineExpr> &strides,
                                  AffineExpr &offset);

/// Given a list of strides (in which MemRefType::getDynamicStrideOrOffset()
/// represents a dynamic value), return the single result AffineMap which
/// represents the linearized strided layout map. Dimensions correspond to the
/// offset followed by the strides in order. Symbols are inserted for each
/// dynamic dimension in order. A stride cannot take value `0`.
///
/// Examples:
/// =========
///
///   1. For offset: 0 strides: ?, ?, 1 return
///         (i, j, k)[M, N]->(M * i + N * j + k)
///
///   2. For offset: 3 strides: 32, ?, 16 return
///         (i, j, k)[M]->(3 + 32 * i + M * j + 16 * k)
///
///   3. For offset: ? strides: ?, ?, ? return
///         (i, j, k)[off, M, N, P]->(off + M * i + N * j + P * k)
AffineMap makeStridedLinearLayoutMap(ArrayRef<int64_t> strides, int64_t offset,
                                     MLIRContext *context);

/// Return a version of `t` with identity layout if it can be determined
/// statically that the layout is the canonical contiguous strided layout.
/// Otherwise pass `t`'s layout into `simplifyAffineMap` and return a copy of
/// `t` with simplified layout.
MemRefType canonicalizeStridedLayout(MemRefType t);

/// Return a version of `t` with a layout that has all dynamic offset and
/// strides. This is used to erase the static layout.
MemRefType eraseStridedLayout(MemRefType t);

/// Given MemRef `sizes` that are either static or dynamic, returns the
/// canonical "contiguous" strides AffineExpr. Strides are multiplicative and
/// once a dynamic dimension is encountered, all canonical strides become
/// dynamic and need to be encoded with a different symbol.
/// For canonical strides expressions, the offset is always 0 and and fastest
/// varying stride is always `1`.
///
/// Examples:
///   - memref<3x4x5xf32> has canonical stride expression
///         `20*exprs[0] + 5*exprs[1] + exprs[2]`.
///   - memref<3x?x5xf32> has canonical stride expression
///         `s0*exprs[0] + 5*exprs[1] + exprs[2]`.
///   - memref<3x4x?xf32> has canonical stride expression
///         `s1*exprs[0] + s0*exprs[1] + exprs[2]`.
AffineExpr makeCanonicalStridedLayoutExpr(ArrayRef<int64_t> sizes,
                                          ArrayRef<AffineExpr> exprs,
                                          MLIRContext *context);

/// Return the result of makeCanonicalStrudedLayoutExpr for the common case
/// where `exprs` is {d0, d1, .., d_(sizes.size()-1)}
AffineExpr makeCanonicalStridedLayoutExpr(ArrayRef<int64_t> sizes,
                                          MLIRContext *context);

/// Return true if the layout for `t` is compatible with strided semantics.
bool isStrided(MemRefType t);

/// Return the layout map in strided linear layout AffineMap form.
/// Return null if the layout is not compatible with a strided layout.
AffineMap getStridedLinearLayoutMap(MemRefType t);

} // end namespace mlir

#endif // MLIR_IR_BUILTINTYPES_H
