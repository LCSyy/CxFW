add_library(qrcode
    bqrcode.cpp bqrcode.h
    qrcode.c qrcode.h
)

target_include_directories(qrcode INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")
