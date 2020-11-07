cmake_minimum_required(VERSION 3.15)

project(CxLogin
    VERSION 0.0.1
    DESCRIPTION "cxfw login tool"
)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/../../cmake")

include(CxfwInstall)

message("${CMAKE_INSTALL_PREFIX}")

add_custom_target(CxLogin
    SOURCES
        qmldir
        CxLogin.qml
)

install(FILES
    qmldir
    CxLogin.qml
    DESTINATION "bin/qml/CxLogin")
