CX_TARGET_NAME = quickplugin
CX_PLUGIN_DEST = qml/cxquick
QT += gui

SOURCES += \
    cxquickplugin.cpp

HEADERS += \
    cxquickplugin.h

DISTFILES += quickplugin.json

include($$PWD/../../../utils/plugin.pri)
