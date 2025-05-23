#!/bin/bash

LOG_FILE=core_1_log.txt
echo 'Core 1 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 1 to 600 MHz'
sudo cpufreq-set -c 1 -f 600Mhz
echo 'Running basicmath on Core 1'
taskset -c 1 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 10" | bc -l) )); then
    echo "Task basicmath on Core 1 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 10 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 1 met deadline. Took $TURN_TIME sec, deadline was 10 sec" >> $LOG_FILE
fi
echo 'Setting Core 1 to 600 MHz'
sudo cpufreq-set -c 1 -f 600Mhz
echo 'Running jpeg on Core 1'
taskset -c 1 ./benchmarks/jpeg/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 12" | bc -l) )); then
    echo "Task jpeg on Core 1 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 12 sec" >> $LOG_FILE
else
    echo "Task jpeg on Core 1 met deadline. Took $TURN_TIME sec, deadline was 12 sec" >> $LOG_FILE
fi
