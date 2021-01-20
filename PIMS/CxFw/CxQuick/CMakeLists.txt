cmake_minimum_required(VERSION 3.15)

project(CxQuick
    VERSION 0.0.1
    DESCRIPTION "CxFw Quick."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Qml REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Qml REQUIRED)

add_library(CxQuickPlugin SHARED
    qmldir
    cxquickplugin.cpp
    cxquickplugin.h
    theme.cpp
    theme.h
)

target_link_libraries(CxQuickPlugin
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Qml
    CxCore
)

install(TARGETS CxQuickPlugin DESTINATION "bin/plugins/CxQuick")
install(FILES qmldir DESTINATION "bin/plugins/CxQuick")
