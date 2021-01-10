cmake_minimum_required(VERSION 3.15)

project(ColorSheet VERSION 0.0.1 DESCRIPTION "cxfw Quick color sheet.")

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/../../../../dist")

add_custom_target(CxQuickControls
    SOURCES
        qmldir
        ColorSheet.js
)

install(FILES
    qmldir
    ColorSheet.js
    DESTINATION
        "bin/qml/CxQuick/ColorSheet"
)
