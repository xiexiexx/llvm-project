// RUN: mlir-opt %s \
// RUN:   -gpu-kernel-outlining \
// RUN:   -pass-pipeline='gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)' \
// RUN:   -gpu-to-llvm \
// RUN: | mlir-cpu-runner \
// RUN:   --shared-libs=%linalg_test_lib_dir/libmlir_cuda_runtime%shlibext \
// RUN:   --shared-libs=%linalg_test_lib_dir/libmlir_runner_utils%shlibext \
// RUN:   --entry-point-result=void \
// RUN: | FileCheck %s

// CHECK: [4, 5, 6, 7, 0, 1, 2, 3, 12, -1, -1, -1, 8]
func @main() {
  %arg = alloc() : memref<13xf32>
  %dst = memref_cast %arg : memref<13xf32> to memref<?xf32>
  %one = constant 1 : index
  %c0 = constant 0 : index
  %sx = dim %dst, %c0 : memref<?xf32>
  %cast_dst = memref_cast %dst : memref<?xf32> to memref<*xf32>
  gpu.host_register %cast_dst : memref<*xf32>
  gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %one, %grid_y = %one, %grid_z = %one)
             threads(%tx, %ty, %tz) in (%block_x = %sx, %block_y = %one, %block_z = %one) {
    %t0 = index_cast %tx : index to i32
    %val = sitofp %t0 : i32 to f32
    %width = index_cast %block_x : index to i32
    %offset = constant 4 : i32
    %shfl, %valid = gpu.shuffle %val, %offset, %width xor : f32
    cond_br %valid, ^bb1(%shfl : f32), ^bb0
  ^bb0:
    %m1 = constant -1.0 : f32
    br ^bb1(%m1 : f32)
  ^bb1(%value : f32):
    store %value, %dst[%tx] : memref<?xf32>
    gpu.terminator
  }
  call @print_memref_f32(%cast_dst) : (memref<*xf32>) -> ()
  return
}

func private @print_memref_f32(%ptr : memref<*xf32>)
