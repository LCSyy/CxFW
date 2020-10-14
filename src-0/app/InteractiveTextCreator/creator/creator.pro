CX_TARGET_NAME = ITcreator

QT += quick

SOURCES += \
        main.cpp \
        trendsboardmodel.cpp

RESOURCES += qml.qrc

CXLIB_LIST += ITcore
include ($$PWD/../../../utils/app.pri)

HEADERS += \
    trendsboardmodel.h
