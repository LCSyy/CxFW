CX_TARGET_NAME = Spark

QT += quick quickcontrols2

SOURCES += \
        main.cpp

HEADERS += \

RESOURCES += qml.qrc

include($$PWD/../../../utils/app.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}

