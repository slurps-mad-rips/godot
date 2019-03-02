project(godot-builtin-minizip LANGUAGES C)

add_library(minizip)

target_include_directories(minizip PUBLIC ${PROJECT_SOURCE_DIR})
target_sources(minizip PRIVATE ioapi.c unzip.c zip.c)
