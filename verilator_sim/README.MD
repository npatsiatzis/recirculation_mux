### Recirculation MUX RTL implementation

- solution for data bus synchronization
- uses a toggle pulse synchronizer to transmit a pulse across clock domains
- pulses controls the sampling of the data bus on the receiving (sink) domain

-- Verilator tb for functional verification, adapted from the work of Norbet Kremeris (https://www.itsembedded.com/dhd/verilator_4/). Added coverage class for the input and output interfaces,sequence class, coverage-based end-of-test condition and coverage-driven test generation
-- Verilator support for multiple clock domains adopted from https://josuah.net/blog/2022-05-18/.

- run sim
    - $ make sim
- Achieve full point coverage for output
- open waveform with gtkwave
    - $ make waves
- lint test
    - $make lint
