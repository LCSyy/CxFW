CX_TARGET_NAME = widget-im
QT += core gui widgets

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    messageeditwidget.cpp \
    naviwidget.cpp \
    page/chatpage.cpp \
    pagecontainer.cpp \
    navi/contactnavi.cpp

HEADERS += \
    mainwindow.h \
    messageeditwidget.h \
    naviwidget.h \
    page/chatpage.h \
    pagecontainer.h \
    navi/contactnavi.h

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

RESOURCES += \
    res.qrc

include($$PWD/../../utils/app.pri)
