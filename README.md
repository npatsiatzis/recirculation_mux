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
[mcy](https://github.com/npatsiatzis/recirculation_mux/tree/main/mcy_sim)


| Folder | Description |
| ------ | ------ |
| [rtl/SystemVerilog](https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/SystemVerilog) | SV RTL implementation files |
| [rtl/VHDL](https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/VHDL) | VHDL RTL implementation files |
| [cocotb_sim](https://github.com/npatsiatzis/recirculation_mux/tree/main/cocotb_sim) | Functional Verification with CoCoTB (Python-based) |
| [pyuvm_sim](https://github.com/npatsiatzis/recirculation_mux/tree/main/pyuvm_sim) | Functional Verification with pyUVM (Python impl. of UVM standard) |
| [uvm_sim](https://github.com/npatsiatzis/recirculation_mux/tree/main/uvm_sim) | Functional Verification with UVM (SV impl. of UVM standard) |
| [verilator_sim](https://github.com/npatsiatzis/recirculation_mux/tree/main/verilator_sim) | Functional Verification with Verilator (C++ based) |
| [mcy_sim](https://github.com/npatsiatzis/recirculation_mux/tree/main/mcy_sim) | Mutation Coverage Testing of Verilator tb, using  [YoysHQ/mcy](https://github.com/YosysHQ/oss-cad-suite-build)|


This is the t<!-- ree view of the strcture of the repo.
<pre>
<font size = "2">
.
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl">rtl</a></b> </font>
│   ├── <font size = "4"><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/SystemVerilog">SystemVerilog</a> </font>
│   │   └── SV files
│   └── <font size = "4"><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/rtl/VHDL">VHDL</a> </font>
│       └── VHD files
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/cocotb_sim">cocotb_sim</a></b></font>
│   ├── Makefile
│   └── python files
├── <font size = "4"><b><a 
 href="https://github.com/npatsiatzis/recirculation_mux/tree/main/pyuvm_sim">pyuvm_sim</a></b></font>
│   ├── Makefile
│   └── python files
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/uvm_sim">uvm_sim</a></b></font>
│   └── .zip file
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/verilator_sim">verilator_sim</a></b></font>
│   ├── Makefile
│   └── verilator tb
└── <font size = "4"><b><a href="https://github.com/npatsiatzis/recirculation_mux/tree/main/mcy_sim">mcy_sim</a></b></font>
    ├── Makefile, (modified) SV files, Verilator tb
    └── scripts
</pre> -->