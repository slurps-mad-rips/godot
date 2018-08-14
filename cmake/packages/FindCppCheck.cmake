include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(CppCheck)
find_program(CppCheck_EXECUTABLE NAMES cppcheck ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(CppCheck
  REQUIRED_VARS CppCheck_EXECUTABLE)

if (CppCheck_EXECUTABLE)
  import_program(cppcheck
    LOCATION ${CppCheck_EXECUTABLE}
    GLOBAL)
endif()

hide(CppCheck EXECUTABLE)
