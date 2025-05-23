#!/bin/bash

LOG_FILE=core_3_log.txt
echo 'Core 3 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 3 to 600 MHz'
sudo cpufreq-set -c 3 -f 600Mhz
echo 'Running jpeg on Core 3'
taskset -c 3 ./benchmarks/jpeg/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 17" | bc -l) )); then
    echo "Task jpeg on Core 3 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 17 sec" >> $LOG_FILE
else
    echo "Task jpeg on Core 3 met deadline. Took $TURN_TIME sec, deadline was 17 sec" >> $LOG_FILE
fi
