CX_TARGET_NAME = localstorage

QT -= gui
QT += sql

TEMPLATE = lib
DEFINES += LOCALSTORAGE_LIBRARY

SOURCES += \
    localstorage.cpp

HEADERS += \
    localstorage_global.h \
    localstorage.h

include ($$PWD/../../utils/library.pri)
