cmake_minimum_required(VERSION 3.15)

project(CxQuickControls VERSION 0.0.1 DESCRIPTION "cxfw Quick controls.")

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/../../../../dist")

add_custom_target(CxQuickControls
    SOURCES
        qmldir
        Button.qml
)

install(FILES
    qmldir
    Button.qml
    DESTINATION
        "bin/qml/CxQuick/Controls"
)
