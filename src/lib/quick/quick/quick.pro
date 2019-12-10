CX_TARGET_NAME = cxquick
QT += gui
DEFINES += QUICK_LIBRARY

SOURCES += \
    cxquick.cpp

HEADERS += \
    quick_global.h \
    cxquick.h

include($$PWD/../../../utils/library.pri)
