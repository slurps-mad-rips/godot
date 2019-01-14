include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(Poetry)
find_program(Poetry_EXECUTABLE NAMES poetry ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(Poetry
  REQUIRED_VARS Poetry_EXECUTABLE)

if (Poetry_EXECUTABLE)
  import_program(poetry
    LOCATION ${Poetry_EXECUTABLE}
    GLOBAL)
endif()

hide(Poetry EXECUTABLE)
