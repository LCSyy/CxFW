cmake_minimum_required(VERSION 3.15)

project(CxCore
    VERSION 0.0.1
    DESCRIPTION "CxFw Core."
    LANGUAGES CXX
)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
include(CxFw)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core REQUIRED)

set(PROJECT_MODULE_SOURCES
    cmake/CxCoreConfig.cmake
    cmake/CxCoreConfigVersion.cmake
)

add_custom_target( CxCoreModule
   SOURCES "${PROJECT_MODULE_SOURCES}"
)

add_library(CxCore
    cxlistmodel.cpp
    cxlistmodel.h
    cxurls.cpp
    cxurls.h
    cxsettings.cpp
    cxsettings.h
)

target_link_libraries(CxCore
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
)

install(
    DIRECTORY cmake/
    DESTINATION "${CMAKE_INSTALL_PREFIX}/cmake/${CMAKE_PROJECT_NAME}"
)

install(
    TARGETS CxCore
    DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_PROJECT_NAME}"
)

set(PROJECT_SOURCES
    cxlistmodel.cpp
    cxlistmodel.h
    cxurls.cpp
    cxurls.h
    cxsettings.cpp
    cxsettings.h
)

list(FILTER PROJECT_SOURCES INCLUDE REGEX \.h$)
message("==> ${PROJECT_SOURCES}")
install(FILES ${PROJECT_SOURCES}
    DESTINATION "${CMAKE_INSTALL_PREFIX}/include/${CMAKE_PROJECT_NAME}"
)
