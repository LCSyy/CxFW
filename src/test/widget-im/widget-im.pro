CX_TARGET_NAME = widget-im
QT += core gui widgets network quick quickcontrols2 quickwidgets

CONFIG(release, debug|release) {
    CONFIG += qtquickcompiler
}

SOURCES += \
    main.cpp

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

TRANSLATIONS += \
    $${CX_TARGET_NAME}_zh.ts \
    $${CX_TARGET_NAME}_en.ts

RESOURCES += \
    res.qrc

include($$PWD/cpp/cpp.pri)
include($$PWD/../../utils/app.pri)
