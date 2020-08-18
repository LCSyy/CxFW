#! /bin/bash

CMAKE_APP=cmake
if [ ! $(which "cmake" > /dev/null) ]; then
    CMAKE_APP="D:/Qtz/Tools/CMake_64/bin/cmake.exe"
fi

$CMAKE_APP -S . -B "build" -G "MinGW Makefiles"
$CMAKE_APP --build "build"
$CMAKE_APP --install "build" --prefix "dist"
