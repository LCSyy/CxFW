add_custom_target(CxFwStyle
  SOURCES
    qmldir
    Button.qml
    Menu.qml
    MenuSeparator.qml
    ToolBar.qml
    ToolSeparator.qml
    ComboBox.qml
)

install(FILES
    qmldir
    Button.qml
    Menu.qml
    MenuSeparator.qml
    ToolBar.qml
    ToolSeparator.qml
    ComboBox.qml
    DESTINATION "qml/CxQuick/CxFw")
