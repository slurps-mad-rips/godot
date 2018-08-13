include(FindPackageHandleStandardArgs)
include(CheckComponent)
include(ImportLibrary)
include(PushFindState)
include(Hide)

push_find_state(mbedTLS)
find_library(mbedTLS_Crypto_LIBRARY NAMES mbedcrypto ${FIND_OPTIONS})
find_library(mbedTLS_X509_LIBRARY NAMES mbedx509 ${FIND_OPTIONS})
find_library(mbedTLS_LIBRARY NAMES mbedtls ${FIND_OPTIONS})
find_path(mbedTLS_INCLUDE_DIR NAMES mbedtls/version.h ${FIND_OPTIONS})
pop_find_state()

set(mbedTLS_INCLUDE_DIRS ${mbedTLS_INCLUDE_DIR})
set(mbedTLS_LIBRARIES
  ${mbedTLS_Crypto_LIBRARY}
  ${mbedTLS_X509_LIBRARY}
  ${mbedTLS_LIBRARY})

check_library_component(mbedTLS Crypto)
check_library_component(mbedTLS X509)

find_package_handle_standard_args(mbedTLS
  REQUIRED_VARS mbedTLS_INCLUDE_DIR mbedTLS_LIBRARY HANDLE_COMPONENTS)

if (mbedTLS_Crypto_LIBRARY)
  import_library(mbedTLS::Crypto
    LOCATION ${mbedTLS_Crypto_LIBRARY}
    INCLUDES ${mbedTLS_INCLUDE_DIR})
endif()

if (mbedTLS_X509_LIBRARY)
  import_library(mbedTLS::X509
    LOCATION ${mbedTLS_X509_LIBRARY}
    INCLUDES ${mbedTLS_INCLUDE_DIR})
endif()

if (mbedTLS_LIBRARY)
  import_library(mbedTLS::mbedTLS
    LOCATION ${mbedTLS_LIBRARY}
    INCLUDES ${mbedTLS_INCLUDE_DIR}
    LIBRARIES
      $<TARGET_NAME_IF_EXISTS:mbedTLS::Crypto>
      $<TARGET_NAME_IF_EXISTS:mbedTLS::X509>)
endif()

hide(mbedTLS LIBRARY Crypto_LIBRARY X509_LIBRARY INCLUDE_DIR)
