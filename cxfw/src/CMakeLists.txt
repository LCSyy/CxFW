configure_file(cxfw_global.h.in cxfw/cxfw_global.h)

add_subdirectory(base)
add_subdirectory(core)
add_subdirectory(app)

install(FILES "${PROJECT_BINARY_DIR}/src/cxfw/cxfw_global.h" DESTINATION include/cxfw)

