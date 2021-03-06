cmake_minimum_required(VERSION 3.13)
include(FetchContent)
FetchContent_Declare(ixm URL https://get.ixm.one)
FetchContent_GetProperties(ixm)
if (NOT ixm_POPULATED)
  FetchContent_Populate(ixm)
  add_subdirectory(${ixm_SOURCE_DIR} ${ixm_BINARY_DIR})
endif()
project(godot
  VERSION 3.1
  DESCRIPTION "The Godot Game Engine"
  HOMEPAGE_URL "https://godotengine.org/"
  LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/packages)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

if (NOT CMAKE_BUILD_TYPE)
  message(FATAL_ERROR "CMAKE_BUILD_TYPE has not been explicitly set")
endif()

include(CMakePackageConfigHelpers)

include(CheckStructHasMember)
include(CheckIncludeFiles)
include(CheckIPOSupported)

# Custom Modules Located here
include(DependentOption)

include(CheckSourceCompiles)
include(CheckSourceRuns)

include(CheckCompilerFlag)
include(CheckSymbolExists)
include(CheckTypeExists)
include(CheckHeaders)

find_package(PkgConfig)

# Tools
find_package(Python REQUIRED COMPONENTS Interpreter Development)
find_package(Poetry REQUIRED) # This lets us have (more or less) hermetic builds
find_package(ClangFormat)
find_package(ClangCheck)
find_package(ClangTidy)
find_package(CppCheck)
find_package(SCCache)
find_package(CCache)
find_package(IWYU)
find_package(Git REQUIRED)

# Dependencies -- These are all local FindXXX.cmake files
find_package(PCRE2 COMPONENTS UTF8 UTF16 UTF32)
find_package(WebSockets)
find_package(MiniUPnPC)
find_package(Freetype)
find_package(mbedTLS)
find_package(OpenGL)
find_package(Vulkan)
find_package(Squish)
find_package(Theora)
find_package(Vorbis)

# TODO: Rewrite all Find<3CharFileExtension> modules to be Uppercased
# File Formats
find_package(ZLIB)
find_package(WebM)
find_package(Opus)
find_package(Ogg)

###############################################################################
find_package(VPX)
find_package(PNG)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if (TARGET SCCache::SCCache)
  get_property(CMAKE_CXX_COMPILER_LAUNCHER
    TARGET SCCache::SCCache
    PROPERTY IMPORTED_LOCATION)
  get_property(CMAKE_C_COMPILER_LAUNCHER
    TARGET SCCache::SCCache
    PROPERTY IMPORTED_LOCATION)
endif()

option(WITH_EDITOR "Build the Godot editor" ON)

# Binary Packaging Targets
option(PACKAGE_DMG "Create a MacOS DMG Image")
option(PACKAGE_APP "Create a Linux AppImage") # not currently supported by CMake
option(PACKAGE_DEB "Create a Debian Package")
option(PACKAGE_RPM "Create an RPM Package")
option(PACKAGE_MSI "Create a Windows MSI")
option(PACKAGE_PKG "Create a FreeBSD pkg")

# Source Distribution Targets
option(ARCHIVE_TBZ2 "Create a .tar.bz2 archive")
option(ARCHIVE_TGZ "Create a .tar.gz archive")
option(ARCHIVE_TXZ "Create a .tar.xz archive")
option(ARCHIVE_TZ "Create a .tar.Z archive")
option(ARCHIVE_ZIP "Create a .zip archive")
option(ARCHIVE_7Z "Create a .7z archive")

# TODO
#option(SANITIZE_SAFE_STACK "Use the SafeStack Sanitizer")
#option(SANITIZE_UNDEFINED "Use the Undefined Behavior Sanitizer")
#option(SANITIZE_COVERAGE "Use Code Coverage Sanitizer")
#option(SANITIZE_DATAFLOW "Use the DataFlow Sanitizer")
#option(SANITIZE_ADDRESS "Use the Address Aanitizer")
#option(SANITIZE_THREAD "Use the Thread Sanitizer")
#option(SANITIZE_MEMORY "Use the Memory Sanitizer")
#option(SANITIZE_LEAK "Use the Leak Sanitizer")
#option(SANITIZE_CFI "Use Control Flow Integrity")

#option(ANALYZE_THREAD_SAFETY "Enable Thread Safety Analysis")

# These tools will be used for development if desired by users
#option(USE_TOOL_CLANG_TIDY "Use the clang-tidy tool")
#option(USE_TOOL_CPPCHECK "Use CppCheck")
#option(USE_TOOL_SCCACHE "Use the SCCache compiler caching tool")
#option(USE_TOOL_CCACHE "Use the CCache compiler caching tool")
#option(USE_TOOL_IWYU "Use include-what-you-use")

# Project wide compile time options
#option(WITH_COVERAGE "Compile with code coverage")
#option(WITH_OMP "Compile with OpenMP support")
#option(WITH_LTO "Compile with link-time optimization")

# Disabling these will permit users to use prebuilt libraries on their own system
option(USE_BUILTIN_LIBWEBSOCKETS "Use the built-in libwebsockets library" ON) #find_package
option(USE_BUILTIN_THEKLA_ATLAS "Use the built-in thekla_atlas library" ON) #find_package
option(USE_BUILTIN_MINIUPNPC "Use the built-in miniupnpc library" ON) #find_package
option(USE_BUILTIN_LIBTHEORA "Use the built-in libtheora library" ON) #find_package
option(USE_BUILTIN_LIBVORBIS "Use the built-in libvorbis library" ON) #find_package
option(USE_BUILTIN_FREETYPE "Use the built-in FreeType library" ON) #find_package
option(USE_BUILTIN_MBEDTLS "Use the built-in mbedTLS library" ON) #find_package
option(USE_BUILTIN_LIBWEBP "Use the built-in libwebp library" ON) #find_package
option(USE_BUILTIN_LIBOGG "Use the built-in libogg library" ON) #find_package
option(USE_BUILTIN_LIBPNG "Use the built-in libpng library" ON) # find_package
option(USE_BUILTIN_LIBVPX "Use the built-in libvpx library" ON) # find_package
option(USE_BUILTIN_BULLET "Use the built-in Bullet library" ON)
option(USE_BUILTIN_SQUISH "Use the built-in squish library" ON) # find_package
option(USE_BUILTIN_RECAST "Use the built-in Recast library" ON) # find_package
option(USE_BUILTIN_PCRE2 "Use the built-in PCRE2 library" ON)
option(USE_BUILTIN_OPUS "Use the built-in Opus library" ON) #find_package
option(USE_BUILTIN_ZLIB "Use the built-in ZLib library" ON) #find_package
option(USE_BUILTIN_ZSTD "Use the built-in ZStd library" ON) #find_package
option(USE_BUILTIN_ENET "Use the built-in ENet library" ON)

# Build Features
option(ENABLE_DEPRECATED "Enable deprecated features" ON)
option(ENABLE_GDSCRIPT "Enable GDScript support" ON)
option(ENABLE_MINIZIP "Enable ZIP Archive support (via minizip)" ON)
option(ENABLE_XAUDIO2 "Enable the XAudio2 audio driver" OFF)
option(ENABLE_XML "Enable XML format support for resources" ON)

option(ENABLE_SPLASHSCREEN "Use the custom splashscreen for the editor" ON)
option(ENABLE_ADVANCED_GUI "Enable advanced 3D GUI nodes and behaviors" ON)
option(ENABLE_3D "Enable 3D nodes (creates larger executables)" ON)

dependent_option(ENABLE_MODULE_BULLET "Enable bullet module" BULLET_FOUND)
dependent_option(ENABLE_MODULE_FREETYPE "Enable freetype module" FREETYPE_FOUND)
dependent_option(ENABLE_MODULE_REGEX "Enable regex module" PCRE2_FOUND)
dependent_option(ENABLE_MODULE_ENET "Enable enet module" ENET_FOUND)
dependent_option(ENABLE_MODULE_OGG "Enable ogg module" OGG_FOUND)
dependent_option(ENABLE_MODULE_OPUS "Enable opus module" OPUS_FOUND)
dependent_option(ENABLE_MODULE_MONO "Enable Mono module" MONO_FOUND)

check_ipo_supported(RESULT HAS_IPO_SUPPORT LANGUAGES CXX C)

check_headers(vector HAS_CXX_VECTOR LANGUAGE CXX)
check_headers(map HAS_CXX_MAP LANGUAGE CXX)

###############################################################################

if (NOT BULLET_FOUND OR USE_BUILTIN_BULLET)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/bullet)
endif()

