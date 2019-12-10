# CX_PLUGIN_DEST

TEMPLATE = lib
CONFIG += plugin

include($$PWD/frameworks.pri)

DESTDIR = $${DESTDIR}/$${CX_PLUGIN_DEST}
