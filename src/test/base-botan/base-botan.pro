CX_TARGET_NAME = base-botan-test

QT -= gui

# QMAKE_LFLAGS_CONSOLE += -fstack-protector

# INCLUDEPATH += $$PWD/thirdparty/include
# LIBS += $$PWD/thirdparty/lib/libbotan-2.a

SOURCES += \
        main.cpp

CXLIB_LIST += cxbase

include($$PWD/../../utils/app.pri)

CONFIG += c++11 console
CONFIG -= app_bundle
