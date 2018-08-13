include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)
include(Hide)

push_find_state(Squish)
find_library(Squish_LIBRARY NAMES squish ${FIND_OPTIONS})
find_path(Squish_INCLUDE_DIR NAMES squish/squish.h squish.h ${FIND_OPTIONS})
pop_find_state()

set(Squish_INCLUDE_DIRS ${Squish_INCLUDE_DIR})
set(Squish_LIBRARIES ${Squish_LIBRARY})

find_package_handle_standard_args(Squish
  REQUIRED_VARS Squish_INCLUDE_DIR Squish_LIBRARY)

if (Squish_LIBRARY AND NOT TARGET Squish::Squish)
  import_library(Squish::Squish
    LOCATION ${Squish_LIBRARY}
    INCLUDES ${Squish_INCLUDE_DIR})
endif()

hide(Squish INCLUDE_DIR LIBRARY)
