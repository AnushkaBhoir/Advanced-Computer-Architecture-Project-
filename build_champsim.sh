#!/bin/bash

if [ "$#" -gt 2 ]; then
    echo "Illegal number of parameters"
    echo "Usage: ./build_champsim.sh [branch_pred] [l1i_pref] [l1d_pref]
    [l2c_pref] [llc_pref] [itlb_pref] [dtlb_pref] [stlb_pref] [btb_repl]
    [l1i_repl] [l1d_repl] [l2c_repl] [llc_repl] [itlb_repl] [dtlb_repl]
    [stlb_repl] [num_core] [tail_name]"
    exit 1
fi

# ChampSim configuration
BRANCH=bimodal           # branch/*.bpred
L1I_PREFETCHER=no   # prefetcher/*.l1i_pref
L1D_PREFETCHER=no  # prefetcher/*.l1d_pref
L1D_PREFETCHER=no   # prefetcher/*.l1d_pref
L2C_PREFETCHER=no   # prefetcher/*.l2c_pref
LLC_PREFETCHER=no   # prefetcher/*.llc_pref
ITLB_PREFETCHER=no  # prefetcher/*.itlb_pref
DTLB_PREFETCHER=no  # prefetcher/*.dtlb_pref
STLB_PREFETCHER=no # prefetcher/*.stlb_pref

BTB_REPLACEMENT=lru   # prefetcher/*.btb_repl	
L1I_REPLACEMENT=lru   # prefetcher/*.l1i_repl
L1D_REPLACEMENT=lru   # prefetcher/*.l1d_repl
L2C_REPLACEMENT=lru   # prefetcher/*.l2c_repl
LLC_REPLACEMENT=lru   # prefetcher/*.llc_repl
ITLB_REPLACEMENT=lru  # prefetcher/*.itlb_repl
DTLB_REPLACEMENT=lru  # prefetcher/*.dtlb_repl
STLB_REPLACEMENT=lru  # prefetcher/*.stlb_repl
IGNITE=${1}
NUM_TRACES=${2}
NUM_CORE=1         # tested up to 8-core system

############## Some useful macros ###############
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
#################################################

# Sanity check
if [ ! -f ./branch/${BRANCH}.bpred ]; then
    echo "[ERROR] Cannot find branch predictor"
	echo "[ERROR] Possible branch predictors from branch/*.bpred "
    find branch -name "*.bpred"
    exit 1
fi

if [ ! -f ./prefetcher/${L1I_PREFETCHER}.l1i_pref ]; then
	echo "[ERROR] Cannot find L1I prefetcher"
	echo "[ERROR] Possible L1I prefetchers from prefetcher/*.l1i_pref "
	find prefetcher -name "*.l1i_pref"
	exit 1
fi


if [ ! -f ./prefetcher/${L1D_PREFETCHER}.l1d_pref ]; then
    echo "[ERROR] Cannot find L1D prefetcher"
	echo "[ERROR] Possible L1D prefetchers from prefetcher/*.l1d_pref "
    find prefetcher -name "*.l1d_pref"
    exit 1
fi

if [ ! -f ./prefetcher/${L2C_PREFETCHER}.l2c_pref ]; then
    echo "[ERROR] Cannot find L2C prefetcher"
	echo "[ERROR] Possible L2C prefetchers from prefetcher/*.l2c_pref "
    find prefetcher -name "*.l2c_pref"
    exit 1
fi

if [ ! -f ./prefetcher/${LLC_PREFETCHER}.llc_pref ]; then
    echo "[ERROR] Cannot find LLC prefetcher"
	echo "[ERROR] Possible LLC prefetchers from prefetcher/*.llc_pref "
    find prefetcher -name "*.llc_pref"
    exit 1
fi

if [ ! -f ./prefetcher/${ITLB_PREFETCHER}.itlb_pref ]; then
    echo "[ERROR] Cannot find ITLB prefetcher"
	echo "[ERROR] Possible ITLB prefetchers from prefetcher/*.itlb_pref "
    find prefetcher -name "*.itlb_pref"
    exit 1
fi

if [ ! -f ./prefetcher/${DTLB_PREFETCHER}.dtlb_pref ]; then
    echo "[ERROR] Cannot find DTLB prefetcher"
        echo "[ERROR] Possible DTLB prefetchers from prefetcher/*.dtlb_pref "
    find prefetcher -name "*.dtlb_pref"
    exit 1
fi

if [ ! -f ./prefetcher/${STLB_PREFETCHER}.stlb_pref ]; then
    echo "[ERROR] Cannot find STLB prefetcher"
        echo "[ERROR] Possible STLB prefetchers from prefetcher/*.stlb_pref "
    find prefetcher -name "*.stlb_pref"
    exit 1
fi

if [ ! -f ./replacement/${BTB_REPLACEMENT}.btb_repl ]; then
    echo "[ERROR] Cannot find BTB replacement policy"
        echo "[ERROR] Possible BTB replacement policy from replacement/*.btb_repl"
    find replacement -name "*.btb_repl"
    exit 1
fi

