cmake_minimum_required(VERSION 3.14)

project(UdpChat LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(ENV{QT_DEBUG_PLUGINS} ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick QuickControls2 Network REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core QuickControls2 Network REQUIRED)

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        udpchat.cpp
        udpchat.h
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(UdpChat
        ${PROJECT_SOURCES}
    )
else()
    add_executable(UdpChat
      ${PROJECT_SOURCES}
    )
endif()

if(WIN32)
    target_link_options(UdpChat PRIVATE -mwindows)
endif()

target_compile_definitions(UdpChat
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(UdpChat
  PRIVATE
  Qt${QT_VERSION_MAJOR}::Core
  Qt${QT_VERSION_MAJOR}::Quick
  Qt${QT_VERSION_MAJOR}::QuickControls2
  Qt${QT_VERSION_MAJOR}::Network
)

install(
    TARGETS UdpChat
    DESTINATION "${CXFW_BINARY_DIR}"
)
