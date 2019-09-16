CX_TARGET_NAME = cxquick
QT += quick
DEFINES += CXQUICK_LIBRARY
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
# CXLIB_LIST +=

CXQUICK_SOURCES += \
    cxquick.cpp

CXQUICK_HEADERS += \
    cxquick_global.h \
    cxquick.h

SOURCES += \
    $${CXQUICK_SOURCES}

HEADERS += \
    $${CXQUICK_HEADERS}

include($$PWD/../../utils/library.pri)

cxquick.files += $${CXQUICK_HEADERS}
cxquick.path = $$CX_PROD_DIR/include/cxquick
INSTALLS += cxquick
