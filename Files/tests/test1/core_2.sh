#!/bin/bash

LOG_FILE=core_2_log.txt
echo 'Core 2 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 2 to 600 MHz'
sudo cpufreq-set -c 2 -f 600Mhz
echo 'Running basicmath on Core 2'
taskset -c 2 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 10" | bc -l) )); then
    echo "Task basicmath on Core 2 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 10 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 2 met deadline. Took $TURN_TIME sec, deadline was 10 sec" >> $LOG_FILE
fi
echo 'Setting Core 2 to 600 MHz'
sudo cpufreq-set -c 2 -f 600Mhz
echo 'Running jpeg on Core 2'
taskset -c 2 ./benchmarks/jpeg/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 23" | bc -l) )); then
    echo "Task jpeg on Core 2 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 23 sec" >> $LOG_FILE
else
    echo "Task jpeg on Core 2 met deadline. Took $TURN_TIME sec, deadline was 23 sec" >> $LOG_FILE
fi
