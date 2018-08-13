include_guard(GLOBAL)

# Do some extra work here to make sure we can actually have a push/pop state
function (push_find_state package)
  string(TOUPPER ${package} package)
  set(FIND_OPTIONS
    HINTS
      ENV ${package}_ROOT_DIR
      ENV ${package}_DIR
      ENV ${package}DIR
      "${${package}_ROOT_DIR}"
      "${${package}_DIR}"
      "${${package}DIR}"
    PARENT_SCOPE)
endfunction()

function (pop_find_state)
  unset(FIND_OPTIONS PARENT_SCOPE)
endfunction ()

function (reset_find_state)
  unset(FIND_OPTIONS PARENT_SCOPE)
endfunction ()
