#!/bin/bash

# Export the path to the compiler
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64

# Build the project
cmake -S . -B release -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/opt/gcc-12.1.0/bin/c++
cmake --build release

# Go to the release folder and make the project
cd ./release
make

cd ./utest

# make a for loop for elements 1, 2, 4, 8, 16
for i in 1 2 4 8 16
do
    export OMP_NUM_THREADS=$i
    # make a for loop for the multiple types of OMP schedules
    # modifying the environmental variable OMP_SCHEDULE
    for j in "static" "dynamic" "guided" "runtime"
    do
        export OMP_SCHEDULE=$j
        ./utest > ../results/utest_$i_$j.txt
    done
done
