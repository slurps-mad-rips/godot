include(FindPackageHandleStandardArgs)
include(CheckComponent)
include(ImportLibrary)
include(PushFindState)

find_package(Ogg QUIET)

if (NOT OGG_FOUND)
  return()
endif()

push_find_state(Theora)
find_library(THEORA_LIBRARY NAMES theora ${FIND_OPTIONS})
find_library(THEORA_ENCODER_LIBRARY NAMES theoraenc ${FIND_OPTIONS})
find_library(THEORA_DECODER_LIBRARY NAMES theoradec ${FIND_OPTIONS})
find_path(THEORA_INCLUDE_DIR NAMES theora ${FIND_OPTIONS})
pop_find_state()

set(THEORA_INCLUDE_DIRS ${THEORA_INCLUDE_DIRS})
set(THEORA_LIBRARIES
  ${THEORA_LIBRARY}
  ${THEORA_ENCODER_LIBRARY}
  ${THEORA_DECODER_LIBRARY})

check_library_component(Theora Encoder)
check_library_component(Theora Decoder)

find_package_handle_standard_args(Theora
  REQUIRED_VARS THEORA_INCLUDE_DIR THEORA_LIBRARY HANDLE_COMPONENTS)

if (THEORA_ENCODER_LIBRARY AND NOT TARGET Theora::Encoder)
  import_library(Theora::Encoder
    LOCATION ${THEORA_ENCODER_LIBRARY}
    INCLUDES ${THEORA_INCLUDE_DIR})
endif()

if (THEORA_DECODER_LIBRARY AND NOT TARGET Theora::Decoder)
  import_library(Theora::Decoder
    LOCATION ${THEORA_DECODER_LIBRARY}
    INCLUDES ${THEORA_INCLUDE_DIR})
endif()

if (THEORA_LIBRARY AND NOT TARGET Theora::Theora)
  import_library(Theora::Theora
    LOCATION ${THEORA_LIBRARY}
    INCLUDES ${THEORA_INCLUDE_DIR}
    LIBRARIES
      $<TARGET_NAME_IF_EXISTS:Theora::Encoder>
      $<TARGET_NAME_IF_EXISTS:Theora::Decoder>
      $<TARGET_NAME_IF_EXISTS:Ogg::Ogg>)
endif()

mark_as_advanced(THEORA_INCLUDE_DIR)

mark_as_advanced(THEORA_ENCODER_LIBRARY)
mark_as_advanced(THEORA_DECODER_LIBRARY)
mark_as_advanced(THEORA_LIBRARY)
