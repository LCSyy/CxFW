CX_TARGET_NAME = andy-app
QT += quick sql

SOURCES += \
        liststoragemodel.cpp \
        main.cpp

HEADERS += \
    liststoragemodel.h

RESOURCES += qml.qrc

CXLIB_LIST += andy-core

include ($$PWD/../../../utils/app.pri)

