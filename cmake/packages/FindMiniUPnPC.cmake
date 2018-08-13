include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)
include(Hide)

push_find_state(MiniUPnPC)
find_library(MINIUPNPC_LIBRARY NAMES miniupnpc ${FIND_OPTIONS})
find_path(MINIUPNPC_INCLUDE_DIR NAMES miniupnpc/miniupnpc.h ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(MiniUPnPC
  REQUIRED_VARS MINIUPNPC_LIBRARY MINIUPNPC_INCLUDE_DIR MINIUPNPC_FIXME_PLEASE)
