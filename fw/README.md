# Firmware Register Definitions

This directory contains firmware-facing definitions for accessing the
interrupt controller's configuration and status registers.

## Contents

- [`InterruptControllerCSC.h`](InterruptControllerCSC.h) - C header containing
  register addresses and bit-field positions for the controller's
  `InterruptControllerCSC` register block.

Include this header in firmware that configures or reads the controller
through its memory-mapped register interface. The header defines register
offsets relative to a base address, which is currently configured as `0`.

**Attention:** Before using this header, update the base address to match the
address range assigned to the interrupt controller in your SoC.
