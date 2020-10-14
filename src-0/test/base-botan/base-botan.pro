CX_TARGET_NAME = base-botan-test
QT -= gui
CONFIG += console
CONFIG -= app_bundle
# DEFINES +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =

# QMAKE_LFLAGS_CONSOLE += -fstack-protector
# INCLUDEPATH += $$PWD/thirdparty/include
# LIBS += $$PWD/thirdparty/lib/libbotan-2.a

CXLIB_LIST += cxbase

SOURCES += \
        main.cpp

include($$PWD/../../utils/app.pri)
