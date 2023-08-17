![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/coverage.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/recirculation_mux/actions/workflows/coverage_pyuvm.yml/badge.svg)

### Recirculation MUX RTL implementation

- solution for data bus synchronization
- uses a toggle pulse synchronizer to transmit a pulse across clock domains
- pulses controls the sampling of the data bus on the receiving (sink) domain

-- RTL code in:
- [VHDL](https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/VHDL)

-- Functional verification with methodologies:
- [cocotb](https://github.com/npatsiatzis/recirculation_mux/tree/main/cocotb_sim)
- [pyuvm](https://github.com/npatsiatzis/recirculation_mux/tree/main/pyuvm_sim)

