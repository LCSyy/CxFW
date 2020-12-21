cmake_minimum_required(VERSION 3.15)

project(Writer VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick Widgets Sql QuickControls2 REQUIRED)

set(TS_FILES writer_zh_CN.ts)

add_executable(Writer
    qml.qrc
    logo.rc
    res.qrc

    # ${TS_FILES}

    main.cpp
    cxapplication.cpp
    cxapplication.h
    listmodel.cpp
    listmodel.h
    theme.cpp
    theme.h
)

target_link_options(Writer PRIVATE -mwindows)
target_compile_definitions(Writer
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Writer
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Sql
    Qt${QT_VERSION_MAJOR}::QuickControls2
    CxBinding
)

# qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})

install(TARGETS Writer DESTINATION "bin/")
