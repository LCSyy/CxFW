cmake_minimum_required(VERSION 3.15)

project(CxQuickControls
    VERSION 0.0.1
    DESCRIPTION "CxFw Quick Controls."
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# set(CMAKE_CXX_STANDARD 11)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)

# find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
# find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core REQUIRED)

add_custom_target(CxQuickControls
  SOURCES
    qml.qrc
    qmldir
    CxFw/Button.qml
    CxFw/Menu.qml
    CxFw/MenuSeparator.qml
    CxFw/ToolBar.qml
    CxFw/ToolSeparator.qml
    CxFw/ComboBox.qml
)
