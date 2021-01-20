cmake_minimum_required(VERSION 3.15)

project(QGlobalShortcut LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui REQUIRED)
elseif(UNIX)
    include(FindPkgConfig)
    pkg_check_modules(xcb REQUIRED)

    find_package(X11)
    find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui X11Extras REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui X11Extras REQUIRED)
elseif(APPLE)
    # ...
endif()

add_library(QGlobalShortcut
    qglobalshortcut.h
    qglobalshortcut.cc
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
        X11
        xcb
    )
endif()
