CX_TARGET_NAME = cxfw-run
QT -= gui
CONFIG += c++11 console
CONFIG -= app_bundle

SOURCES += \
        main.cpp

include($$PWD/../../../utils/app.pri)
