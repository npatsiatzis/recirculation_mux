#!/bin/bash

exec 2>&1
set -ex

# TESTDIR=$PWD
## create the mutated design
bash $SCRIPTS/create_mutated.sh
ln ../../Makefile .
ln ../../tb_mutated.cpp

## run the testbench with the mutated module substituted for the original
# cd $MCYDIR/../verilator_sim
# cd ../verilator_sim
# cd ../..
make clean
make > sim.out 2>&1 || true

# cd ../mcy_sim
# cd $TESTDIR
if grep -q "Test Failure" sim.out; then
	echo "1 FAIL" > output.txt
else
	echo "1 PASS" > output.txt
fi

exit 0
