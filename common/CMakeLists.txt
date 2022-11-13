add_library(common progargs.cpp bitmap_header.cpp pixel.cpp histogram.cpp file_error.cpp normalized_pixel.cpp normalized_pixel.hpp)
# target_link_libraries(common OpenMP::OpenMP_CXX)
target_include_directories(common PUBLIC ..)