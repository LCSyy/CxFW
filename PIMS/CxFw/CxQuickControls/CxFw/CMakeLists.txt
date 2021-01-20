set(CXFW_FILES
    qmldir
    Button.qml
    ComboBox.qml
    Menu.qml
    MenuSeparator.qml
    ToolBar.qml
    ToolSeparator.qml
)

add_custom_target(CxFwStyle
    SOURCES
        ${CXFW_FILES}
)

install(FILES ${CXFW_FILES} DESTINATION "bin/plugins/CxQuick/CxFw")
