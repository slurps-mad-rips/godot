project(Bullet LANGUAGES CXX C)

add_library(Bullet INTERFACE)
add_library(BulletCollision)
add_library(BulletDynamics)
add_library(BulletInverseDynamics)
add_library(BulletSoftBody)
add_library(LinearMath)
add_library(clew)
add_library(Bullet::Bullet ALIAS Bullet)

target_include_directories(BulletCollision PUBLIC ${PROJECT_SOURCE_DIR})
target_include_directories(BulletDynamics PUBLIC ${PROJECT_SOURCE_DIR})
target_include_directories(BulletInverseDynamics PUBLIC ${PROJECT_SOURCE_DIR})
target_include_directories(BulletSoftBody PUBLIC ${PROJECT_SOURCE_DIR})

target_sources(BulletCollision
  RECURSE
  PRIVATE
    BulletCollision/*.cpp)

target_sources(BulletDynamics RECURSE PRIVATE BulletDynamics/*.cpp)
target_sources(BulletInverseDynamics RECURSE PRIVATE BulletInverseDynamics/*.cpp)
target_sources(BulletSoftBody RECURSE PRIVATE BulletSoftBody/*.cpp)
target_sources(clew PRIVATE clew/clew.c)
target_sources(LinearMath PRIVATE LinearMath/*.cpp)

target_link_libraries(Bullet
    INTERFACE
      BulletCollision
      BulletDynamics
      BulletInverseDynamics
      BulletSoftBody)
