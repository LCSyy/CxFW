#-------------------------------------------------
#
# Project created by QtCreator 2019-06-09T08:36:26
#
#-------------------------------------------------

CX_TARGET_NAME = cxbase

QT       -= gui

DEFINES += CXBASE_LIBRARY

QMAKE_LFLAGS_SHLIB += -fstack-protector

INCLUDEPATH += \
    $${PWD}/thirdparty/include/ \
    $${PWD}/embed/

THIRD_PARTY_SOURCES += \
    embed/qrcode/qrcode.c \
    embed/sqlite/sqlite3.c

THIRD_PARTY_HEADERS += \
    embed/qrcode/qrcode.h \
    embed/sqlite/sqlite3.h

CXBASE_SOURCES += \
    cxbase.cpp \
    storage.cpp

CXBASE_HEADERS += \
    cxbase_global.h \
    cxbase.h \
    storage.h

SOURCES += \
    $${THIRD_PARTY_SOURCES} \
    $${CXBASE_SOURCES}

HEADERS += \
    $${THIRD_PARTY_HEADERS} \
    $${CXBASE_HEADERS}

LIBS += $${PWD}/thirdparty/lib/libbotan-2.a

include($$PWD/../../utils/library.pri)

cxbase.files += $${CXBASE_HEADERS}
cxbase.path = $$CX_PROD_DIR/include/cxbase
INSTALLS += cxbase
