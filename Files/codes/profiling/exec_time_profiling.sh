#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <script_name> <number_of_runs> <frequency>"
    exit 1
fi

SCRIPT_NAME=$1
NUM_RUNS=$2
FREQ=$3

echo "Setting CPU frequency to $FREQ MHz"
sudo cpufreq-set -c 0 -f ${FREQ}Mhz
sudo cpufreq-set -c 1 -f ${FREQ}Mhz
sudo cpufreq-set -c 2 -f ${FREQ}Mhz
sudo cpufreq-set -c 3 -f ${FREQ}Mhz


start_time=$(date +%s.%N)

for ((i=1; i<=NUM_RUNS; i++)); do
    ./"$SCRIPT_NAME"
done

end_time=$(date +%s.%N)

runtime=$(echo "$end_time - $start_time" | bc -l | xargs printf "%.3f")

echo "Frequency: $FREQ MHz, Average Time: $(echo "scale=2; $runtime / $NUM_RUNS" | bc) seconds"
echo "-----------------------------------
