cmake_minimum_required(VERSION 3.5)

project(CxWriter LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets REQUIRED)

add_executable(CxWriter
  main.cpp
  mainwindow.cpp
  mainwindow.h
  mainwindow.ui
)

target_include_directories(CxWriter PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../../../dist/include")

target_link_libraries(CxWriter PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)
target_link_libraries(CxWriter PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../../../dist/bin/libQMarkdownTextedit.a")
