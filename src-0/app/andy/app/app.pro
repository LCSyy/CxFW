CX_TARGET_NAME = andy-app

QT += quick sql

SOURCES += \
        backend.cpp \
        liststoragemodel.cpp \
        main.cpp

HEADERS += \
    backend.h \
    liststoragemodel.h

RESOURCES += qml.qrc

CXLIB_LIST += andy-core cxbase

include ($$PWD/../../../utils/app.pri)

