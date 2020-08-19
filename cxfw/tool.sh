#! /bin/bash

CMAKE_APP=cmake

which $CMAKE_APP > /dev/null

if [ $? == 1 ]; then
    CMAKE_APP="D:/Qtz/Tools/CMake_64/bin/cmake.exe"
fi

if [ "$1" == "update" ]; then
    $CMAKE_APP -S . -B "build" -G "MinGW Makefiles"
elif [ "$1" == "build" ]; then
    $CMAKE_APP --build "build"
elif [ "$1" == "install" ]; then
    $CMAKE_APP --install "build" --prefix "dist"
elif [ "$1" == "help" ]; then
    echo "tool is used to manage cxf build system.

        update    Update cmake cache.
        build     Build project.
        install   Install project.
        help      Show help.
    "
fi

