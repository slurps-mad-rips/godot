include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)
include(Hide)

push_find_state(Opus)
find_library(OPUS_LIBRARY NAMES opus ${FIND_OPTIONS})
find_path(OPUS_INCLUDE_DIR NAMES opus/opus.h ${FIND_OPTIONS})
pop_find_state()

set(OPUS_INCLUDE_DIRS ${OPUS_INCLUDE_DIR})
set(OPUS_LIBRARIES ${OPUS_LIBRARY})

find_package_handle_standard_args(Opus
  REQUIRED_VARS OPUS_INCLUDE_DIR OPUS_LIBRARY)

if (OPUS_LIBRARY AND NOT TARGET Opus::Opus)
  import_library(Opus::Opus
    LOCATION ${OPUS_LIBRARY}
    INCLUDES ${OPUS_INCLUDE_DIR})
endif()

hide(Opus INCLUDE_DIR LIBRARY)
