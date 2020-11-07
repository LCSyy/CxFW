cmake_minimum_required(VERSION 3.15)

project(CxMarkdownHightlighter
    VERSION 0.0.1
    DESCRIPTION "cxfw Markdown syntax highlighter."
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/../../dist/")

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)


find_package(Qt5 COMPONENTS Gui REQUIRED)

add_library(CxMarkdownHighlighter
    cxmarkdownhighlighter.h cxmarkdownhighlighter.cpp)

target_link_libraries(CxMarkdownHighlighter Qt5::Gui)

install(TARGETS CxMarkdownHighlighter DESTINATION bin)
install(FILES cxmarkdownhighlighter.h DESTINATION "include/${PROJECT_NAME}")
