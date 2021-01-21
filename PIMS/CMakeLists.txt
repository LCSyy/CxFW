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

include_directories("${PROJECT_SOURCE_DIR}/CxFw/")

set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/../dist/")
set(CXFW_ROOT "F:/Applications/CxFw/sdk")

add_subdirectory(CxFw)
add_subdirectory(Writer)
add_subdirectory(AppHub)
# add_subdirectory(Todos)
