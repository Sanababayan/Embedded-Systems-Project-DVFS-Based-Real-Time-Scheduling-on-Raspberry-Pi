# Embedded Systems Project: DVFS-Based Real-Time Scheduling on Raspberry Pi

## Overview

This project addresses power management in embedded systems by implementing **Dynamic Voltage and Frequency Scaling (DVFS)** combined with **Earliest Deadline First (EDF)** scheduling on a multi-core Raspberry Pi. The goal is to reduce power consumption without violating real-time constraints, making it suitable for energy-sensitive applications.

By dynamically adjusting CPU frequency based on task deadlines and system workload, the system achieves improved energy efficiency while maintaining real-time performance.

---

## Features

- ⚡ **DVFS Integration**  
  Dynamically scales CPU frequency to reduce power usage under varying workloads.

- ⏱️ **EDF Scheduling**  
  Prioritizes task execution based on the earliest deadlines to meet real-time requirements.

- 🔍 **Power and Performance Profiling**  
  Uses a USB power meter to measure energy consumption during benchmark task execution.

- 🧪 **Benchmark-Driven Evaluation**  
  Utilizes the MiBench suite for realistic task simulation and analysis.

---

## Project Workflow

1. **System Setup**  
   Install and configure Raspberry Pi OS, prepare environment and tools.

2. **Benchmark Execution**  
   Run MiBench workloads to simulate task behavior under various CPU loads.

3. **Frequency Analysis**  
   Identify the frequency range supported per CPU core and configure DVFS settings.

4. **Power Profiling**  
   Measure execution time and power draw across different frequency levels.

5. **Scheduler Development**  
   Implement an EDF-based scheduler that integrates DVFS for optimal energy-performance trade-off.

6. **Simulation and Evaluation**  
   Simulate task sets, collect power/performance metrics, and compare results with and without DVFS.

---

## Tools & Technologies

- 🖥️ **Raspberry Pi 4**  
  Target hardware for implementation and testing.

- 📦 **MiBench**  
  Embedded benchmark suite used for task modeling and workload generation.

- 🔌 **USB Power Meter**  
  For real-time energy consumption measurement.

- 💻 **Bash Scripts**  
  Automate benchmarking, logging, and data collection.

---

## Results

The implementation successfully demonstrated the effectiveness of DVFS combined with EDF scheduling in reducing power consumption. Key outcomes include:

- Significant energy savings across varied task loads.
- High rate of deadline adherence under typical workloads.
- Demonstrated potential for scalable integration in real-time embedded applications.

---

## Future Enhancements

- 🔄 **Slack Time Utilization**  
  Integrate deadline slack into the scheduler to refine energy-performance balance.

- 🧵 **Multithreaded Scheduling**  
  Optimize offline scheduling phases using thread-based parallelism.

---

## Conclusion

This project underscores the critical role of dynamic power management in embedded systems and showcases the feasibility of combining DVFS and EDF scheduling for energy-aware real-time computing. The results support further exploration of adaptive scheduling algorithms in resource-constrained environments.