if (NOT FREETYPE_FOUND OR USE_BUILTIN_FREETYPE)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/freetype)
endif()

if (NOT PCRE2_FOUND OR USE_BUILTIN_PCRE2)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/pcre2)
endif()

if (NOT OGG_FOUND OR USE_BUILTIN_OGG)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/libogg)
endif()

if (NOT MBEDTLS_FOUND OR USE_BUILTIN_MBEDTLS)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/mbedtls)
endif()

if (NOT WEBSOCKETS_FOUND OR USE_BUILTIN_LIBWEBSOCKETS)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/libwebsockets)
endif()

if (NOT VPX_FOUND OR USE_BUILTIN_LIBVPX)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/libvpx)
endif()

if (NOT PNG_FOUND OR USE_BUILTIN_LIBPNG)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/libpng)
endif()

if (NOT ZSTD_FOUND OR USE_BUILTIN_ZSTD)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/zstd)
endif()

if (NOT ZLIB_FOUND OR USE_BUILTIN_ZLIB)
  add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/zlib)
endif()

# These builtins are *always* bundled
add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/nanosvg)
add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/minizip)

###############################################################################

add_executable(godot WIN32 MACOSX_BUNDLE main/main.cpp)

add_library(godot-common INTERFACE)

add_library(godot-visual-script)
add_library(godot-stb-vorbis)
add_library(godot-gdscript)
add_library(godot-regex)
add_library(godot-scene)
add_library(godot-core)
add_library(godot-svg)
add_library(godot-dds)

