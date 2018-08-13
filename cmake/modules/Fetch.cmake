include_guard(GLOBAL)
include(FetchContent)

# Used like:
# Fetch(googletest
#   GIT_REPOSITORY https://github.com/google/googletest.git
#   GIT_TAG release-1.8.0)

function (fetch name)
  FetchContent_Declare(${name} ${ARGN})
  FetchContent_GetProperties(${name})
  if (${name}_POPULATED)
    return()
  endif()
  FetchContent_Populate(${name})
  add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR})
endfunction()
