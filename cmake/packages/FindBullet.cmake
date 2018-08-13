include(FindPackageHandleStandardArgs)
include(CheckComponent)
include(ImportLibrary)
include(PushFindState)
include(Hide)

# The FindBullet that comes with CMake does not follow the modern naming
# convention. Additionally, it doesn't export any other modules.

push_find_state(Bullet)
find_library(BULLET_DYNAMICS_LIBRARY NAMES BulletDynamics ${FIND_OPTIONS})
find_library(BULLET_COLLISION_LIBRARY NAMES BulletCollision ${FIND_OPTIONS})
find_library(BULLET_MATH_LIBRARY NAMES BulletMath LinearMath ${FIND_OPTIONS})
find_library(BULLET_SOFTBODY_LIBRARY NAMES BulletSoftBody ${FIND_OPTIONS})
find_path(BULLET_INCLUDE_DIR NAMES bullet/btBulletCollisionCommon.h ${FIND_OPTIONS})
pop_find_state()

set(BULLET_INCLUDE_DIRS ${BULLET_INCLUDE_DIR})
set(BULLET_LIBRARIES
  ${BULLET_DYNAMICS_LIBRARY}
  ${BULLET_COLLISION_LIBRARY}
  ${BULLET_MATH_LIBRARY}
  ${BULLET_SOFTBODY_LIBRARY})

check_library_component(Bullet Collision)
check_library_component(Bullet SoftBody)
check_library_component(Bullet Dynamics)
check_library_component(Bullet Math)

find_package_handle_standard_args(Bullet
  REQUIRED_VARS BULLET_INCLUDE_DIR HANDLE_COMPONENTS)

if (BULLET_COLLISION_LIBRARY)
  import_library(Bullet::Collision
    LOCATION ${BULLET_COLLISION_LIBRARY}
    INCLUDES ${BULLET_INCLUDE_DIR})
endif()

if (BULLET_SOFTBODY_LIBRARY)
  import_library(Bullet::SoftBody
    LOCATION ${BULLET_LOCATION_LIBRARY}
    INCLUDES ${BULLET_INCLUDE_DIR})
endif()

if (BULLET_DYNAMICS_LIBRARY)
  import_library(Bullet::Dyamics
    LOCATION ${BULLET_DYNAMICS_LIBRARY}
    INCLUDES ${BULLET_INCLUDE_DIR})
endif()

if (BULLET_MATH_LIBRARY)
  import_library(Bullet::Math
    LOCATION ${BULLET_MATH_LIBRARY}
    INCLUDES ${BULLET_INCLUDE_DIR})
endif()

hide(BULLET COLLISION_LIBRARY SOFTBODY_LIBRARY DYNAMICS_LIBRARY MATH_LIBRARY)
hide(BULLET INCLUDE_DIR)
