include_guard(GLOBAL)

include(CMakePushCheckState)
include(CheckCXXSourceCompiles)
include(CheckCSourceCompiles)

# TODO: Handle "code" being a file
# TODO: Perhaps rename this to check_code_compiles, or make a check_file_compiles
function (check_source_compiles code variable)
  set(option QUIET)
  set(single LANGUAGE)
  set(multi FAIL_REGEX FLAGS DEFINITIONS INCLUDES LIBRARIES HEADERS)
  cmake_parse_arguments(ARG "${option}" "${single}" "${multi}" ${ARGN})

  cmake_push_check_state()
  set(CMAKE_REQUIRED_DEFINITIONS ${ARG_DEFINITIONS})
  set(CMAKE_REQUIRED_LIBRARIES ${ARG_LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${ARG_INCLUDES})
  set(CMAKE_REQUIRED_FLAGS ${ARG_FLAGS})
  set(CMAKE_REQUIRED_QUIET OFF)
  if (ARG_QUIET)
    set(CMAKE_REQUIRED_QUIET ON)
  endif()
  if (DEFINED ARG_FAIL_REGEX)
    list(INSERT ARG_FAIL_REGEX 0 FAIL_REGEX)
  endif ()
  if (${ARG_LANGUAGE} STREQUAL "CXX")
    check_cxx_source_compiles(${code} ${variable} ${ARG_FAIL_REGEX})
  elseif (${ARG_LANGUAGE STREQUAL "C")
    check_c_source_compiles(${code} ${variable} ${ARG_FAIL_REGEX})
  endif ()
  cmake_pop_check_state()
  set(${variable} ${${variable}} PARENT_SCOPE)
endfunction ()
