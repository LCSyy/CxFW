cmake_minimum_required(VERSION 3.15)

project(CxControls)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)

set(PROJECT_INSTALL_DIR "${CXFW_BINARY_DIR}/CxFw/CxControls")

set(PROJECT_QML_SOURCES
    qmldir
    qml/Badge.qml
    qml/Banner.qml
    qml/HomePage.qml
    qml/MainPage.qml
    qml/Popup.qml
    qml/StatusBar.qml
    qml/TextField.qml
)

add_custom_target(CxControls
  SOURCES
    ${PROJECT_QML_SOURCES}
)

install(
    FILES ${PROJECT_QML_SOURCES}
    DESTINATION "${PROJECT_INSTALL_DIR}"
)
