CX_TARGET_NAME = cxcore
QT -= gui
DEFINES += CORE_LIBRARY

SOURCES += \
    core.cpp \
    localstorage.cpp

HEADERS += \
    core_global.h \
    core.h \
    localstorage.h

include($$PWD/../../../utils/library.pri)

target.path = $$CX_PROD_DIR/include/cxcore
target.files = $$PWD/*.h
INSTALLS += target
