project(pcre2 LANGUAGES C)

add_library(pcre2-utf32)
add_library(pcre2-utf16)

target_include_directories(pcre2-utf32 PUBLIC src)
target_include_directories(pcre2-utf16 PUBLIC src)

target_compile_definitions(pcre2-utf32
  PUBLIC
    PCRE2_CODE_UNIT_WIDTH=32
    PCRE2_STATIC
    HAVE_CONFIG_H
    SUPPORT_JIT=0)

target_compile_definitions(pcre2-utf16
  PUBLIC
    PCRE2_CODE_UNIT_WIDTH=16
    PCRE2_STATIC
    HAVE_CONFIG_H
    SUPPORT_JIT=0)

glob(pcre2-sources FILES_ONLY EXCLUDE ".*(misc|match).c" src/*.c)
target_sources(pcre2-utf32 PRIVATE ${pcre2-sources})
target_sources(pcre2-utf16 PRIVATE ${pcre2-sources})
