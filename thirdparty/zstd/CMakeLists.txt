project(godot-builtin-zstd LANGUAGES C)

add_library(zstd)
target_include_directories(zstd
  PUBLIC ${PROJECT_SOURCE_DIR}
  PRIVATE
    decompress
    compress
    common)
target_sources(zstd PRIVATE common/*.c compress/*.c decompress/*.c)
