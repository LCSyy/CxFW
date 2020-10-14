CX_TARGET_NAME = quick-controls-test
QT += quick
# DEFINES +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =

# QMAKE_LFLAGS_CONSOLE += -fstack-protector
# INCLUDEPATH += $$PWD/thirdparty/include
# LIBS += $$PWD/thirdparty/lib/libbotan-2.a

# CXLIB_LIST += cxquick

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

include($$PWD/../../utils/app.pri)
