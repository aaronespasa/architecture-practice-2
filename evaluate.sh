#!/bin/bash

ENERGY_PARAMETERS="energy-cores,energy-gpu,energy-pkg,energy-ram"

echo "Evaluating the 3 functions both for SOA & AOS"

echo "------------ HISTOGRAM (AOS) ------------ "

echo "Performance:"
perf stat ./release/img-aos ./in ./out histo

echo "Energy:"
perf stat -a -e $ENERGY_PARAMETERS ./release/img-aos ./in ./out histo

echo "------------ GRAYSCALE (AOS) ------------ "

echo "Performance:"
perf stat ./release/img-aos ./in ./out mono

echo "Energy:"
perf stat -a -e $ENERGY_PARAMETERS ./release/img-aos ./in ./out mono

echo "------------ GAUSS (AOS) ------------ "

echo "Performance:"
perf stat ./release/img-aos ./in ./out gauss

echo "Energy:"
perf stat -a -e $ENERGY_PARAMETERS ./release/img-aos ./in ./out gauss

echo "------------ HISTOGRAM (SOA) ------------ "

echo "Performance:"
perf stat ./release/img-soa ./in ./out histo

echo "Energy:"
perf stat -a -e $ENERGY_PARAMETERS ./release/img-soa ./in ./out histo

echo "------------ GRAYSCALE (SOA) ------------ "

echo "Performance:"
perf stat ./release/img-soa ./in ./out mono

echo "Energy:"
perf stat -a -e $ENERGY_PARAMETERS ./release/img-soa ./in ./out mono

echo "------------ GAUSS (SOA) ------------ "

echo "Performance:"
perf stat ./release/img-soa ./in ./out gauss

echo "Energy:"
perf stat -a -e $ENERGY_PARAMETERS ./release/img-soa ./in ./out gauss

echo "Finished evaluating"
