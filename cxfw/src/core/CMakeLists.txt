add_library(cxcore
    cxcommand_line_parser.cpp
    cxcommand_line_option.cpp
)

target_include_directories(cxcore
    INTERFACE "${PROJECT_SOURCE_DIR}/src"
    PUBLIC "${PROJECT_BINARY_DIR}/src"
)

install(TARGETS cxcore DESTINATION lib)
install(
    FILES
        cxcommand_line_parser.h
        cxcommand_line_option.h
    DESTINATION
        include/cxfw/core
)
