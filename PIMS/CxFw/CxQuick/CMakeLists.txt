cmake_minimum_required(VERSION 3.15)

project(CxQuick
    VERSION 0.0.1
    DESCRIPTION "Quick items."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message("${CXFW_ROOT}")

set(src
    qmldir
    plugins.qmltypes
    cxfw.js
    BoxTheme.qml

    LinkItem.qml
    ListViewLighlighter.qml
    Mask.qml
    OneColumnTreeView.qml
)

add_custom_target(CxQuick
  SOURCES
    ${src}
)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui Qml REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Qml REQUIRED)

add_library(CxQuickPlugin SHARED
    cxquickplugin.cpp
    cxquickplugin.h
    theme.cpp
    theme.h
)

set(CXFW_LIBS CxCore CxNetwork MarkdownSyntaxHighlighter QGlobalShortcut)
target_link_libraries(CxQuickPlugin
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Gui
    ${CXFW_LIBS}
)

install(TARGETS CxQuickPlugin DESTINATION "bin/plugins/CxQuick")
install(FILES ${src} DESTINATION "bin/plugins/CxQuick")
