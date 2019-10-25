
CX_TARGET_NAME = widget-cv
QT -= gui

CONFIG += c++11 console
CONFIG -= app_bundle

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

SOURCES += \
    main.cpp

include($$PWD/../../utils/app.pri)

INCLUDEPATH += $$CX_DIST_DIR/thirdparty

# OpenCV
OPENCV_PREFIX = libopencv_
OPENCV_MODULES += core411 imgcodecs411 highgui411
for(omodule, OPENCV_MODULES) {
    win32:LIBS += $${DESTDIR}/$${OPENCV_PREFIX}$${omodule}.dll.a
}
