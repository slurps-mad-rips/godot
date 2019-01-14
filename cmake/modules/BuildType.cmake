include_guard(GLOBAL)

set(default_build_type Release)
if (EXISTS "${CMAKE_SOURCE_DIR}/.git")
  set(default_build_type Debug)
endif()

if (NOT CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type '${default_build_type}' as none was set")
  set(CMAKE_BUILD_TYPE ${default_build_type} CACHE
    STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    Debug Release MinSizeRel RelWithDebInfo)
endif ()
