include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(IWYU)
find_program(IWYU_EXECUTABLE NAMES include-what-you-use ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(IWYU
  REQUIRED_VARS IWYU_EXECUTABLE)

if (IWYU_EXECUTABLE)
  import_program(iwyu
    LOCATION ${IWYU_EXECUTABLE}
    GLOBAL)
endif()

hide(IWYU EXECUTABLE)
