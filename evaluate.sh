#!/bin/bash

ENERGY_PARAMETERS="energy-cores,energy-gpu,energy-pkg,energy-ram"
NUM_OF_THREADS=$1
SCHEDULE_TYPE=$2
FILENAME="${NUM_OF_THREADS}_threads_${SCHEDULE_TYPE}_schedule.txt"

function get_perf_performance_information {
    if [ -s $filepath ]; then
        echo "Performance saved in $filepath successfully!"
        # get the lines that contain the text "Process time", "cycles",
        # "instructions", "branches", "branch-misses" and save them in a 
        # temporal file called "temporal.txt". Once it's created, save that information
        # in the $filepath file and remove the temporal file
        grep -E "Process time|cycles|instructions|branches|branch-misses" $filepath > /tmp/temporal.txt
        cat /tmp/temporal.txt > $filepath
        rm /tmp/temporal.txt
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
        grep -E "Process time|energy-cores|energy-pkg|energy-ram" $filepath > /tmp/temporal.txt
        cat /tmp/temporal.txt > $filepath
        rm /tmp/temporal.txt
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
