# RTL Source

This directory contains the SystemVerilog RTL implementation of the
low-latency interrupt controller.

## Top-level module

[`InterruptController.sv`](InterruptController.sv) contains the
`InterruptController` top-level module. It connects the 32 interrupt inputs,
the dedicated NMI input, interrupt completion and acknowledge signals, and the
AHB register interface.

## Implementation blocks

The remaining SystemVerilog files implement the interrupt receiver, priority
resolution, register interface, AHB bridge, and supporting generated logic.
Compile the required source files together as one RTL design; the files share
the `InterruptController` hierarchy.
