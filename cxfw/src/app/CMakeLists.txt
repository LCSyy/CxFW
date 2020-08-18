add_executable(cxfw main.cpp)

target_link_libraries(cxfw PUBLIC cxcore)

install(TARGETS cxfw DESTINATION bin)
