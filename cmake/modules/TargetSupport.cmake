include_guard(GLOBAL)

function (target_glob_sources target)
  set(options RECURSE)
  set(single)
  set(multi INTERFACE PUBLIC PRIVATE)
  cmake_parse_arguments(ARG "${options}" "${single}" "${multi}" ${ARGN})

  set(INTERFACE_SOURCES)
  set(PRIVATE_SOURCES)
  set(PUBLIC_SOURCES)
  set(glob GLOB)

  if (ARG_RECURSE)
    set(glob GLOB_RECURSE)
  endif ()

  if (DEFINED ARG_INTERFACE)
    file(${glob} interface CONFIGURE_DEPENDS ${ARG_INTERFACE})
    list(APPEND INTERFACE_SOURCES INTERFACE ${interface})
  endif ()

  if (DEFINED ARG_PRIVATE)
    file(${glob} private CONFIGURE_DEPENDS ${ARG_PRIVATE})
    list(APPEND PRIVATE_SOURCES PRIVATE ${private})
  endif ()

  if (DEFINED ARG_PUBLIC)
    list(APPEND PUBLIC_SOURCES PUBLIC ${public})
    file(${glob} public CONFIGURE_DEPENDS ${ARG_PUBLIC})
  endif ()

  target_sources(${target}
    ${INTERFACE_SOURCES}
    ${PRIVATE_SOURCES}
    ${PUBLIC_SOURCES})
endfunction ()
