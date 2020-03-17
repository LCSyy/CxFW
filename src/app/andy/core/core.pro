CX_TRAGET_NAME = andy-core
QT -= gui
DEFINES += CORE_LIBRARY

SOURCES += \
    core.cpp

HEADERS += \
    core_global.h \
    core.h

include($$PWD/../../../utils/library.pri)
