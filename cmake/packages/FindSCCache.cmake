include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(SCCache)
find_program(SCCache_EXECUTABLE NAMES sccache ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(SCCache
  REQUIRED_VARS SCCache_EXECUTABLE)

if (SCCache_EXECUTABLE)
  import_program(sccache
    LOCATION ${SCCache_EXECUTABLE}
    GLOBAL)
endif()

#FIXME: This is not currently working for executables...
hide(SCCache EXECUTABLE)
