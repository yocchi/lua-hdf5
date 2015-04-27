cmake_minimum_required(VERSION 2.6)
project(lua-hdf5)

set(HDF5_INCLUDE_DIR /usr/local/include)
option(USE_MPIO "use HDF5 mpio feature" OFF)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/h5funcs.c
  COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/parse.py --hdf5_inc=${HDF5_INCLUDE_DIR} --use_mpio=${USE_MPIO}
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/parse.py
  )
add_custom_target(generate_h5funcs
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/h5funcs.c)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(lua-hdf5 SHARED buffer.c lua-hdf5.c)
add_dependencies(lua-hdf5 generate_h5funcs)
