CX_TARGET_NAME = ITcore
QT -= gui
QT += sql

DEFINES += ITCORE_LIBRARY

SOURCES += \
    itcore.cpp \
    localstorage.cpp \
    pagemodel.cpp

HEADERS += \
    itcore_global.h \
    itcore.h \
    localstorage.h \
    pagemodel.h

include ($$PWD/../../../utils/library.pri)

target.files += $$PWD/*.h
target.path = $${CX_PROD_DIR}/include/itcore

INSTALLS += target
