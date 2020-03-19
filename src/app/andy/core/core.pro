CX_TARGET_NAME = andy-core
QT -= gui
QT += sql
DEFINES += CORE_LIBRARY

SOURCES += \
    core.cpp \
    localstorage.cpp

HEADERS += \
    core_global.h \
    core.h \
    localstorage.h

include($$PWD/../../../utils/library.pri)

LIBS += $${DESTDIR}/libsqlite.a

target.path = $${CX_PROD_DIR}/include/andy-core
target.files = $$PWD/*.h
INSTALLS += target
