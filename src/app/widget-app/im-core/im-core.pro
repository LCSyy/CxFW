QT -= gui
CX_TARGET_NAME = im-core
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

DEFINES += IMCORE_LIBRARY

SOURCES += \
    cxim.cpp

HEADERS += \
    imcore_global.h \
    cxim.h

include($$PWD/../../../utils/library.pri)
