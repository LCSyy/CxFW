CX_TARGET_NAME = andy-service

QT       += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

SOURCES += \
    main.cpp \
    widget.cpp

HEADERS += \
    widget.h

RESOURCES += \
    res.qrc

include ($$PWD/../../../utils/app.pri)
