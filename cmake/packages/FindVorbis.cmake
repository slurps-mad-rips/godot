include(FindPackageHandleStandardArgs)
include(CheckComponent)
include(ImportLibrary)
include(PushFindState)

find_package(Ogg REQUIRED)

push_find_state(Vorbis)
find_library(VORBIS_ENCODER_LIBRARY NAMES vorbisenc ${FIND_OPTIONS})
find_library(VORBIS_FILE_LIBRARY NAMES vorbisfile ${FIND_OPTIONS})
find_library(VORBIS_LIBRARY NAMES vorbis ${FIND_OPTIONS})
find_path(VORBIS_INCLUDE_DIR NAMES vorbis/vorbisfile.h ${FIND_OPTIONS})
pop_find_state()

set(VORBIS_INCLUDE_DIRS ${VORBIS_INCLUDE_DIR})
set(VORBIS_LIBRARIES
  ${VORBIS_ENCODER_LIBRARY}
  ${VORBIS_FILE_LIBRARY}
  ${VORBIS_LIBRARY})

check_library_component(Vorbis Encoder)
check_library_component(Vorbis File)

find_package_handle_standard_args(Vorbis
  REQUIRED_VARS VORBIS_INCLUDE_DIR VORBIS_LIBRARY HANDLE_COMPONENTS)

if (VORBIS_ENCODER_LIBRARY AND NOT TARGET Vorbis::Encoder)
  import_library(Vorbis::Encoder
    LOCATION ${THEORA_ENCODER_LIBRARY}
    INCLUDES ${THEORA_INCLUDE_DIR})
endif()

if (VORBIS_FILE_LIBRARY AND NOT TARGET Vorbis::File)
  import_library(Vorbis::File
    LOCATION ${VORBIS_FILE_LIBRARY}
    INCLUDES ${VORBIS_INCLUDE_DIR})
endif()

if (VORBIS_LIBRARY AND NOT TARGET Vorbis::Vorbis)
  import_library(Vorbis::Vorbis
    LOCATION ${VORBIS_LIBRARY}
    INCLUDES ${VORBIS_INCLUDE_DIR}
    LIBRARIES
      $<TARGET_NAME_IF_EXISTS:Vorbis::Encoder>
      $<TARGET_NAME_IF_EXISTS:Vorbis::File>
      $<TARGET_NAME_IF_EXISTS:Ogg::Ogg>)
endif()

mark_as_advanced(VORBIS_INCLUDE_DIR)

mark_as_advanced(VORBIS_ENCODER_LIBRARY)
mark_as_advanced(VORBIS_FILE_LIBRARY)
mark_as_advanced(VORBIS_LIBRARY)
