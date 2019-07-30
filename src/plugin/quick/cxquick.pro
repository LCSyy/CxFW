target_name = CxQuick

DEFINES = CXQUICK_SHARED_LIBRARY

QT += qml quick

HEADERS += \
    cxcolorpicker.h \
    cxquick_global.h \
    cxquickplugin.h

SOURCES += \
    cxcolorpicker.cpp \
    cxquickplugin.cpp

DISTFILES += \
    qmldir \
    qml\ColorPicker.qml \
    qml\MovableItem.qml

include($$PWD/../../utils/plugin.pri)

# Copy library files

# install files
qml_files.path = $$DESTDIR
qml_files.files = $$DISTFILES
INSTALLS += qml_files
