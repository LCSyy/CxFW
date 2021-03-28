cmake_minimum_required(VERSION 3.15)

project(CxQuick LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)

set(PROJECT_INSTALL_DIR "${CXFW_BINARY_DIR}/CxFw/CxQuick")

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui Qml Network REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Qml Network REQUIRED)
find_package(CxCore 0.1.0 REQUIRED)

set(PROJECT_QML_SOURCES
    qmldir
    plugins.qmltypes
    qml/LinkItem.qml
    qml/ListViewHighlighter.qml
    qml/Mask.qml
    qml/OneColumnTreeView.qml
    qml/BoxTheme.qml
    qml/cxfw.js
)

add_custom_target(CxQuick
  SOURCES
    ${PROJECT_QML_SOURCES}
)

add_library(CxQuickPlugin SHARED
    cxquickplugin.cpp
    cxquickplugin.h
    cxquick.cpp
    cxquick.h
    cxnetwork.cpp
    cxnetwork.h
)

target_compile_definitions(CxQuickPlugin
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(CxQuickPlugin
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Network
    ${CxCore_LIBRARIES}
)

install(
    FILES ${PROJECT_QML_SOURCES}
    DESTINATION "${PROJECT_INSTALL_DIR}"
)

install(
    TARGETS CxQuickPlugin
    DESTINATION "${PROJECT_INSTALL_DIR}"
)