if [ ! -f ./replacement/${L1I_REPLACEMENT}.l1i_repl ]; then
    echo "[ERROR] Cannot find L1I replacement policy"
	echo "[ERROR] Possible L1I replacement policy from replacement/*.l1i_repl"
    find replacement -name "*.l1i_repl"
    exit 1
fi

if [ ! -f ./replacement/${L1D_REPLACEMENT}.l1d_repl ]; then
    echo "[ERROR] Cannot find L1D replacement policy"
        echo "[ERROR] Possible L1D replacement policy from replacement/*.l1d_repl"
    find replacement -name "*.l1d_repl"
    exit 1
fi

if [ ! -f ./replacement/${L2C_REPLACEMENT}.l2c_repl ]; then
    echo "[ERROR] Cannot find L2C replacement policy"
	echo "[ERROR] Possible L2C replacement policy from replacement/*.l2c_repl"
    find replacement -name "*.l2c_repl"
    exit 1
fi

if [ ! -f ./replacement/${LLC_REPLACEMENT}.llc_repl ]; then
    echo "[ERROR] Cannot find LLC replacement policy"
        echo "[ERROR] Possible LLC replacement policy from replacement/*.llc_repl"
    find replacement -name "*.llc_repl"
    exit 1
fi

if [ ! -f ./replacement/${ITLB_REPLACEMENT}.itlb_repl ]; then
    echo "[ERROR] Cannot find ITLB replacement policy"
	echo "[ERROR] Possible ITLB replacement policy from replacement/*.itlb_repl"
    find replacement -name "*.itlb_repl"
    exit 1
fi

if [ ! -f ./replacement/${DTLB_REPLACEMENT}.dtlb_repl ]; then
    echo "[ERROR] Cannot find DTLB replacement policy"
        echo "[ERROR] Possible DTLB replacement policy from replacement/*.dtlb_repl"
    find replacement -name "*.dtlb_repl"
    exit 1
fi

if [ ! -f ./replacement/${STLB_REPLACEMENT}.stlb_repl ]; then
    echo "[ERROR] Cannot find STLB replacement policy"
	echo "[ERROR] Possible STLB replacement policy from replacement/*.stlb_repl"
    find replacement -name "*.stlb_repl"
    exit 1
fi



# Check num_core
re='^[0-9]+$'
if ! [[ $NUM_CORE =~ $re ]] ; then
    echo "[ERROR]: num_core is NOT a number" >&2;
    exit 1
fi

# Check for multi-core
if [ "$NUM_CORE" -gt "1" ]; then
    echo "Building multi-core ChampSim..."
    sed -i.bak 's/\<NUM_CPUS 1\>/NUM_CPUS '${NUM_CORE}'/g' inc/champsim.h
#	sed -i.bak 's/\<DRAM_CHANNELS 1\>/DRAM_CHANNELS 2/g' inc/champsim.h
#	sed -i.bak 's/\<DRAM_CHANNELS_LOG2 0\>/DRAM_CHANNELS_LOG2 1/g' inc/champsim.h
else
    if [ "$NUM_CORE" -lt "1" ]; then
        echo "Number of core: $NUM_CORE must be greater or equal than 1"
        exit 1
    else
        echo "Building single-core ChampSim..."
    fi
fi

#anushka and mugdha
if [ "$NUM_TRACES" -gt "1" ]; then
    echo "Building multi-traces on single system environment..."
    sed -i.bak 's/\<NUM_TRACES 1\>/NUM_TRACES '${NUM_TRACES}'/g' inc/champsim.h
#	sed -i.bak 's/\<DRAM_CHANNELS 1\>/DRAM_CHANNELS 2/g' inc/champsim.h
#	sed -i.bak 's/\<DRAM_CHANNELS_LOG2 0\>/DRAM_CHANNELS_LOG2 1/g' inc/champsim.h
else
    if [ "$NUM_CORE" -lt "1" ]; then
        echo "Number of core: $NUM_CORE must be greater or equal than 1"
        exit 1
    else
        echo "Building single-core ChampSim..."
    fi
fi

# Check if IGNITE is set to yes
if [ "$IGNITE" = "yes" ]; then
    echo "Enabling IGNITE..."
    sed -i.bak 's/\<IGNITE 0\>/IGNITE 1/g' inc/champsim.h
else
    echo "IGNITE is not enabled. Keeping IGNITE as 0."
fi

echo


