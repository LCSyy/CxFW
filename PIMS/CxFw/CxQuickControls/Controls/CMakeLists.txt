set(ITEM_FILES
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
        qmldir
        ${ITEM_FILES}
)

install(FILES qmldir ${ITEM_FILES} DESTINATION "bin/plugins/CxQuick/Controls")
