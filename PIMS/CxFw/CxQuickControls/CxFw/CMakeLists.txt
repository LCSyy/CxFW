set(src
    qmldir
    Button.qml
    ComboBox.qml
    Menu.qml
    MenuSeparator.qml
    TextField.qml
    ToolBar.qml
    ToolSeparator.qml
)

add_custom_target(CxFwStyle SOURCES ${src})

install(FILES ${src} DESTINATION "bin/plugins/CxQuick/Controls/CxFw")
