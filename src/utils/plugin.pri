# target_name
# QT +=
# HEADERS +=
# SOURCES +=

TEMPLATE = lib

CONFIG += c++14 qt plugin

DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

TARGET = $$qtLibraryTarget($$lower($${target_name}))

# destdir
_SPEC = $$split(QMAKESPEC,/)
CX_SDK_DIR = $${PWD}/../../dist/sdk
CX_DEST_VERSION = qt$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}-$$last(_SPEC)
DESTDIR = $$CX_SDK_DIR/$$CX_DEST_VERSION/plugin/$$target_name
