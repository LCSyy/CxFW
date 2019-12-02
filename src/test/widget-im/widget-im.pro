CX_TARGET_NAME = widget-im
QT += core gui widgets network

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    messenger.cpp

HEADERS += \
    mainwindow.h \
    messenger.h

TRANSLATIONS += \
    $${CX_TARGET_NAME}_zh.ts \
    $${CX_TARGET_NAME}_en.ts

RESOURCES += \
    res.qrc
