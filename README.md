![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/coverage.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/coverage_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/verilator_regression.yml/badge.svg)
[![codecov](https://codecov.io/gh/npatsiatzis/recirculation_mux/graph/badge.svg?token=HWZU4XSEKD)](https://codecov.io/gh/npatsiatzis/recirculation_mux)
### Recirculation MUX RTL implementation

- solution for data bus synchronization
- uses a toggle pulse synchronizer to transmit a pulse across clock domains
- pulses controls the sampling of the data bus on the receiving (sink) domain

-- RTL code in:
- [VHDL](https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/VHDL)
- [SystemVerilog](https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/SystemVerilog)

-- Functional verification with methodologies:
- [cocotb](https://github.com/npatsiatzis/recirculation_mux/tree/main/cocotb_sim)
- [pyuvm](https://github.com/npatsiatzis/recirculation_mux/tree/main/pyuvm_sim)
- [uvm](https://github.com/npatsiatzis/recirculation_mux/tree/main/uvm_sim)
- [verilator](https://github.com/npatsiatzis/recirculation_mux/tree/main/verilator_sim)

