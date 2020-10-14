CX_TARGET_NAME = quickplugin
CX_PLUGIN_DEST = qml/cxquick
QT += gui quick quickcontrols2

SOURCES += \
    canvas.cpp \
    canvas_shape.cpp \
    cxquickplugin.cpp

HEADERS += \
    canvas.h \
    canvas_shape.h \
    cxquickplugin.h

DISTFILES += \
    qmldir

include($$PWD/../../../utils/plugin.pri)

INSTALLS.CONFIG = no_build
target.files = qmldir
target.path = $$DESTDIR
INSTALLS += target
