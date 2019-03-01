include_guard(GLOBAL)

function (import_program name)
  set(option GLOBAL)
  set(single LOCATION)
  set(multi)
  cmake_parse_arguments(ARG "${option}" "${single}" "${multi}" ${ARGN})

  if (ARG_GLOBAL)
    set(ARG_GLOBAL GLOBAL)
  endif()

  list(APPEND properties IMPORTED_LOCATION ${ARG_LOCATION})
  add_executable(${name} IMPORTED ${ARG_GLOBAL})
  set_target_properties(${name} PROPERTIES ${properties})
endfunction()
