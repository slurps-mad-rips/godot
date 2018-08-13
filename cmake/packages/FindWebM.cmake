include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)
include(Hide)

push_find_state(WebM)
find_library(WEBM_LIBRARY NAMES webm ${FIND_OPTIONS})
find_path(WEBM_INCLUDE_DIR NAMES mkvparser.h webm/webm_parser.h ${FIND_OPTIONS})
pop_find_state()

set(WEBM_INCLUDE_DIRS ${WEBM_INCLUDE_DIRS})
set(WEBM_LIBRARIES ${WEBM_LIBRARIES})

find_package_handle_standard_args(WebM
  REQUIRED_VARS WEBM_INCLUDE_DIR WEBM_LIBRARY)

if (WEBM_LIBRARY AND NOT TARGET WebM::WebM)
  import_library(WebM::WebM
    LOCATION ${WEBM_LIBRARY}
    INCLUDES ${WEBM_INCLUDE_DIR})
endif()

hide(WebM INCLUDE_DIR LIBRARY)
