# Formal Verification

This directory contains SystemVerilog properties used to formally verify the
interrupt controller.

## Contents

- `isolde_interruptcontroller_behaviour_props.sv` - Behavioral properties for
  interrupt operation.
- `isolde_interruptcontroller_csc_props.sv` - Properties for the controller's
  configuration and status registers.
- `isolde_interruptcontroller_ahb_bridge_props.sv` - Properties for the AHB
  register-interface bridge.

The property modules reference internal controller hierarchy and signals.
Compile them with the RTL in [`../src/`](../src/) in the formal verification
environment used by the project.
