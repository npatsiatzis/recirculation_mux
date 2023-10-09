## Requirements Specification


### 1. SCOPE

1. **Scope**

   This document establishes the requirements for an Intellectual Property (IP) that provides an recirculation MUX function.
1. **Purpose**
 
   These requirements shall apply to a recirculation MUX core with a simple interface for inclusion as a component.
1. **Classification**
    
   This document defines the requirements for a hardware design.


### 2. DEFINITIONS

1. **Pulse**

   In order to synchronize data, a control pulse is generated in source clock domain when data is available at source flop. This pulse is the synchronized using a 2 flip flop synchronizer.

### 3. APPLICABLE DOCUMENTS 

1. **Government Documents**

   None
1. **Non-government Documents**

   None


### 4. ARCHITECTURAL OVERVIEW

1. **Introduction**

   The recirculation MUX component shall represent a design written in an HDL (VHDL and/or SystemVerilog) that can easily be incorporateed into a larger design. The FIFO shall be asynchronous with one clock that governs reads and another for writes. This recirculation MUX shall include the following features : 
     1. Parameterized word width, and synchronization flip flop stages.
     1. recirculation MUX pulse requests.
     1. synchronous active-high reset.

   The CPU interface in this case is the standard FIFO interface.

1. **System Application**
   
    The recirculation MUX can be applied to a variety of system configurations. An example use is to use the core to transfer a data bus between domains operating on different clocks.

### 5. PHYSICAL LAYER

 1. i_data_A, word to transfer to domain B
 6. o_data_B, word received from domain B
 7. wren, FIFO write request
 8. ren, FIFO read request
 9. full, flag indicating FIFO is full
 1. empty, flag indicating FIFO is empty with valid data
 7. clk_A, clock, domain A
 8. rst_A, domain A reset, active high
 7. clk_B, clock, domain B
 8. rst_B, domain B reset, active high

### 6. PROTOCOL LAYER

The recirculation MUX transfers a single word between clock domains.

### 7. ROBUSTNESS

Does not apply.

### 8. HARDWARE AND SOFTWARE

1. **Parameterization**

   The recirculation MUX shall provide for the following parameters used for the definition of the implemented hardware during hardware build:

   | Param. Name | Description |
   | :------: | :------: |
   | width | width of data words |
   | stages | number of synchronization flip flops |

1. **CPU interface**

   The CPU shall request the transfer issuing a control pulse in clock domain A.


### 9. PERFORMANCE

1. **Frequency**
1. **Power Dissipation**
1. **Environmental**
 
   Does not apply.
1. **Technology**

   The design shall be adaptable to any technology because the design shall be portable and defined in an HDL.

### 10. TESTABILITY
None required.

### 11. MECHANICAL
Does not apply.
