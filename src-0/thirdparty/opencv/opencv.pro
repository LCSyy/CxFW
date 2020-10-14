TEMPLATE = aux
include ($$PWD/../../utils/frameworks.pri)

# header.files = $$PWD/include/opencv2/*.h
# header.path = $$CX_PROD_DIR/include/third_party/opencv2
# win32:lib.files = $$PWD/$$last(_SPEC)/lib/*.dll
# unix:lib.files = $$PWD/$$last(_SPEC)/lib/*.so
# lib.path = $$DESTDIR
# INSTALLS += header lib

message(3rdParty OpenCV: Copy OpenCV file to <DESTDIR>)
