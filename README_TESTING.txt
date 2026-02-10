How to test this 4-bit CPU project

Top level:
  - FourBitCPU.vhd (matches the top schematic 4bitCPU.dig ports)

Testbench:
  - tb_FourBitCPU.vhd

Default OP mapping used in this VHDL build (changeable in cpu4bit_unit.vhd):
  OP="00" -> ADD (O=A+B)
  OP="01" -> SUB (O=A-B)
  OP="10" -> MUL (shift-add, 4 cycles)  O=product[3:0]
  OP="11" -> DIV (restoring, 4 cycles)  O=quotient

To simulate (ModelSim/Questa example):
  vlib work
  vcom *.vhd
  vsim tb_FourBitCPU
  run -all

To synthesize (Quartus):
  - Create a new project
  - Add all .vhd files in this folder
  - Set top-level entity to: FourBitCPU
