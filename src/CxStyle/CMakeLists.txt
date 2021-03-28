cmake_minimum_required(VERSION 3.15)

project(CxStyle)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)

set(QML_IMPORT_PATH "${CXFW_BINARY_DIR}" CACHE FILEPATH "The QML import path")

set(PROJECT_STYLE_SOURCES
    qml/Button.qml
    qml/ComboBox.qml
    qml/Menu.qml
    qml/MenuBar.qml
    qml/MenuBarItem.qml
    qml/MenuSeparator.qml
    qml/TextField.qml
    qml/ToolBar.qml
    qml/ToolSeparator.qml
    qmldir
)

set(PROJECT_INSTALL_DIR "${CXFW_BINARY_DIR}/CxFw/CxStyle")

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui Qml REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Qml REQUIRED)

add_custom_target(CxStyle
  SOURCES
    ${PROJECT_STYLE_SOURCES}
)

add_library(CxStylePlugin SHARED
  cxstyleplugin.cpp
  cxstyleplugin.h
  cxstyle.cpp
  cxstyle.h
)

target_compile_definitions(CxStylePlugin
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(CxStylePlugin
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Qml
)

install(
    FILES ${PROJECT_STYLE_SOURCES}
    DESTINATION "${PROJECT_INSTALL_DIR}"
)

install(
    TARGETS CxStylePlugin
    DESTINATION "${PROJECT_INSTALL_DIR}"
)
