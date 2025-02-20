; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=ilp32d -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=lp64d -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x half> @masked_load_nxv1f16(<vscale x 1 x half>* %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x half> @llvm.masked.load.nxv1f16(<vscale x 1 x half>* %a, i32 2, <vscale x 1 x i1> %mask, <vscale x 1 x half> undef)
  ret <vscale x 1 x half> %load
}
declare <vscale x 1 x half> @llvm.masked.load.nxv1f16(<vscale x 1 x half>*, i32, <vscale x 1 x i1>, <vscale x 1 x half>)

define <vscale x 1 x float> @masked_load_nxv1f32(<vscale x 1 x float>* %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x float> @llvm.masked.load.nxv1f32(<vscale x 1 x float>* %a, i32 4, <vscale x 1 x i1> %mask, <vscale x 1 x float> undef)
  ret <vscale x 1 x float> %load
}
declare <vscale x 1 x float> @llvm.masked.load.nxv1f32(<vscale x 1 x float>*, i32, <vscale x 1 x i1>, <vscale x 1 x float>)

define <vscale x 1 x double> @masked_load_nxv1f64(<vscale x 1 x double>* %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m1,ta,mu
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x double> @llvm.masked.load.nxv1f64(<vscale x 1 x double>* %a, i32 8, <vscale x 1 x i1> %mask, <vscale x 1 x double> undef)
  ret <vscale x 1 x double> %load
}
declare <vscale x 1 x double> @llvm.masked.load.nxv1f64(<vscale x 1 x double>*, i32, <vscale x 1 x i1>, <vscale x 1 x double>)

define <vscale x 2 x half> @masked_load_nxv2f16(<vscale x 2 x half>* %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x half> @llvm.masked.load.nxv2f16(<vscale x 2 x half>* %a, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x half> undef)
  ret <vscale x 2 x half> %load
}
declare <vscale x 2 x half> @llvm.masked.load.nxv2f16(<vscale x 2 x half>*, i32, <vscale x 2 x i1>, <vscale x 2 x half>)

define <vscale x 2 x float> @masked_load_nxv2f32(<vscale x 2 x float>* %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x float> @llvm.masked.load.nxv2f32(<vscale x 2 x float>* %a, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x float> undef)
  ret <vscale x 2 x float> %load
}
declare <vscale x 2 x float> @llvm.masked.load.nxv2f32(<vscale x 2 x float>*, i32, <vscale x 2 x i1>, <vscale x 2 x float>)

define <vscale x 2 x double> @masked_load_nxv2f64(<vscale x 2 x double>* %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m2,ta,mu
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x double> @llvm.masked.load.nxv2f64(<vscale x 2 x double>* %a, i32 8, <vscale x 2 x i1> %mask, <vscale x 2 x double> undef)
  ret <vscale x 2 x double> %load
}
declare <vscale x 2 x double> @llvm.masked.load.nxv2f64(<vscale x 2 x double>*, i32, <vscale x 2 x i1>, <vscale x 2 x double>)

define <vscale x 4 x half> @masked_load_nxv4f16(<vscale x 4 x half>* %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m1,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x half> @llvm.masked.load.nxv4f16(<vscale x 4 x half>* %a, i32 2, <vscale x 4 x i1> %mask, <vscale x 4 x half> undef)
  ret <vscale x 4 x half> %load
}
declare <vscale x 4 x half> @llvm.masked.load.nxv4f16(<vscale x 4 x half>*, i32, <vscale x 4 x i1>, <vscale x 4 x half>)

define <vscale x 4 x float> @masked_load_nxv4f32(<vscale x 4 x float>* %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m2,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x float> @llvm.masked.load.nxv4f32(<vscale x 4 x float>* %a, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x float> undef)
  ret <vscale x 4 x float> %load
}
declare <vscale x 4 x float> @llvm.masked.load.nxv4f32(<vscale x 4 x float>*, i32, <vscale x 4 x i1>, <vscale x 4 x float>)

define <vscale x 4 x double> @masked_load_nxv4f64(<vscale x 4 x double>* %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m4,ta,mu
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x double> @llvm.masked.load.nxv4f64(<vscale x 4 x double>* %a, i32 8, <vscale x 4 x i1> %mask, <vscale x 4 x double> undef)
  ret <vscale x 4 x double> %load
}
declare <vscale x 4 x double> @llvm.masked.load.nxv4f64(<vscale x 4 x double>*, i32, <vscale x 4 x i1>, <vscale x 4 x double>)

define <vscale x 8 x half> @masked_load_nxv8f16(<vscale x 8 x half>* %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m2,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x half> @llvm.masked.load.nxv8f16(<vscale x 8 x half>* %a, i32 2, <vscale x 8 x i1> %mask, <vscale x 8 x half> undef)
  ret <vscale x 8 x half> %load
}
declare <vscale x 8 x half> @llvm.masked.load.nxv8f16(<vscale x 8 x half>*, i32, <vscale x 8 x i1>, <vscale x 8 x half>)

define <vscale x 8 x float> @masked_load_nxv8f32(<vscale x 8 x float>* %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m4,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x float> @llvm.masked.load.nxv8f32(<vscale x 8 x float>* %a, i32 4, <vscale x 8 x i1> %mask, <vscale x 8 x float> undef)
  ret <vscale x 8 x float> %load
}
declare <vscale x 8 x float> @llvm.masked.load.nxv8f32(<vscale x 8 x float>*, i32, <vscale x 8 x i1>, <vscale x 8 x float>)

define <vscale x 8 x double> @masked_load_nxv8f64(<vscale x 8 x double>* %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m8,tu,mu
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x double> @llvm.masked.load.nxv8f64(<vscale x 8 x double>* %a, i32 8, <vscale x 8 x i1> %mask, <vscale x 8 x double> undef)
  ret <vscale x 8 x double> %load
}
declare <vscale x 8 x double> @llvm.masked.load.nxv8f64(<vscale x 8 x double>*, i32, <vscale x 8 x i1>, <vscale x 8 x double>)

define <vscale x 16 x half> @masked_load_nxv16f16(<vscale x 16 x half>* %a, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m4,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 16 x half> @llvm.masked.load.nxv16f16(<vscale x 16 x half>* %a, i32 2, <vscale x 16 x i1> %mask, <vscale x 16 x half> undef)
  ret <vscale x 16 x half> %load
}
declare <vscale x 16 x half> @llvm.masked.load.nxv16f16(<vscale x 16 x half>*, i32, <vscale x 16 x i1>, <vscale x 16 x half>)

define <vscale x 16 x float> @masked_load_nxv16f32(<vscale x 16 x float>* %a, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m8,tu,mu
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 16 x float> @llvm.masked.load.nxv16f32(<vscale x 16 x float>* %a, i32 4, <vscale x 16 x i1> %mask, <vscale x 16 x float> undef)
  ret <vscale x 16 x float> %load
}
declare <vscale x 16 x float> @llvm.masked.load.nxv16f32(<vscale x 16 x float>*, i32, <vscale x 16 x i1>, <vscale x 16 x float>)

define <vscale x 32 x half> @masked_load_nxv32f16(<vscale x 32 x half>* %a, <vscale x 32 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m8,tu,mu
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 32 x half> @llvm.masked.load.nxv32f16(<vscale x 32 x half>* %a, i32 2, <vscale x 32 x i1> %mask, <vscale x 32 x half> undef)
  ret <vscale x 32 x half> %load
}
declare <vscale x 32 x half> @llvm.masked.load.nxv32f16(<vscale x 32 x half>*, i32, <vscale x 32 x i1>, <vscale x 32 x half>)
