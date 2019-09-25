CX_TARGET_NAME = quick-board
QT += quick

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

SOURCES += \
        main.cpp \
        silencestyle.cpp

RESOURCES += qml.qrc

include($$PWD/../../utils/app.pri)

HEADERS += \
    silencestyle.h
