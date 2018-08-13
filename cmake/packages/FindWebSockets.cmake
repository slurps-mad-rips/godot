include(FindPackageHandleStandardArgs)
include(ImportLibrary)
include(PushFindState)
include(Hide)

push_find_state(WebSockets)
find_library(WebSockets_LIBRARY NAMES websockets ${FIND_OPTIONS})
find_path(WebSockets_INCLUDE_DIR
  NAMES websockets/libwebsockets.h libwebsockets.h
  ${FIND_OPTIONS})
pop_find_state()

set(WebSockets_INCLUDE_DIRS ${WebSockets_INCLUDE_DIR})
set(WebSockets_LIBRARIES ${WebSockets_LIBRARY})

find_package_handle_standard_args(WebSockets
  REQUIRED_VARS WebSockets_INCLUDE_DIR WebSockets_LIBRARY)

if (WebSockets_LIBRARY AND NOT TARGET WebSockets::WebSockets)
  import_library(WebSockets::WebSockets
    LOCATION ${WebSocket_LIBRARY}
    INCLUDES ${WebSocket_INCLUDE_DIR})
endif()

hide(WebSockets LIBRARY INCLUDE_DIR)
