#!/bin/bash

# Remember to execute this script with the following command:
# $ . run-evaluate-all-cases.sh

# Check if the "aos", "soa" and "common" folders exist
if [ ! -d "aos" ] || [ ! -d "soa" ] || [ ! -d "common" ]; then
    echo "You must run this script from the root of the repository"
    exit 1
fi

# Create the "results" folder if it does not exist
if [ ! -d "results" ]; then
    mkdir results

    # Rendimiento
    mkdir results/rendimiento
    mkdir results/rendimiento/gauss
    mkdir results/rendimiento/gauss/aos
    mkdir results/rendimiento/gauss/soa
    mkdir results/rendimiento/histo
    mkdir results/rendimiento/histo/aos
    mkdir results/rendimiento/histo/soa
    mkdir results/rendimiento/mono
    mkdir results/rendimiento/mono/aos
    mkdir results/rendimiento/mono/soa

    # Energía
    mkdir results/energia
    mkdir results/energia/gauss
    mkdir results/energia/gauss/aos
    mkdir results/energia/gauss/soa
    mkdir results/energia/histo
    mkdir results/energia/histo/aos
    mkdir results/energia/histo/soa
    mkdir results/energia/mono
    mkdir results/energia/mono/aos
    mkdir results/energia/mono/soa
fi

# Export the path to the compiler
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64

# Build the project
cmake -S . -B release -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/opt/gcc-12.1.0/bin/c++
cmake --build release

# Go to the release folder, make the project and go back to the root folder
cd ./release
make
cd ..

# Execute the evaluate.sh for just one thread
./evaluate.sh 1 "none"

# make a for loop for elements 2, 4, 8, 16
for i in 2 4 8 16
do
    export OMP_NUM_THREADS=$i
    # make a for loop for the multiple types of OMP schedules
    # modifying the environmental variable OMP_SCHEDULE
    for j in "static" "dynamic" "guided,4" "runtime" "auto"
    do
        export OMP_SCHEDULE=$j
        ./evaluate.sh $i $j
    done
done
