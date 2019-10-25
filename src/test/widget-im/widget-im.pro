CX_TARGET_NAME = widget-im
QT += core gui widgets

SOURCES += \
    chatwidget.cpp \
    main.cpp \
    mainwindow.cpp \
    messageeditwidget.cpp

HEADERS += \
    chatwidget.h \
    mainwindow.h \
    messageeditwidget.h

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

include($$PWD/../../utils/app.pri)

RESOURCES += \
    res.qrc
