CX_TARGET_NAME = PixelArt
QT -= gui

DEFINES += PIXELART_LIBRARY


SOURCES += \
    canvas_line.cpp \
    pixelart.cpp

HEADERS += \
    PixelArt_global.h \
    canvas_line.h \
    pixelart.h

include ($$PWD/../../../utils/library.pri)

target.files += *.h
target.path = $$CX_PROD_DIR/include/pixel_art
INSTALLS += target

QT += quick
