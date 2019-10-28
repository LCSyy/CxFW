CX_TARGET_NAME = widget-im
QT += core gui widgets quick quickcontrols2 quickwidgets

SOURCES += \
    chatitem.cpp \
    chatmsgmodel.cpp \
    globalkv.cpp \
    main.cpp \
    mainwindow.cpp \
    messageeditwidget.cpp \
    naviwidget.cpp \
    page/chatpage.cpp \
    page/settingpage.cpp \
    pagecontainer.cpp \
    navi/contactnavi.cpp \
    pagewidget.cpp \
    textmetrics.cpp \
    utility.cpp

HEADERS += \
    chatitem.h \
    chatmsgmodel.h \
    globalkv.h \
    mainwindow.h \
    messageeditwidget.h \
    naviwidget.h \
    page/chatpage.h \
    page/settingpage.h \
    pagecontainer.h \
    navi/contactnavi.h \
    pagewidget.h \
    textmetrics.h \
    utility.h

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

RESOURCES += \
    res.qrc

include($$PWD/im/im.pri)
include($$PWD/../../utils/app.pri)
