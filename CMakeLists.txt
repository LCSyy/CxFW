cmake_minimum_required(VERSION 3.15)

project(cxfw
    VERSION 0.0.1
    DESCRIPTION "cxfw based on qt."
)

set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/dist/")

add_subdirectory(cxfw)
