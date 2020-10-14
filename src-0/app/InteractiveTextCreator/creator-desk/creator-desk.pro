CX_TARGET_NAME = ITcreator-desktop
QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

SOURCES += \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    mainwindow.h

include ($$PWD/../../../utils/app.pri)
