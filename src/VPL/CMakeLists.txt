cmake_minimum_required(VERSION 3.15)

project(VPL LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)

set(QML_IMPORT_PATH "${CXFW_BINARY_DIR}" CACHE PATH "QML import path")

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick QuickControls2 REQUIRED)

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        helper.cpp
        helper.h
        curveitem.cpp
        curveitem.h
        edgeitem.cpp
        edgeitem.h
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(VPL
        ${PROJECT_SOURCES}
    )
else()
    add_executable(VPL
      ${PROJECT_SOURCES}
    )
endif()

if(WIN32)
    target_link_options(VPL PRIVATE -mwindows)
endif()

target_compile_definitions(VPL
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(VPL
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::QuickControls2
)

install(TARGETS VPL
    DESTINATION "${CXFW_BINARY_DIR}"
)
