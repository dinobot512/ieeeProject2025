This folder contains synthesizable VHDL equivalents for the uploaded Digital (.dig) schematics.

Entities included:
- mux2_1, mux4_1
- demux1_2, demux1_4
- decoder2
- mux4bit2_1, mux4bit4_1
- adder4, adder4_wc
- equals4, negator4
- reg4
- dff1, edge_latch
- shifter4
- counter4_versatile
- alu4_simple (matches 4bitALU.dig's 1-bit OP)
- cpu4bit_unit (best-effort behavioral block matching 4bitCPU.dig top-level ports)

Important:
- The top-level CPU behavior (cpu4bit_unit) is a functional interpretation based on visible ports.
  If you want an exact 1:1 structural translation of 4bitCPU.dig internal wiring, we need to
  map Digital's geometric wire/pin placement precisely (or export a netlist). Upload any docs
  about the intended OP encoding and expected outputs, and I can lock it down.
