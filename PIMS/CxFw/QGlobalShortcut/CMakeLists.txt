cmake_minimum_required(VERSION 3.15)

project(QGlobalShortcut LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui REQUIRED)

if(WIN32)
    set(CX_SHORTCUT_SOURCES qglobalshortcut_win.cc)
elseif(UNIX)
    find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui X11Extras REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui X11Extras REQUIRED)

    set(CX_SHORTCUT_SOURCES qglobalshortcut_x11.cc)
elseif(APPLE)
    set(CX_SHORTCUT_SOURCES qglobalshortcut_macx.cc)
endif()

add_library(QGlobalShortcut
    qglobalshortcut.h
    qglobalshortcut.cc
    "${CX_SHORTCUT_SOURCES}"
)

if(WIN32)
    target_link_libraries(QGlobalShortcut
      PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Gui
    )
elseif(UNIX)
    target_link_libraries(QGlobalShortcut
      PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::X11Extras
    )
endif()
