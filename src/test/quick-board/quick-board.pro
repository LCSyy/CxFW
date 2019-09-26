CX_TARGET_NAME = quick-board
QT += quick quickcontrols2

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

SOURCES += \
        main.cpp \
        silencestyle.cpp \
        wanderstyle.cpp

RESOURCES += qml.qrc

include($$PWD/../../utils/app.pri)

HEADERS += \
    silencestyle.h \
    wanderstyle.h
