# 说明：
# 1.pro文件中，变量命名规则：
#   1.全部大写，单词以下划线区分
#   2.在外部可用的变量以字母开头，不可在外部使用的以下划线开头
# 2.每个pro文件可用变量在文件开头注释列出

# 变量：
# QT +=
# SOURCES +=
# HEADERS +=
# QML_IMPORT_PATH =
# QML_DESIGNER_IMPORT_PATH =
#
# CX_TARGET_NAME =
# CXLIB_LIST +=

# 只读变量
# CX_FRAMEWORKS_ROOT_DIR
# CX_SOURCE_DIR
# CX_DIST_DIR
# CX_PLATFORM
# CX_PROD_DIR

TARGET = $$qtLibraryTarget($${CX_TARGET_NAME})

CONFIG += c++14

DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CX_FRAMEWORKS_ROOT_DIR = $${PWD}/../../
CX_SOURCE_DIR = $${CX_FRAMEWORKS_ROOT_DIR}/src/
CX_DIST_DIR = $${CX_FRAMEWORKS_ROOT_DIR}/dist/
_SPEC = $$split(QMAKESPEC,/)
CX_PLATFORM = qt$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}-$$last(_SPEC)
CX_PROD_DIR = $${CX_DIST_DIR}/$$CX_PLATFORM/

INCLUDEPATH += \
    $${CX_PROD_DIR}/include/

CONFIG(debug,debug|release) {
    DESTDIR = $${CX_PROD_DIR}/debug/
}
CONFIG(release,debug|release) {
    DESTDIR = $${CX_PROD_DIR}/release/
}

for(LIB,CXLIB_LIST) {
    CONFIG(debug,debug|release) {
        win32:LIBS += $${DESTDIR}/lib$${LIB}d.a
    }
    CONFIG(release,debug|release) {
        win32:LIBS += $${DESTDIR}/lib$${LIB}.a
    }
}
