CX_TARGET_NAME = andy-core
QT -= gui
QT += sql concurrent
DEFINES += CORE_LIBRARY

SOURCES += \
    core.cpp \
    localstorage.cpp \
    usermanager.cpp \
    systemmanager.cpp \
    localstorageworker.cpp

HEADERS += \
    core_global.h \
    core.h \
    localstorage.h \
    usermanager.h \
    systemmanager.h \
    localstorageworker.h

include($$PWD/../../../utils/library.pri)

target.path = $${CX_PROD_DIR}/include/andy-core
target.files = $$PWD/*.h
INSTALLS += target
