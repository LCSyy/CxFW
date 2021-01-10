cmake_minimum_required(VERSION 3.15)

project(CxFw
    VERSION 0.0.1
    DESCRIPTION "CxFw based on qt."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(MarkdownSyntaxHighlighter)
add_subdirectory(QGlobalShortcut)
add_subdirectory(CxCore)
add_subdirectory(CxNetwork)
add_subdirectory(CxQuickControls)
add_subdirectory(CxQuick)
add_subdirectory(CxBinding)
add_subdirectory(CxApp)
