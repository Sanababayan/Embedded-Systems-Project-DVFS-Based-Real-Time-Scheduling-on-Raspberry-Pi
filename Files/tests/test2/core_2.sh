#!/bin/bash

LOG_FILE=core_2_log.txt
echo 'Core 2 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 2 to 600 MHz'
sudo cpufreq-set -c 2 -f 600Mhz
echo 'Running dijkstra on Core 2'
taskset -c 2 ./benchmarks/dijkstra/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 0.5" | bc -l) )); then
    echo "Task dijkstra on Core 2 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 0.5 sec" >> $LOG_FILE
else
    echo "Task dijkstra on Core 2 met deadline. Took $TURN_TIME sec, deadline was 0.5 sec" >> $LOG_FILE
fi
echo 'Setting Core 2 to 900 MHz'
sudo cpufreq-set -c 2 -f 900Mhz
echo 'Running qsort on Core 2'
taskset -c 2 ./benchmarks/qsort/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 1.5" | bc -l) )); then
    echo "Task qsort on Core 2 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 1.5 sec" >> $LOG_FILE
else
    echo "Task qsort on Core 2 met deadline. Took $TURN_TIME sec, deadline was 1.5 sec" >> $LOG_FILE
fi
echo 'Setting Core 2 to 600 MHz'
sudo cpufreq-set -c 2 -f 600Mhz
echo 'Running basicmath on Core 2'
taskset -c 2 ./benchmarks/basicmath/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 8.5" | bc -l) )); then
    echo "Task basicmath on Core 2 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 8.5 sec" >> $LOG_FILE
else
    echo "Task basicmath on Core 2 met deadline. Took $TURN_TIME sec, deadline was 8.5 sec" >> $LOG_FILE
fi
echo 'Setting Core 2 to 600 MHz'
sudo cpufreq-set -c 2 -f 600Mhz
echo 'Running qsort on Core 2'
taskset -c 2 ./benchmarks/qsort/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 10.5" | bc -l) )); then
    echo "Task qsort on Core 2 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 10.5 sec" >> $LOG_FILE
else
    echo "Task qsort on Core 2 met deadline. Took $TURN_TIME sec, deadline was 10.5 sec" >> $LOG_FILE
fi
