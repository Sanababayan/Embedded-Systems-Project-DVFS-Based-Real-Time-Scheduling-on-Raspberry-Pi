#!/bin/bash

LOG_FILE=core_0_log.txt
echo 'Core 0 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 0 to 900 MHz'
sudo cpufreq-set -c 0 -f 900Mhz
echo 'Running basicmath on Core 0'
taskset -c 0 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 5" | bc -l) )); then
    echo "Task basicmath on Core 0 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 5 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 0 met deadline. Took $TURN_TIME sec, deadline was 5 sec" >> $LOG_FILE
fi
