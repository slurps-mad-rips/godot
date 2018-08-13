include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)

push_find_state(Ogg)
find_library(OGG_LIBRARY NAMES ogg ${FIND_OPTIONS})
find_path(OGG_INCLUDE_DIR NAMES ogg/ogg.h ${FIND_OPTIONS})
pop_find_state()

set(OGG_INCLUDE_DIRS ${OGG_INCLUDE_DIRS})
set(OGG_LIBRARIES ${OGG_LIBRARY})

find_package_handle_standard_args(Ogg
  REQUIRED_VARS OGG_INCLUDE_DIR OGG_LIBRARY)

if (OGG_LIBRARY AND NOT TARGET Ogg::Ogg)
  import_library(Ogg::Ogg
    LOCATION ${OGG_LIBRARY}
    INCLUDES ${OGG_INCLUDE_DIR})
endif()

mark_as_advanced(OGG_INCLUDE_DIR OGG_LIBRARY)
