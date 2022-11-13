add_library(aos bitmap_aos.cpp)
target_link_libraries(aos common OpenMP::OpenMP_CXX)
target_include_directories(aos PUBLIC ..)
