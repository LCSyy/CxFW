CX_TARGET_NAME = widget-cv
QT += core gui widgets quick quickcontrols2 network

# DEFINES +=
# CONFIG +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

SOURCES += \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    mainwindow.h

include($$PWD/../../utils/app.pri)

INCLUDEPATH += $$CX_DIST_DIR/thirdparty

# OpenCV
OPENCV_PREFIX = libopencv_
OPENCV_MODULES += core411
for(omodule, OPENCV_MODULES) {
    win32:LIBS += $${DESTDIR}/$${OPENCV_PREFIX}$${omodule}.dll.a
}
