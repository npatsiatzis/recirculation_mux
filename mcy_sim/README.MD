### Recirculation MUX RTL implementation

- solution for data bus synchronization
- uses a toggle pulse synchronizer to transmit a pulse across clock domains
- pulses controls the sampling of the data bus on the receiving (sink) domain


-- MCY is a tool to help understand and improve TESTBENCH coverage.
-- Mutation coverage further enhances the confidence instilled in our test from line,toggle,functional coverage.
-- Mutation coverage is applied here on the verilator tb, but can be tailored to any functional testing methodology.
-- MCY works with (System)Verilog RTL files. Hence you either need to have your source RTL in that language or use Yosys GHDL pluggin to convert VHDL source to Verilog. In such case run :

- $ bash gen_verilog.sh 

-- When you have obtained your RTL files then : 
- $ mcy purge
- $ mcy init
- $ mcy run (-j$nPROCS)

