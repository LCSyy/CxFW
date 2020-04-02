CX_TARGET_NAME = andy-core
QT -= gui
QT += sql
DEFINES += CORE_LIBRARY

SOURCES += \
    core.cpp \
    localstorage.cpp \
    storagemanager.cpp \
    usermanager.cpp \
    # storage.cpp \
    systemmanager.cpp

HEADERS += \
    core_global.h \
    core.h \
    localstorage.h \
    storagemanager.h \
    usermanager.h \
    # storage.h \
    systemmanager.h

include($$PWD/../../../utils/library.pri)

target.path = $${CX_PROD_DIR}/include/andy-core
target.files = $$PWD/*.h
INSTALLS += target
