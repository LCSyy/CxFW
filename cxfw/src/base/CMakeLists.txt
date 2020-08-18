add_library(cxbase
    cxargs.cpp
    cxarguments.cpp
)

target_include_directories(cxbase
    PUBLIC "${PROJECT_BINARY_DIR}/src"
)

install(TARGETS cxbase DESTINATION lib)
install(
    FILES
        cxargs.h
        cxarguments.h
    DESTINATION
        include/cxfw/base
)

