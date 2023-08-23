### Recirculation MUX RTL implementation

- solution for data bus synchronization
- uses a toggle pulse synchronizer to transmit a pulse across clock domains
- pulses controls the sampling of the data bus on the receiving (sink) domain

- Link to the playground : https://www.edaplayground.com/x/Bxz6
- Make sure that "Use run.do Tcl file" and "Download files after run" options remain checked 
- results.zip is downloaded at the end of the execution
    - contains all the SV/UVM tb files, coverage information etc...
    