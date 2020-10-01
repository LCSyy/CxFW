cmake_minimum_required(VERSION 3.15)

project(cxfw-foot VERSION 0.0.1)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

option(USE_CMDLINE "Use cmdline library" ON)

configure_file(cxfw_version.hpp.in cxfw_version.hpp)

if(USE_CMDLINE)
    add_subdirectory(cmdline)
    list(APPEND EXTRA_LIBS cmdline)
    list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}")
endif()

add_executable(cxfw main.cpp)
target_link_libraries(cxfw PUBLIC ${EXTRA_LIBS})
target_include_directories(cxfw PUBLIC
    "${PROJECT_BINARY_DIR}"
    ${EXTRA_INCLUDES}
)
