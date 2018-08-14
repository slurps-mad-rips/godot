include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(ClangCheck)
find_program(ClangCheck_EXECUTABLE NAMES clang-check ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(ClangCheck
  REQUIRED_VARS ClangCheck_EXECUTABLE)

if (ClangCheck_EXECUTABLE)
  import_program(clang::check
    LOCATION ${ClangCheck_EXECUTABLE}
    GLOBAL)
endif()

hide(ClangCheck EXECUTABLE)
