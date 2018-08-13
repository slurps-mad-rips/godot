include_guard(GLOBAL)

include(CMakeDependentOption)

# TODO: Handle a disable_/enable_ sense of logic to choose which is on/off
function (dependent_option variable doc)
  cmake_dependent_option(${variable} ${doc} ON "${ARGN}" OFF)
endfunction()
