#!/bin/bash

LOG_FILE=core_0_log.txt
echo 'Core 0 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 0 to 700 MHz'
sudo cpufreq-set -c 0 -f 700Mhz
echo 'Running basicmath on Core 0'
taskset -c 0 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 7" | bc -l) )); then
    echo "Task basicmath on Core 0 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 7 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 0 met deadline. Took $TURN_TIME sec, deadline was 7 sec" >> $LOG_FILE
fi
echo 'Setting Core 0 to 600 MHz'
sudo cpufreq-set -c 0 -f 600Mhz
echo 'Running dijkstra on Core 0'
taskset -c 0 ./benchmarks/dijkstra/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 8" | bc -l) )); then
    echo "Task dijkstra on Core 0 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 8 sec" >> $LOG_FILE
else
    echo "Task dijkstra on Core 0 met deadline. Took $TURN_TIME sec, deadline was 8 sec" >> $LOG_FILE
fi
echo 'Setting Core 0 to 600 MHz'
sudo cpufreq-set -c 0 -f 600Mhz
echo 'Running basicmath on Core 0'
taskset -c 0 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 15" | bc -l) )); then
    echo "Task basicmath on Core 0 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 15 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 0 met deadline. Took $TURN_TIME sec, deadline was 15 sec" >> $LOG_FILE
fi
