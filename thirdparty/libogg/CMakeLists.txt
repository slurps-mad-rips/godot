project(libogg LANGUAGES C)

add_library(ogg)
target_include_directories(ogg PUBLIC ${PROJECT_SOURCE_DIR})
target_sources(ogg PRIVATE *.c)
