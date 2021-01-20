set(CONTROLS_SOURCES
    qml.qrc
)

set(QUICK_FILES
    Quick/LinkItem.qml
    Quick/ListViewLighlighter.qml
    Quick/Mask.qml
    Quick/OneColumnTreeView.qml
)

set(ITEM_FILES
    Controls/Badge.qml
    Controls/Banner.qml
    Controls/HomePage.qml
    Controls/MainPage.qml
    Controls/Popup.qml
    Controls/StatusBar.qml
    Controls/TextField.qml
)
set(JS_FILES
    Scripts/cxfw.js
)

add_subdirectory(CxFw)

add_custom_target(CxQuickControls
    SOURCES
        ${CONTROLS_SOURCES}
)

install(FILES ${CONTROLS_SOURCES} DESTINATION "bin/plugins/CxQuick")
install(FILES ${QUICK_FILES} DESTINATION "bin/plugins/CxQuick/Quick")
install(FILES ${ITEM_FILES} DESTINATION "bin/plugins/CxQuick/Controls")
install(FILES ${JS_FILES} DESTINATION "bin/plugins/CxQuick/Scripts")
