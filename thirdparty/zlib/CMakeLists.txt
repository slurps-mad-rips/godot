project(godot-builtin-zlib LANGUAGES C)

add_library(zlib)

target_include_directories(zlib PUBLIC ${PROJECT_SOURCE_DIR})
target_sources(zlib PRIVATE 
  adler32.c
  compress.c
  crc32.c
  deflate.c
  infback.c
  inffast.c
  inflate.c
  inftrees.c
  trees.c
  uncompr.c
  zutil.c)
