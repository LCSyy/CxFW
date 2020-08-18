cmake_minimum_required(VERSION 3.15)

project(
    cxfw
    VERSION "2.0.0"
    DESCRIPTION "CXFW frameworks"
    HOMEPAGE_URL "https://lcsyy.github.io/"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_subdirectory(src)
