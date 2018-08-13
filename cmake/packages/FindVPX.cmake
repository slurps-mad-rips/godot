include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)

push_find_state(Vpx)
find_library(VPX_LIBRARY NAMES vpx vpxmd vpxmt ${FIND_OPTIONS})
find_path(VPX_INCLUDE_DIR NAMES vpx/vpx_encoder.h ${FIND_OPTIONS})
pop_find_state()

set(VPX_INCLUDE_DIRS ${VPX_INCLUDE_DIRS})
set(VPX_LIBRARIES ${VPX_LIBRARY})

find_package_handle_standard_args(Vpx
  REQUIRED_VARS VPX_INCLUDE_DIR VPX_LIBRARY)

if (VPX_LIBRARY AND NOT TARGET Vpx::Vpx)
  import_library(Vpx::Vpx
    LOCATION ${VPX_LIBRARY}
    INCLUDES ${VPX_INCLUDE_DIR})
endif()

mark_as_advanced(VPX_INCLUDE_DIR)
mark_as_advanced(VPX_LIBRARY)
