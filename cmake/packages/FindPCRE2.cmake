include(FindPackageHandleStandardArgs)
include(CheckComponent)
include(ImportLibrary)
include(PushFindState)

# TODO: Add VERSION_VAR support

# Specify a custom location with PCRE2_ROOT (Document this somewhere!)
push_find_state(PCRE2)
find_library(PCRE2_UTF32_LIBRARY NAMES pcre2-32 ${FIND_OPTIONS})
find_library(PCRE2_UTF16_LIBRARY NAMES pcre2-16 ${FIND_OPTIONS})
find_library(PCRE2_UTF8_LIBRARY NAMES pcre2-8 ${FIND_OPTIONS})
find_path(PCRE2_INCLUDE_DIR NAMES pcre2.h ${FIND_OPTIONS})
pop_find_state()

set(PCRE2_INCLUDE_DIRS ${PCRE2_INCLUDE_DIR})
set(PCRE2_LIBRARIES
  ${PCRE2_UTF32_LIBRARY}
  ${PCRE2_UTF16_LIBRARY}
  ${PCRE2_UTF8_LIBRARY})

check_library_component(PCRE2 UTF32)
check_library_component(PCRE2 UTF16)
check_library_component(PCRE2 UTF8)

find_package_handle_standard_args(PCRE2
  REQUIRED_VARS PCRE2_INCLUDE_DIR HANDLE_COMPONENTS)

if (PCRE2_UTF32_LIBRARY)
  import_library(PCRE2::UTF32
    LOCATION ${PCRE2_UTF32_LIBRARY}
    DEFINITIONS PCRE2_CODE_UNIT_WIDTH=32
    INCLUDES ${PCRE2_INCLUDE_DIRS})
endif()

if (PCRE2_UTF16_LIBRARY)
  import_library(PCRE2::UTF16
    LOCATION ${PCRE2_UTF16_LIBRARY}
    DEFINITIONS PCRE2_CODE_UNIT_WIDTH=32
    INCLUDES ${PCRE2_INCLUDE_DIRS})
endif()

if (PCRE2_UTF8_LIBRARY)
  import_library(PCRE2::UTF8
    LOCATION ${PCRE2_UTF8_LIBRARY}
    DEFINITIONS PCRE2_CODE_UNIT_WIDTH=8
    INCLUDES ${PCRE2_INCLUDE_DIRS})
endif()

mark_as_advanced(PCRE2_UTF32_LIBRARY)
mark_as_advanced(PCRE2_UTF16_LIBRARY)
mark_as_advanced(PCRE2_UTF8_LIBRARY)
mark_as_advanced(PCRE2_INCLUDE_DIR)
