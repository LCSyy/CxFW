cmake_minimum_required(VERSION 3.15)

project(CxQuickPlugins
    VERSION "0.0.1"
    DESCRIPTION "The Qml plugin."
)

add_subdirectory(CxFwStyle)

add_custom_target(CxQuickModule
    SOURCES
        qmldir
)

