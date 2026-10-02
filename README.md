# RISC-V Interrupt Controller

This repository contains a low-latency interrupt controller primarily designed
to work with RISC-V cores.

## Features of the Programable Interrupt Controoler

- 32 interrupt input lines (`int_0` through `int_31`)
- One dedicated non-maskable interrupt (NMI) line
- Nested interrupt support up to level 4
- Direct Vectorized Address Resolution for Interrupt Servise Routine (ISR)
- Run time configurability for enable/unmask/priority/address 

## Directory structure

- [`doc/`](doc/) - Documentation covering the interrupt controller architecture
  and usage.
- [`fv/`](fv/) - Properties used to formally verify the interrupt controller.
- [`src/`](src/) - SystemVerilog RTL source files.
- [`fw/`](fw/) - Firmware-facing C definitions for the controller's
  configuration and status registers.

The top-level RTL module is [`src/InterruptController`](src/InterruptController.sv).
The controller exposes an AHB register interface for configuration and status
access.

## Interrupt grouping

The interrupt lines are organized into four groups for priority resolution.
The group assignments are documented in
[`doc/interrupts_by_group.txt`](doc/interrupts_by_group.txt).

## Usage

Refer to the documentation in [`doc/`](doc/) for architecture and integration
details. Include the RTL files in [`src/`](src/) in the hardware design, and
use the definitions in [`fw/InterruptControllerCSC.h`](fw/InterruptControllerCSC.h)
when accessing the controller registers from firmware.

## Verification

The formal properties in [`fv/`](fv/) cover controller behavior, the register
interface, and the AHB bridge. Integrate these properties with the applicable
formal verification environment.
