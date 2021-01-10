cmake_minimum_required(VERSION 3.15)

project(Todos LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets Quick QuickWidgets REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets Quick QuickWidgets REQUIRED)

add_executable(Todos
  "${CMAKE_CURRENT_SOURCE_DIR}/../CxFw/CxQuickControls/qml.qrc"
  qml.qrc
  main.cpp
)


target_link_libraries(Todos
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::QuickWidgets
    CxApp
)
