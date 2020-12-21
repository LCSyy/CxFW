cmake_minimum_required(VERSION 3.15)

project(CxQuickControls
    VERSION 0.0.1
    DESCRIPTION "CxFw Quick Controls."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_custom_target(CxQuickControls
    SOURCES
        qmldir
)
