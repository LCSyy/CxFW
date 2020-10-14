CX_TARGET_NAME = qrcode

CONFIG -= qt

SOURCES += \
    qrcode.c

HEADERS += \
    qrcode.h

include ($$PWD/../../utils/static_library.pri)

target.path = $${CX_PROD_DIR}/include/third_party/qrcode
target.files = *.h
INSTALLS += target
