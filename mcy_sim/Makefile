TOPLEVEL = mutated
MODULE = tb_mutated.cpp
RTL_DIR = $(PWD)

.PHONY:sim
sim: waveform.vcd

.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: obj_dir/Valu

.PHONY:waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd 

waveform.vcd: ./obj_dir/V$(TOPLEVEL)
	@echo
	@echo "### SIMULATING ###"
	./obj_dir/V$(TOPLEVEL) +verilator+rand+reset+2 

./obj_dir/V$(TOPLEVEL): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(TOPLEVEL).mk V$(TOPLEVEL)

.stamp.verilate: $(RTL_DIR)/$(TOPLEVEL).v $(MODULE)
	@echo
	@echo "### VERILATING ###"
	verilator -DUSE_VERILATOR --assert -Wno-fatal --build -j --coverage --trace --trace-coverage -Wall --trace --x-assign unique --x-initial unique -I$(RTL_DIR) -cc $(RTL_DIR)/$(TOPLEVEL).v --exe $(MODULE)
	@touch .stamp.verilate

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd
	rm -rf annotated
	rm -rf html
	rm -rf coverage.dat
