cmake_minimum_required(VERSION 3.15)

project(CxNetwork
    VERSION 0.0.1
    DESCRIPTION "CxFw networks."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Network Qml REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Network Qml REQUIRED)

add_library(CxNetwork
     cxnetwork.cpp
     cxnetwork.h
)

target_link_libraries(CxNetwork
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Network
    Qt${QT_VERSION_MAJOR}::Qml
)