# Driver checks/notes -- move to elsewhere
check_include_files("mtent.h" HAVE_MNTENT LANGUAGE C)

target_include_directories(godot-common
  INTERFACE
    $<$<PLATFORM_ID:Windows>:${PROJECT_SOURCE_DIR}/platform/windows>
    $<$<PLATFORM_ID:Darwin>:${PROJECT_SOURCE_DIR}/platform/osx>
    $<$<PLATFORM_ID:Linux>:${PROJECT_SOURCE_DIR}/platform/x11>
    ${PROJECT_SOURCE_DIR}/core/math
    ${PROJECT_SOURCE_DIR}/core
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_BINARY_DIR}/generated
    ${PROJECT_BINARY_DIR}/include)

target_include_directories(godot-visual-script
  PUBLIC
    ${PROJECT_SOURCE_DIR}/editor)

target_include_directories(godot-scene
  PUBLIC
    ${PROJECT_SOURCE_DIR}/scene/resources
    ${PROJECT_SOURCE_DIR}/scene/main
    ${PROJECT_SOURCE_DIR}/scene)

target_compile_definitions(godot-common
  INTERFACE
    $<$<CONFIG:Debug>:DEBUG_MEMORY_ENABLED>
    $<$<CONFIG:Debug>:DEBUG_ENABLED>
    $<$<PLATFORM_ID:Windows>:WINDOWS_ENABLED>
    MODULE_VISUAL_SCRIPT_ENABLED
    MODULE_GDSCRIPT_ENABLED
    GDSCRIPT_ENABLED
    FREETYPE_ENABLED
    TOOLS_ENABLED
    SVG_ENABLED
    XML_ENABLED)

