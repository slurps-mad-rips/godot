project(nanosvg LANGUAGES CXX)

add_library(nanosvg)

target_include_directories(nanosvg PUBLIC ${PROJECT_SOURCE_DIR})
target_sources(nanosvg PRIVATE *.cc)
