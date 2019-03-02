project(libpng LANGUAGES C)

add_library(png)
target_sources(png PRIVATE *.c)
target_include_directories(png PUBLIC ${PROJECT_SOURCE_DIR})
