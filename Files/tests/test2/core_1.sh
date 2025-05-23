#!/bin/bash

LOG_FILE=core_1_log.txt
echo 'Core 1 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 1 to 1200 MHz'
sudo cpufreq-set -c 1 -f 1200Mhz
echo 'Running qsort on Core 1'
taskset -c 1 ./benchmarks/qsort/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 0.8" | bc -l) )); then
    echo "Task qsort on Core 1 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 0.8 sec" >> $LOG_FILE
else
    echo "Task qsort on Core 1 met deadline. Took $TURN_TIME sec, deadline was 0.8 sec" >> $LOG_FILE
fi
echo 'Setting Core 1 to 1200 MHz'
sudo cpufreq-set -c 1 -f 1200Mhz
echo 'Running qsort on Core 1'
taskset -c 1 ./benchmarks/qsort/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 1.5" | bc -l) )); then
    echo "Task qsort on Core 1 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 1.5 sec" >> $LOG_FILE
else
    echo "Task qsort on Core 1 met deadline. Took $TURN_TIME sec, deadline was 1.5 sec" >> $LOG_FILE
fi
echo 'Setting Core 1 to 600 MHz'
sudo cpufreq-set -c 1 -f 600Mhz
echo 'Running dijkstra on Core 1'
taskset -c 1 ./benchmarks/dijkstra/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 2" | bc -l) )); then
    echo "Task dijkstra on Core 1 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 2 sec" >> $LOG_FILE
else
    echo "Task dijkstra on Core 1 met deadline. Took $TURN_TIME sec, deadline was 2 sec" >> $LOG_FILE
fi
echo 'Setting Core 1 to 600 MHz'
sudo cpufreq-set -c 1 -f 600Mhz
echo 'Running basicmath on Core 1'
taskset -c 1 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 9" | bc -l) )); then
    echo "Task basicmath on Core 1 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 9 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 1 met deadline. Took $TURN_TIME sec, deadline was 9 sec" >> $LOG_FILE
fi
