CX_TARGET_NAME = widget-im
QT += core gui widgets network quick quickcontrols2 quickwidgets

CONFIG(release, debug|release) {
    CONFIG += qtquickcompiler
}

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

TRANSLATIONS += \
    $${CX_TARGET_NAME}_zh.ts \
    $${CX_TARGET_NAME}_en.ts

RESOURCES += \
    res.qrc

include($$PWD/im/im.pri)
include($$PWD/login/login.pri)
include($$PWD/../../utils/app.pri)
