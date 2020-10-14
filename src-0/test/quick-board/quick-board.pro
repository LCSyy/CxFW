CX_TARGET_NAME = quick-board
QT += quick quickcontrols2 network

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

SOURCES += \
        main.cpp \
        networkmanager.cpp \
        silencestyle.cpp \
        wanderstyle.cpp

RESOURCES += qml.qrc

include($$PWD/../../utils/app.pri)

HEADERS += \
    networkmanager.h \
    silencestyle.h \
    wanderstyle.h
