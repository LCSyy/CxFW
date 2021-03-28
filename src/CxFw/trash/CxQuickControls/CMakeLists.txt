cmake_minimum_required(VERSION 3.15)

project(CxQuickControls
    VERSION 0.1
    DESCRIPTION "Quick Controls and CxFw QuickControl Style."
)

add_subdirectory(CxFw)

set(src
    qmldir
    Badge.qml
    Banner.qml
    HomePage.qml
    MainPage.qml
    Popup.qml
    StatusBar.qml
    TextField.qml
)

add_custom_target(Controls
  SOURCES
    ${src}
)

install(FILES ${src} DESTINATION "bin/plugins/CxQuick/Controls")
