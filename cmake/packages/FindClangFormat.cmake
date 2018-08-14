include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Hide)

push_find_state(ClangFormat)
find_program(ClangFormat_EXECUTABLE NAMES clang-format ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(ClangFormat
  REQUIRED_VARS ClangFormat_EXECUTABLE)

if (ClangFormat_EXECUTABLE)
  import_program(clang::format
    LOCATION ${ClangFormat_EXECUTABLE}
    GLOBAL)
endif()

hide(ClangFormat EXECUTABLE)
