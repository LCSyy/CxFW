TEMPLATE = aux

include($$PWD/../../utils/frameworks.pri)

header.files = $$PWD/include/botan/*.h
header.path = $$CX_PROD_DIR/include/third_party/botan
lib.files = $$PWD/$$last(_SPEC)/lib/*.a
lib.path = $$DESTDIR
INSTALLS += header lib
