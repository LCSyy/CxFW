cmake_minimum_required(VERSION 3.15)

project(MarkdownSyntaxHighlighter LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Gui REQUIRED)

add_library(MarkdownSyntaxHighlighter
    markdownhighlighter.cpp markdownhighlighter.h
    qownlanguagedata.cpp qownlanguagedata.h
)

target_link_libraries(MarkdownSyntaxHighlighter
  PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
)
