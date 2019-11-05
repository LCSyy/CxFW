CX_TARGET_NAME = widget-app

QT       += core gui widgets

SOURCES += \
    bridge.cpp \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    bridge.h \
    mainwindow.h

include($$PWD/../../../utils/app.pri)
