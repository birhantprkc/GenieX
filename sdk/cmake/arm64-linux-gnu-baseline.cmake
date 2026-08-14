set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# gcc-13: default gcc-14 emits CXXABI_1.3.15, missing on Qualcomm Linux. See #458.
set(CMAKE_C_COMPILER aarch64-linux-gnu-gcc-13)
set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++-13)

# Baseline armv8.0-a variant for boards that are not armv8.2 — NPU-less Dragonwing
# IoT SoCs such as unoq. See #1217. Differences from arm64-linux-gnu.cmake:
#
# * No +fp16 / +dotprod: those cores implement neither, so ggml falls back to its
#   fp32 quant kernels. Slower, but it runs.
# * -moutline-atomics instead of the LSE atomics implied by armv8.1+: every atomic
#   goes through libgcc's runtime-dispatched helper, which picks LSE when
#   HWCAP_ATOMICS is set and LL/SC otherwise. This is what fixes the SIGILL on
#   LDADDAL that armv8.2 inlined into every std::mutex.
# * +crc is kept: it is the one guarded extension unoq-class cores do implement.
#
# The runtime CPU guard in sdk/src/ml.cpp derives its HWCAP mask from the
# __ARM_FEATURE_* macros these flags define, so it tracks this line automatically.
set(CMAKE_C_FLAGS "-march=armv8-a+crc -moutline-atomics -ftree-vectorize -fno-finite-math-only -flto -D_GNU_SOURCE")
set(CMAKE_CXX_FLAGS "-march=armv8-a+crc -moutline-atomics -ftree-vectorize -fno-finite-math-only -flto -D_GNU_SOURCE")

message(STATUS "Using baseline armv8.0-a cross compile toolchain for ARM64 Linux (gcc-13)")
