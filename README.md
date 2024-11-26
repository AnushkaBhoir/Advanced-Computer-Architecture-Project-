
## Tested Environment & Dependencies

- Ubuntu 18.04.6 LTS and above
- Linux Kernel 5.4.0 and above
- GCC 7.5.0

# Run simulation

In order to keep the execution commands small and make the simulator easy to run, we only need to enter 2 command line arguments while building champsim.

# Compile

$ ./build_champsim.sh [IGNITE] [NUM_TRACES]

Here, [IGNITE] variable can be either yes or no. If yes, champsim is simulated with ignite environment, else it is simulated without ignite environment. Thereby distinguishing between our implementation and baseline.

[NUM_TRACES] is the number of trace files you want to run on your core.

Example:
```
./build_champsim.sh yes 2
```
**Single-core simulation**
```
./[BINARY] -warmup_instructions [N_WARM] -simulation_instructions [N_SIM] [TRACE_DIR]/[TRACE]
$ ./yes-2traces -warmup_instructions 25000000 -simulation_instructions 25000000 -traces ../traces/trace1.champsimtrace.xz ../traces/trace2.champsimtrace.xz

${BINARY}: ChampSim binary compiled by "build_champsim.sh" (ip_stride-asp-1core)
${N_WARM}: number of instructions for warmup (25 million)
${N_SIM}:  number of instructinos for detailed simulation (25 million) * NUM_TRACES
${TRACE_DIR}: directory where the trace is located (../traces/)
${TRACE}: trace name (trace1.champsimtrace.xz)
Here add [NUM_TRACES] trace files, as specified while building.
```
Our environment executes a trace file for 5 million instructions before switching to another trace file. During the switch, the BTB (Branch Target Buffer) and branch predictor are flushed. This process continues until all simulation instructions have been executed. This behavior simulates a high-level environment similar to what is created in servers while handling serverless functions.
# Evaluate Simulations

ChampSim measures the IPC (Instruction Per Cycle) value as a performance metric. <br>
There are some other useful metrics printed out at the end of simulation. <be>


## Steps to download gcc version 7 in ubuntu:
1. sudo apt update
2. sudo add-apt-repository ppa:ubuntu-toolchain-r/test
3. vim /etc/apt/sources.list
4. sudo nano /etc/apt/sources.list
5. Update the last line with deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal main universe
6. sudo add-apt-repository ppa:ubuntu-toolchain-r/test
7. sudo apt-get install gcc-7
8. sudo apt-get install g++-7
9. sudo update-alternatives -install /usr/bin/g++ g++ /usr/bin/g++-7 0
10. sudo update-alternatives -install /us/bin/gcc gcc /ust/bin/gcc-7 0
    
--In case the GCC and G++ is already present in /usr/bin (run ./gcc-7 -v in /usr/bin), install the alternative and set it using

1. sudo update-alternatives --config g++
2. sudo update-alternatives --config gcc
