CX_TARGET_NAME = andy-app
QT += quick

SOURCES += \
        liststoragemodel.cpp \
        main.cpp

RESOURCES += qml.qrc

include ($$PWD/../../../utils/app.pri)

HEADERS += \
    liststoragemodel.h
