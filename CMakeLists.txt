cmake_minimum_required(VERSION 2.6)
project(lua-hdf5)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

find_package(HDF5 COMPONENTS CXX REQUIRED)
find_package(Lua52 REQUIRED)

option(USE_MPIO "use HDF5 mpio feature" OFF)

if(CMAKE_COMPILER_IS_GNUCXX)
  add_definitions(-Wall -W)
  set(CMAKE_SHARED_LINKER_FLAGS -Wl,--no-undefined)
endif()

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/h5funcs.c
  COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/parse.py --hdf5_inc=${HDF5_INCLUDE_DIR} --use_mpio=${USE_MPIO}
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/parse.py
  )
add_custom_target(generate_h5funcs
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/h5funcs.c)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(SYSTEM
  ${HDF5_INCLUDE_DIR}
  ${LUA_INCLUDE_DIR})

add_library(HDF5 SHARED lua-hdf5.c)
add_dependencies(HDF5 generate_h5funcs)
target_link_libraries(HDF5 ${LUA_LIBRARIES} ${HDF5_LIBRARIES})
set_target_properties(HDF5 PROPERTIES PREFIX "")

add_library(buffer SHARED buffer.c)
target_link_libraries(buffer ${LUA_LIBRARIES} ${HDF5_LIBRARIES})
set_target_properties(buffer PROPERTIES PREFIX "")
