CX_TARGET_NAME = botan-no-use
CONFIG -= qt

include ($$PWD/../../utils/static_library.pri)

header.files = $$PWD/include/botan/*.h
header.path = $$CX_PROD_DIR/include/third_party/botan
lib.files = $$PWD/$$last(_SPEC)/lib/*.a
lib.path = $$DESTDIR
INSTALLS += header lib
