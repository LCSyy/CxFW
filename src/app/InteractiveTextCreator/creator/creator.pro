CX_TARGET_NAME = ITcreator

QT += quick

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

CXLIB_LIST += ITcore
include ($$PWD/../../../utils/app.pri)
