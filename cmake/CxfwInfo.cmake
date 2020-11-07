# set(QML_IMPORT_PATH "${CMAKE_CURRENT_LIST_DIR}/../../dist/bin/qml" CACHE PATH "qml search dir.")
set(QML2_IMPORT_PATH "${CMAKE_CURRENT_LIST_DIR}/../../dist/bin/qml" CACHE PATH "qml search dir.")
add_compile_definitions(CXFW_QML2_IMPORT_PATH="$CACHE{QML2_IMPORT_PATH}")
