project(libvpx LANGUAGES C ASM_NASM)

set(is-amd64 $<STREQUAL:${CMAKE_SYSTEM_PROCESSOR},x86_64>)
set(is-x86 $<STREQUAL:${CMAKE_SYSTEM_PROCESSOR},x86>)

# TODO: Check for mmx, sse2, ssse3, avx2 compile time support?
add_library(vpx-intrin OBJECT)
add_library(vpx-asm OBJECT)
add_library(vpx)


target_include_directories(vpx-intrin PRIVATE ${PROJECT_SOURCE_DIR})
target_include_directories(vpx-asm PRIVATE ${PROJECT_SOURCE_DIR})

target_compile_options(vpx-asm PRIVATE
  $<${is-amd64}:-DX86_64>
  $<${is-x86}:-DX86_32>)

glob(sse2-src FILES_ONLY vp[8-9]/common/x86/*_sse2.c vpx_dsp/x86/*_sse2.c)
glob(avx2-src FILES_ONLY vpx_dsp/x86/*_avx2.c)

set_property(SOURCE ${avx2-src} APPEND PROPERTY 
    COMPILE_OPTIONS $<$<NOT:$<C_COMPILER_ID:MSVC>>:-mavx2>)
set_property(SOURCE vpx_dsp/x86/vpx_subpixel_8t_intrin_ssse3.c
  APPEND PROPERTY COMPILE_OPTIONS $<$<NOT:$<C_COMPILER_ID:MSVC>>:-mssse3>)
set_property(SOURCE ${sse2-src} APPEND PROPERTY
    COMPILE_OPTIONS $<$<NOT:$<C_COMPILER_ID:MSVC>>:-msse2>)
set_property(SOURCE vp8/common/x86/idct_blk_mmx.c
  APPEND PROPERTY COMPILE_OPTIONS $<$<NOT:$<C_COMPILER_ID:MSVC>>:-mmmx)

target_sources(vpx-intrin
  PRIVATE
    $<${is-x86}:vp8/common/x86/idct_blk_mmx.c>
    $<${is-x86}:${sse2-src}>
    $<${is-amd64}:vpx_dsp/x86/vpx_subpixel_8t_intrin_ssse3.c>
    $<${is-amd64}:${avx2-src}>)

glob(x86-asm FILES_ONLY vp8/common/x86/*.asm vpx_dsp/x86/*.asm)
target_sources(vpx-asm
  PRIVATE
    $<${is-amd64}:vpx_dsp/x86/inv_txfm_ssse3_x86_64.asm>
    $<${is-amd64}:vp8/common/x86/loopfilter_block_sse2_x86_64.asm>
    $<${is-x86}:${x86-asm}>
    $<${is-x86}:vpx_ports/emms.asm>)


target_sources(vpx
  PRIVATE
    $<$<PLATFORM_ID:Android>:third_party/android/cpu-features.c>
    $<$<NOT:$<PLATFORM_ID:Emscripten>>:vp8/decoder/threading.c>
    vp8/*.c
    vp8/common/generic/*.c
    vp8/common/*.c

    vp8/decoder/dboolhuff.c
    vp8/decoder/decodeframe.c
    vp8/decoder/decodemv.c
    vp8/decoder/detokenize.c
    vp8/decoder/onyxd_if.c

    vp9/decoder/*.c
    vp9/common/*.c
    vp9/*.c

    $<TARGET_OBJECTS:vpx-intrin>
    $<TARGET_OBJECTS:vpx-asm>

    vpx_scale/generic/*.c
    vpx_scale/*.c
    vpx_util/*.c
    vpx/src/*.c
    vpx_dsp/*.c
    vpx_mem/*.c)

target_include_directories(vpx PUBLIC ${PROJECT_SOURCE_DIR})
