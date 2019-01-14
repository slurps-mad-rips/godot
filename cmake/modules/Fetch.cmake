include_guard(GLOBAL)
include(FetchContent)

# Used like:
# fetch(googletest
#   GIT_REPOSITORY https://github.com/google/googletest.git
#   GIT_TAG release-1.8.0)

function (fetch name)
  string(TOLOWER ${name} lcname)
  FetchContent_Declare(${name} ${ARGN})
  FetchContent_GetProperties(${name})
  if (${lcname}_POPULATED)
    return()
  endif()
  FetchContent_Populate(${name})
  add_subdirectory(${${lcname}_SOURCE_DIR} ${${lcname}_BINARY_DIR})
endfunction()
