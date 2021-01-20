cmake_minimum_required(VERSION 3.15)

project(CxBinding
    VERSION 0.0.1
    DESCRIPTION "CxFw QML type bindings."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui Qml REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Qml REQUIRED)

add_library(CxBinding
    cxbinding.cpp
    cxbinding.h
)

set(CXFW_LIBS CxCore CxNetwork MarkdownSyntaxHighlighter QGlobalShortcut)
target_link_libraries(CxBinding
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Qml
    ${CXFW_LIBS}
)

