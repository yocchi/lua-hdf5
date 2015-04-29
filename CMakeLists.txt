cmake_minimum_required(VERSION 2.8)
project(lua-hdf5 C)

include(cmake/dist.cmake)
include(lua)

find_package(HDF5 COMPONENTS CXX REQUIRED)

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

install_lua_module(HDF5 lua-hdf5.c)
install_lua_module(buffer buffer.c)
install_lua_module(LuaHDF5 LuaHDF5.lua)
install_lua_module(array array.lua)
install_lua_module(class class.lua)

add_dependencies(HDF5 generate_h5funcs)
target_link_libraries(HDF5 ${LUA_LIBRARIES} ${HDF5_LIBRARIES})
target_link_libraries(buffer ${LUA_LIBRARIES} ${HDF5_LIBRARIES})

# Schedules a test, this is optional
add_lua_test(LuaHDF5.lua)
add_lua_test(array.lua)
add_lua_test(run.lua)
