#!/bin/bash

echo 'Starting all cores in parallel...'
./core_0.sh &
./core_1.sh &
./core_2.sh &
./core_3.sh &
wait
echo 'All core scripts have started their tasks.'
