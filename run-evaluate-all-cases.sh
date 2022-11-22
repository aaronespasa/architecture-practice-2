#!/bin/bash

# Remember to execute this script with the following command:
# $ . run-evaluate-all-cases.sh

# Check if the "aos", "soa" and "common" folders exist
if [ ! -d "aos" ] || [ ! -d "soa" ] || [ ! -d "common" ]; then
    echo "You must run this script from the root of the repository"
    exit 1
fi

function create_results_folder {
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
}

# Create the "results" folder if it does not exist
if [ ! -d "results" ]; then
    create_results_folder
else 
    rm -rf results
    create_results_folder
fi

# Export the path to the compiler
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64

# only execute the following code if the release folder does not exist
if [ ! -d "release" ]; then
    # Build the project
    cmake -S . -B release -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/opt/gcc-12.1.0/bin/c++
    cmake --build release

    # Go to the release folder, make the project and go back to the root folder
    cd ./release
    make
    cd ..
fi

# Execute the evaluate.sh for just one thread
# sudo . ./evaluate.sh 1 "none"

# make a for loop for elements 2, 4, 8, 16
for i in 2 4 8 16
do
    export OMP_NUM_THREADS=$i
    # make a for loop for the multiple types of OMP schedules
    # modifying the environmental variable OMP_SCHEDULE
    for j in "static" "dynamic" "guided,4"
    do
        export OMP_SCHEDULE=$j

        ENERGY_PARAMETERS="energy-cores,energy-gpu,energy-pkg,energy-ram"
        NUM_OF_THREADS=$i
        SCHEDULE_TYPE=$j
        FILENAME="${NUM_OF_THREADS}_threads_${SCHEDULE_TYPE}_schedule.txt"

        function get_perf_performance_information {
            if [ -s $filepath ]; then
                echo "Performance saved in $filepath successfully!"
                # get the lines that contain the text "Process time", "cycles",
                # "instructions", "branches", "branch-misses" and save them in a 
                # temporal file called "temporal.txt". Once it's created, save that information
                # in the $filepath file and remove the temporal file
                grep -E "Process time|cycles|instructions|branches|branch-misses" $filepath > temporal.txt
                cat temporal.txt > $filepath
                rm temporal.txt
            else
                echo "Error in Performance: File $filepath is empty!"
            fi
        }

        function get_perf_energy_information {
            if [ -s $filepath ]; then
                echo "Energy saved in $filepath successfully!"
                # get the lines that contain the text "Process time", "energy-cores",
                # "energy-pkg", "energy-ram" and save them in a temporal file called
                # "temporal.txt". Once it's created, save that information in the $filepath
                # file and remove the temporal file
                grep -E "Process time|energy-cores|energy-pkg|energy-ram" $filepath > temporal.txt
                cat temporal.txt > $filepath
                rm temporal.txt
            else
                echo "Error in Energy: File $filepath is empty!"
            fi
        }

        echo "Evaluating the 3 functions both for SOA & AOS"

        echo "------------ HISTOGRAM (AOS) ------------ "

        filefolder="./results/rendimiento/histo/aos"
        filepath="${filefolder}/${FILENAME}"
        perf stat ./release/img-aos ./in ./out histo > ${filepath} 2>&1
        get_perf_performance_information

        filefolder="./results/energia/histo/aos"
        filepath="${filefolder}/${FILENAME}"
        perf stat -a -e $ENERGY_PARAMETERS ./release/img-aos ./in ./out histo > ${filepath} 2>&1
        get_perf_energy_information

        echo "------------ GRAYSCALE (AOS) ------------ "

        filefolder="./results/rendimiento/mono/aos"
        filepath="${filefolder}/${FILENAME}"
        perf stat ./release/img-aos ./in ./out mono > ${filepath} 2>&1
        get_perf_performance_information

        filefolder="./results/energia/mono/aos"
        filepath="${filefolder}/${FILENAME}"
        perf stat -a -e $ENERGY_PARAMETERS ./release/img-aos ./in ./out mono > ${filepath} 2>&1
        get_perf_energy_information

        echo "------------ GAUSS (AOS) ------------ "

        filefolder="./results/rendimiento/gauss/aos"
        filepath="${filefolder}/${FILENAME}"
        perf stat ./release/img-aos ./in ./out gauss > ${filepath} 2>&1
        get_perf_performance_information

        filefolder="./results/energia/gauss/aos"
        filepath="${filefolder}/${FILENAME}"
        perf stat -a -e $ENERGY_PARAMETERS ./release/img-aos ./in ./out gauss > ${filepath} 2>&1
        get_perf_energy_information

        echo "------------ HISTOGRAM (SOA) ------------ "

        filefolder="./results/rendimiento/histo/soa"
        filepath="${filefolder}/${FILENAME}"
        perf stat ./release/img-soa ./in ./out histo > ${filepath} 2>&1
        get_perf_performance_information

        filefolder="./results/energia/histo/soa"
        filepath="${filefolder}/${FILENAME}"
        perf stat -a -e $ENERGY_PARAMETERS ./release/img-soa ./in ./out histo > ${filepath} 2>&1
        get_perf_energy_information

        echo "------------ GRAYSCALE (SOA) ------------ "

        filefolder="./results/rendimiento/mono/soa"
        filepath="${filefolder}/${FILENAME}"
        perf stat ./release/img-soa ./in ./out mono > ${filepath} 2>&1
        get_perf_performance_information

        filefolder="./results/energia/mono/soa"
        filepath="${filefolder}/${FILENAME}"
        perf stat -a -e $ENERGY_PARAMETERS ./release/img-soa ./in ./out mono > ${filepath} 2>&1
        get_perf_energy_information

        echo "------------ GAUSS (SOA) ------------ "

        filefolder="./results/rendimiento/gauss/soa"
        filepath="${filefolder}/${FILENAME}"
        perf stat ./release/img-soa ./in ./out gauss > ${filepath} 2>&1
        get_perf_performance_information

        filefolder="./results/energia/gauss/soa"
        filepath="${filefolder}/${FILENAME}"
        perf stat -a -e $ENERGY_PARAMETERS ./release/img-soa ./in ./out gauss > ${filepath} 2>&1
        get_perf_energy_information

        echo "Finished evaluating"
    done
done
