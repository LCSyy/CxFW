CX_TARGET_NAME = Spark

QT += quick quickcontrols2

SOURCES += \
        canvas.cpp \
        canvas_shape.cpp \
        main.cpp

RESOURCES += qml.qrc

include($$PWD/../../../utils/app.pri)

HEADERS += \
    canvas.h \
    canvas_shape.h