# add code, if $ignite = yes, sed -i.bak 's/\<IGNITE 0\>/IGNITE '${IGNITE}'/g' inc/champsim.h
# else no change
#reset the value back to 0 in the start
# Change prefetchers and replacement policy 
cp branch/${BRANCH}.bpred branch/branch_predictor.cc
cp prefetcher/${L1I_PREFETCHER}.l1i_pref prefetcher/l1i_prefetcher.cc
cp prefetcher/${L1D_PREFETCHER}.l1d_pref prefetcher/l1d_prefetcher.cc
cp prefetcher/${L2C_PREFETCHER}.l2c_pref prefetcher/l2c_prefetcher.cc
cp prefetcher/${LLC_PREFETCHER}.llc_pref prefetcher/llc_prefetcher.cc
cp prefetcher/${ITLB_PREFETCHER}.itlb_pref prefetcher/itlb_prefetcher.cc
cp prefetcher/${DTLB_PREFETCHER}.dtlb_pref prefetcher/dtlb_prefetcher.cc
cp prefetcher/${STLB_PREFETCHER}.stlb_pref prefetcher/stlb_prefetcher.cc
cp replacement/${BTB_REPLACEMENT}.btb_repl replacement/btb_replacement.cc
cp replacement/${L1I_REPLACEMENT}.l1i_repl replacement/l1i_replacement.cc
cp replacement/${L1D_REPLACEMENT}.l1d_repl replacement/l1d_replacement.cc
cp replacement/${L2C_REPLACEMENT}.l2c_repl replacement/l2c_replacement.cc
cp replacement/${LLC_REPLACEMENT}.llc_repl replacement/llc_replacement.cc
cp replacement/${ITLB_REPLACEMENT}.itlb_repl replacement/itlb_replacement.cc
cp replacement/${DTLB_REPLACEMENT}.dtlb_repl replacement/dtlb_replacement.cc
cp replacement/${STLB_REPLACEMENT}.stlb_repl replacement/stlb_replacement.cc



# Build
mkdir -p bin
rm -f bin/champsim
make clean
if [ "$#" -eq 19 ]; then
    make CC=${19} CCX=${19}
else
    make
fi

# Sanity check
echo ""
if [ ! -f bin/champsim ]; then
    echo "${BOLD}ChampSim build FAILED!"
    echo ""
    exit 1
fi

echo "${BOLD}ChampSim is successfully built"
echo "Branch Predictor: ${BRANCH}"
echo "L1I Prefetcher: ${L1I_PREFETCHER}"
echo "L1D Prefetcher: ${L1D_PREFETCHER}"
echo "L2C Prefetcher: ${L2C_PREFETCHER}"
echo "LLC Prefetcher: ${LLC_PREFETCHER}"
echo "ITLB Prefetcher: ${ITLB_PREFETCHER}"
echo "DTLB Prefetcher: ${DTLB_PREFETCHER}"
echo "STLB Prefetcher: ${STLB_PREFETCHER}"
echo "BTB Replacement: ${BTB_REPLACEMENT}"
echo "L1I Replacement: ${L1I_REPLACEMENT}"
echo "L1D Replacement: ${L1D_REPLACEMENT}"
echo "L2C Replacement: ${L2C_REPLACEMENT}"
echo "LLC Replacement: ${LLC_REPLACEMENT}"
echo "ITLB Replacement: ${ITLB_REPLACEMENT}"
echo "DTLB Replacement: ${DTLB_REPLACEMENT}"
echo "STLB Replacement: ${STLB_REPLACEMENT}"

echo "Cores: ${NUM_CORE}"
BINARY_NAME="${IGNITE}-${NUM_TRACES}traces"
echo "Binary: bin/${BINARY_NAME}"
echo ""
mv bin/champsim bin/${BINARY_NAME}


sed -i.bak 's/\<NUM_CPUS [0-9]\+/NUM_CPUS 1/g' inc/champsim.h
sed -i.bak 's/\<NUM_TRACES [0-9]\+/NUM_TRACES 1/g' inc/champsim.h
sed -i.bak 's/\<IGNITE [0-9]\+/IGNITE 0/g' inc/champsim.h
#sed -i.bak 's/\<DRAM_CHANNELS 2\>/DRAM_CHANNELS 1/g' inc/champsim.h
#sed -i.bak 's/\<DRAM_CHANNELS_LOG2 1\>/DRAM_CHANNELS_LOG2 0/g' inc/champsim.h

cp branch/bimodal.bpred branch/branch_predictor.cc
cp prefetcher/no.l1i_pref prefetcher/l1i_prefetcher.cc
cp prefetcher/no.l1d_pref prefetcher/l1d_prefetcher.cc
cp prefetcher/no.l2c_pref prefetcher/l2c_prefetcher.cc
cp prefetcher/no.llc_pref prefetcher/llc_prefetcher.cc
cp prefetcher/no.itlb_pref prefetcher/itlb_prefetcher.cc
cp prefetcher/no.dtlb_pref prefetcher/dtlb_prefetcher.cc
cp prefetcher/no.stlb_pref prefetcher/stlb_prefetcher.cc
cp replacement/lru.btb_repl replacement/btb_replacement.cc
cp replacement/lru.l1d_repl replacement/l1d_replacement.cc
cp replacement/lru.l1i_repl replacement/l1i_replacement.cc
cp replacement/lru.l2c_repl replacement/l2c_replacement.cc
cp replacement/lru.llc_repl replacement/llc_replacement.cc
cp replacement/lru.itlb_repl replacement/itlb_replacement.cc
cp replacement/lru.dtlb_repl replacement/dtlb_replacement.cc
cp replacement/lru.stlb_repl replacement/stlb_replacement.cc
