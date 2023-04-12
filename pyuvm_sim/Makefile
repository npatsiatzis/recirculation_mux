# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl
EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

VHDL_SOURCES += $(PWD)/../rtl/toggle_synchronizer.vhd
VHDL_SOURCES += $(PWD)/../rtl/recirculation_mux.vhd
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file

test:
		rm -rf sim_build
		$(MAKE) sim MODULE=tb TOPLEVEL=recirculation_mux

toggle:
		$(MAKE) sim MODULE=tb_toggle TOPLEVEL=toggle_synchronizer		

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim