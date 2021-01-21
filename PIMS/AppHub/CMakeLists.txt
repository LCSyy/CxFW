cmake_minimum_required(VERSION 3.5)

project(AppHub LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets Quick QuickWidgets QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets Quick QuickWidgets QuickControls2 REQUIRED)

add_executable(AppHub
  res.qrc
  qml.qrc
  logo.rc
  main.cpp
  mainwindow.cpp
  mainwindow.h
)

target_link_libraries(AppHub
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::QuickWidgets
    Qt${QT_VERSION_MAJOR}::QuickControls2
)

install(TARGETS AppHub DESTINATION "bin/")
