cmake_minimum_required(VERSION 3.15)

project(Play LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)
set(QML_IMPORT_PATH "${CXFW_BINARY_DIR}" CACHE PATH "QML import path")

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick REQUIRED)

list(APPEND CONFIG qmltypes)
set(QML_IMPORT_PATH "CxFw.Quick")
set(QML_IMPORT_MAJOR_VERSION 1)

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        backend.cpp
        backend.h
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(Play
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(Play SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(Play
          ${PROJECT_SOURCES}
        )
    endif()
endif()

if(WIN32)
    target_link_options(Play PRIVATE -mwindows)
endif()

target_compile_definitions(Play
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Play
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)

install(TARGETS Play
    DESTINATION "${CXFW_BINARY_DIR}"
)
