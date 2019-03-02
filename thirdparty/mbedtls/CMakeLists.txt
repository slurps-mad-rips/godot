project(mbedTLS LANGUAGES C)

add_library(mbedTLS)
target_sources(mbedTLS PRIVATE library/*.c)
target_include_directories(mbedTLS PUBLIC include)
