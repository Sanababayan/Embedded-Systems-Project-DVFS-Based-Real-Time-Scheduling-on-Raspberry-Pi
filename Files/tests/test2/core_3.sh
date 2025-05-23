#!/bin/bash

LOG_FILE=core_3_log.txt
echo 'Core 3 Execution Log' > $LOG_FILE
FIRST_TIME=$(date +%s.%N)
echo 'Setting Core 3 to 600 MHz'
sudo cpufreq-set -c 3 -f 600Mhz
echo 'Running bitcount on Core 3'
taskset -c 3 ./benchmarks/bitcount/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 0.6" | bc -l) )); then
    echo "Task bitcount on Core 3 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 0.6 sec" >> $LOG_FILE
else
    echo "Task bitcount on Core 3 met deadline. Took $TURN_TIME sec, deadline was 0.6 sec" >> $LOG_FILE
fi
echo 'Setting Core 3 to 800 MHz'
sudo cpufreq-set -c 3 -f 800Mhz
echo 'Running bitcount on Core 3'
taskset -c 3 ./benchmarks/bitcount/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 1.5" | bc -l) )); then
    echo "Task bitcount on Core 3 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 1.5 sec" >> $LOG_FILE
else
    echo "Task bitcount on Core 3 met deadline. Took $TURN_TIME sec, deadline was 1.5 sec" >> $LOG_FILE
fi
echo 'Setting Core 3 to 600 MHz'
sudo cpufreq-set -c 3 -f 600Mhz
echo 'Running qsort on Core 3'
taskset -c 3 ./benchmarks/qsort/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 2.5" | bc -l) )); then
    echo "Task qsort on Core 3 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 2.5 sec" >> $LOG_FILE
else
    echo "Task qsort on Core 3 met deadline. Took $TURN_TIME sec, deadline was 2.5 sec" >> $LOG_FILE
fi
echo 'Setting Core 3 to 600 MHz'
sudo cpufreq-set -c 3 -f 600Mhz
echo 'Running dijkstra on Core 3'
taskset -c 3 ./benchmarks/dijkstra/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 3" | bc -l) )); then
    echo "Task dijkstra on Core 3 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 3 sec" >> $LOG_FILE
else
    echo "Task dijkstra on Core 3 met deadline. Took $TURN_TIME sec, deadline was 3 sec" >> $LOG_FILE
fi
echo 'Setting Core 3 to 600 MHz'
sudo cpufreq-set -c 3 -f 600Mhz
echo 'Running qsort on Core 3'
taskset -c 3 ./benchmarks/qsort/runme_large.sh
END_TIME=$(date +%s.%N)
TURN_TIME=$(echo "$END_TIME - $FIRST_TIME" | bc)
if (( $(echo "$TURN_TIME > 3.5" | bc -l) )); then
    echo "Task qsort on Core 3 MISSED DEADLINE! Took $TURN_TIME sec, deadline was 3.5 sec" >> $LOG_FILE
else
    echo "Task qsort on Core 3 met deadline. Took $TURN_TIME sec, deadline was 3.5 sec" >> $LOG_FILE
fi
