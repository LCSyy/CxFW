CX_TARGET_NAME = PixelArtEditor

QT += quick

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

CXLIB_LIST += PixelArt

include ($$PWD/../../../utils/app.pri)
