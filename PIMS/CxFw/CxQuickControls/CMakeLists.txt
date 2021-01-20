set(CONTROLS_SOURCES
    qml.qrc
)

set(QUICK_FILES
    Quick/LinkItem.qml
    Quick/ListViewLighlighter.qml
    Quick/Mask.qml
    Quick/OneColumnTreeView.qml
)

set(JS_FILES
    Scripts/cxfw.js
)

add_subdirectory(CxFw)
add_subdirectory(Controls)

add_custom_target(CxQuickControls
    SOURCES
        ${CONTROLS_SOURCES}
)

install(FILES ${CONTROLS_SOURCES} DESTINATION "bin/plugins/CxQuick")
install(FILES ${QUICK_FILES} DESTINATION "bin/plugins/CxQuick/Quick")
install(FILES ${JS_FILES} DESTINATION "bin/plugins/CxQuick/Scripts")
