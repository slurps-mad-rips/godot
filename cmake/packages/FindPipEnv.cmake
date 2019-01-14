include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(PipEnv)
find_program(PipEnv_EXECUTABLE NAMES pipenv ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(PipEnv
  REQUIRED_VARS PipEnv_EXECUTABLE)

if (PipEnv_EXECUTABLE)
  import_program(pipenv
    LOCATION ${PipEnv_EXECUTABLE}
    GLOBAL)
endif()

hide(PipEnv EXECUTABLE)