target_sources(godot-visual-script PRIVATE modules/visual_script/*.cpp)
target_sources(godot-stb-vorbis PRIVATE modules/stb_vorbis/*.cpp)
target_sources(godot-gdscript PRIVATE modules/gdscript/*.cpp)
target_sources(godot-regex PRIVATE modules/regex/*.cpp)
target_sources(godot-svg PRIVATE modules/svg/*.cpp)
target_sources(godot-dds PRIVATE modules/dds/*.cpp)

target_sources(godot-scene PRIVATE scene/*.cpp)

target_sources(godot-core
  PRIVATE
    servers/*.cpp
    modules/*.cpp
    drivers/*.cpp
    editor/*.cpp
    scene/*.cpp
    core/*.cpp)

target_sources(godot PRIVATE main/*.cpp main/tests/*.cpp)

target_compile_options(godot-common
  INTERFACE
    $<$<CXX_COMPILER_ID:GNU>:-Wno-return-local-addr>
    $<$<AND:$<CXX_COMPILER_ID:GNU>,$<CONFIG:Debug>>:-ggdb>
    $<$<AND:$<CXX_COMPILER_ID:AppleClang>,$<CONFIG:Debug>>:-glldb>)

target_compile_options(godot-core
  PUBLIC
    $<$<CXX_COMPILER_ID:MSVC>:/wd4244 /wd4305 /wd4267>)

target_link_libraries(godot-regex
  PUBLIC
    godot-common
    $<$<PLATFORM_ID:Windows>:PCRE2::UTF16>
    $<$<NOT:$<PLATFORM_ID:Windows>>:PCRE2::UTF32>)

target_link_libraries(godot-visual-script PUBLIC godot-common godot-scene)
target_link_libraries(godot-stb-vorbis PUBLIC godot-common)
target_link_libraries(godot-gdscript PUBLIC godot-common)
target_link_libraries(godot-scene
  PUBLIC
    godot-common
    $<TARGET_NAME_IF_EXISTS:FreeType::FreeType>)

target_link_libraries(godot-dds PUBLIC godot-common)
target_link_libraries(godot-svg PUBLIC godot-common nanosvg)

target_link_libraries(godot-core
  PUBLIC
    PNG::PNG
    godot-visual-script
    godot-stb-vorbis
    godot-gdscript
    godot-scene
    godot-regex
    godot-svg
    godot-dds)

target_link_libraries(godot
  PRIVATE
    godot-core
    $<TARGET_NAME_IF_EXISTS:OpenGL::GL>
    $<TARGET_NAME_IF_EXISTS:FreeType::FreeType>
    $<TARGET_NAME_IF_EXISTS:Bullet::Bullet>
    $<TARGET_NAME_IF_EXISTS:Vulkan::Vulkan>
    $<TARGET_NAME_IF_EXISTS:ZLib::ZLib>
    $<TARGET_NAME_IF_EXISTS:PNG::PNG>
    $<$<CXX_COMPILER_ID:MSVC>:dinput8>
    $<$<CXX_COMPILER_ID:MSVC>:dsound>
    $<$<CXX_COMPILER_ID:MSVC>:d3d9>)

# TODO: need to clean up all the generator programs...
# they all do the same thing (more or less)
# So we're just copy-pasting the basic file and then editing as needed.
# it's gross and I hate it...
####
set(version-generated "${CMAKE_CURRENT_BINARY_DIR}/include/core/version_generated.gen.h")
set(version-template "${PROJECT_SOURCE_DIR}/scripts/templates/core/version_generated.h.in")
set(version-module "${PROJECT_SOURCE_DIR}/version.py")
#####
set(version-hash "${CMAKE_CURRENT_BINARY_DIR}/include/core/version_hash.gen.h")
set(version-hash-template "${PROJECT_SOURCE_DIR}/scripts/templates/core/version_hash.h.in")
####
set(builtin-fonts "${CMAKE_CURRENT_BINARY_DIR}/include/builtin_fonts.gen.h")
set(fonts-template "${PROJECT_SOURCE_DIR}/scripts/templates/editor/builtin_fonts.h.in")
####
set(doc-data-compressed "${CMAKE_CURRENT_BINARY_DIR}/include/doc_data_compressed.gen.h")
set(doc-data-template "${PROJECT_SOURCE_DIR}/scripts/templates/editor/doc_data_compressed.h.in")
####
set(authors "${CMAKE_CURRENT_BINARY_DIR}/include/core/authors.gen.h")
set(authors-template "${PROJECT_SOURCE_DIR}/scripts/templates/core/authors.h.in")
####
set(donors "${CMAKE_CURRENT_BINARY_DIR}/include/core/donors.gen.h")
set(donors-template "${PROJECT_SOURCE_DIR}/scripts/templates/core/donors.h.in")

glob(fonts FILES_ONLY thirdparty/fonts/*.ttf thirdparty/fonts/*.otf)
glob(docs FILES_ONLY doc/classes/*.xml modules/*/doc_classes/*.xml)

list(SORT fonts)
list(SORT docs)

# TODO: Cleanup the add_custom_command calls

add_custom_command(OUTPUT "${donors}"
  COMMAND Poetry::Poetry ARGS run python
  ${PROJECT_SOURCE_DIR}/scripts/donors-generator.py
  -o "${donors}"
  -t "${donors-template}"
  "${PROJECT_SOURCE_DIR}/DONORS.md"
  MAIN_DEPENDENCY "${PROJECT_SOURCE_DIR}/DONORS.md"
  DEPENDS
    ${PROJECT_SOURCE_DIR}/scripts/donors-generator.py
    ${donors-template}
  COMMENT "Generating donors header"
  VERBATIM)

add_custom_command(OUTPUT "${authors}"
  COMMAND Poetry::Poetry ARGS run python
  ${PROJECT_SOURCE_DIR}/scripts/authors-generator.py
  -o "${authors}"
  -t "${authors-template}"
  "${PROJECT_SOURCE_DIR}/AUTHORS.md"
  MAIN_DEPENDENCY "${PROJECT_SOURCE_DIR}/AUTHORS.md"
  DEPENDS
    ${PROJECT_SOURCE_DIR}/scripts/authors-generator.py
    ${authors-template}
  COMMENT "Generating authors header"
  VERBATIM)

add_custom_command(OUTPUT "${doc-data-compressed}"
  COMMAND Poetry::Poetry ARGS run python
  ${PROJECT_SOURCE_DIR}/scripts/editor-docs-generator.py
  -o "${doc-data-compressed}"
  -t "${doc-data-template}"
  ${docs}
  MAIN_DEPENDENCY "${doc-data-template}"
  DEPENDS
    ${PROJECT_SOURCE_DIR}/scripts/editor-docs-generator.py
    ${docs}
  COMMENT "Generating documentation data"
  VERBATIM)

add_custom_command(OUTPUT "${builtin-fonts}"
  COMMAND Poetry::Poetry ARGS run python
  ${PROJECT_SOURCE_DIR}/scripts/editor-font-generator.py
  -o "${builtin-fonts}"
  -t "${fonts-template}"
  ${fonts}
  MAIN_DEPENDENCY "${fonts-template}"
  DEPENDS
    ${PROJECT_SOURCE_DIR}/scripts/editor-font-generator.py
    ${fonts}
  COMMENT "Generating builtin fonts"
  VERBATIM)

add_custom_command(OUTPUT "${version-generated}"
  COMMAND Poetry::Poetry ARGS run python
  ${PROJECT_SOURCE_DIR}/scripts/version-generator.py
  -o ${version-generated}
  -t ${version-template}
  -i ${version-module}
  MAIN_DEPENDENCY "${version-template}"
  DEPENDS
    "${PROJECT_SOURCE_DIR}/scripts/version-generator.py"
    "${version-module}"
  COMMENT "Generating version header"
  VERBATIM)

add_custom_command(OUTPUT "${version-hash}"
  COMMAND Poetry::Poetry ARGS run python
  ${PROJECT_SOURCE_DIR}/scripts/version-hash-generator.py
  -o "${version-hash}"
  -t "${version-hash-template}"
  --git "${GIT_EXECUTABLE}"
  MAIN_DEPENDENCY "${version-hash-template}"
  DEPENDS "${PROJECT_SOURCE_DIR}/scripts/version-hash-generator.py"
  COMMENT "Generating version hash header"
  VERBATIM)

add_custom_target(version-generated-h DEPENDS "${version-generated}")
add_custom_target(version-hash-h DEPENDS "${version-hash}")
add_custom_target(builtin-fonts-h DEPENDS "${builtin-fonts}")
add_custom_target(doc-data-compressed-h DEPENDS "${doc-data-compressed}")
add_custom_target(authors-h DEPENDS "${authors}")
add_custom_target(donors-h DEPENDS "${donors}")

add_dependencies(godot-core
  doc-data-compressed-h
  builtin-fonts-h

  authors-h
  donors-h

  version-generated-h
  version-hash-h)
