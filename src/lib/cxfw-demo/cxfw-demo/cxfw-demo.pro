CX_TARGET_NAME = cxfw-demo
QT -= gui
DEFINES += CXFWDEMO_LIBRARY

SOURCES += \
    cxfw.cpp

HEADERS += \
    cxfw-demo_global.h \
    cxfw.h

include($$PWD/../../../utils/library.pri)

cxfw-demo.files += $${HEADERS}
cxfw-demo.path = $${CX_PROD_DIR}/include/cxfw-demo
INSTALLS += cxfw-demo
