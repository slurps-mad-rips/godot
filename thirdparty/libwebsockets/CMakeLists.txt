project(websockets LANGUAGES C)

# TODO: Improve
if (NOT TARGET mbedTLS)
  error("libwebsockets requires mbedTLS")
endif()

genex(is-windows $<OR:
  $<PLATFORM_ID:WindowsStore>,
  $<PLATFORM_ID:Windows>
>)

add_library(websockets)
target_include_directories(websockets PUBLIC ${PROJECT_SOURCE_DIR})
target_sources(websockets
  PRIVATE
    core/*.c
    event-libs/poll/*.c
    $<$<PLATFORM_ID:Android>:misc/getifaddrs.c>
    misc/base64-decode.c
    misc/lejp.c
    misc/sha-1.c
    roles/listen/*.c
    roles/pipe/*.c
    roles/raw/*.c
    roles/h1/*.c
    roles/ws/*.c
    roles/http/client/*.c
    roles/http/server/fops-zip.c
    roles/http/server/lejp-conf.c
    roles/http/server/parsers.c
    roles/http/server/server.c
    roles/http/header.c

    tls/mbedtls/platform/*.c
    tls/mbedtls/library/*.c
    tls/mbedtls/*.c
    tls/*.c

    $<${is-windows}:plat/lws-plat-win.c>
    $<${is-windows}:win32helpers/getopt.c>
    $<${is-windows}:win32helpers/getopt_long.c>
    $<${is-windows}:win32helpers/gettimeofday.c>
    $<$<NOT:${is-windows}>:plat/lws-plat-unix.c>)

target_include_directories(websockets
  PUBLIC
    ${PROJECT_SOURCE_DIR}/tls/mbedtls/wrapper/include/platform
    ${PROJECT_SOURCE_DIR}/tls/mbedtls/wrapper/include/internal
    ${PROJECT_SOURCE_DIR}/tls/mbedtls/wrapper/include/openssl
    ${PROJECT_SOURCE_DIR}/tls/mbedtls/wrapper/include
    $<${is-windows}:${PROJECT_SOURCE_DIR}/win32helpers>)

target_compile_options(websockets
  PRIVATE
    # TODO: Check that this is correct...
    $<$<AND:$<PLATFORM_ID:WindowsStore>,$<C_COMPILER_ID:MSVC>>:/DLWS_MINGW_SUPPORT>)

target_link_libraries(websockets PRIVATE mbedTLS)
