CX_TARGET_NAME = sqlite3

CONFIG -= qt

SOURCES += \
    sqlite3.c

HEADERS += \
    sqlite3.h \
    sqlite3ext.h

include ($$PWD/../../utils/static_library.pri)

target.path = $${CX_PROD_DIR}/include/third_party/sqlite3
target.files += *.h
INSTALLS += target
