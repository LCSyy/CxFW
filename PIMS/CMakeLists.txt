cmake_minimum_required(VERSION 3.15)

project(PIMS
    VERSION 0.0.1
    DESCRIPTION "A personal information management system."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/dist/")

add_subdirectory(CxFw)

add_subdirectory(Writer)
add_subdirectory(AppHub)

