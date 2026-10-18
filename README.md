# BCD Arithmetic Unit with Excess-3 Code Conversion

CES 2112 Digital Systems Lab — Open-Ended Experiment, MIT Manipal (CSE – I, Batch 2).

A combinational single-digit BCD adder/subtractor in Verilog. It applies the +0110 decimal correction, gives negative differences in sign-magnitude form, converts both result digits to Excess-3, and forces all outputs to 0 for invalid (non-BCD) inputs.

## Contents

| Path | Description |
|---|---|
| `DISL_OEP_Report_BCD_Excess3.docx` / `.pdf` | Final report |
| `verilog/` | Design modules, self-checking testbench, simulation log and VCD waveform |
| `figures/` | Block diagram and simulation waveform used in the report |
| `Open_Ended_Project_Abstract_Template (1).docx` | Submitted abstract |
| `Report_Word_Template (1).docx` | Course report template |

## Module hierarchy

`bcd_alu_xs3` (top) → `bcd_addsub` → `rca4` → `full_adder`, plus `bcd_to_xs3` (×2)

## Run the simulation

```sh
cd verilog
iverilog -g2005 -Wall -o sim.out full_adder.v rca4.v bcd_addsub.v bcd_to_xs3.v bcd_alu_xs3.v tb_bcd_alu_xs3.v
vvp sim.out
```

Expected result: `Exhaustive result: 512 passed, 0 failed (200 valid, 312 invalid)`.

## Team

Riya Agrawal · Apurva Nayak · Shreya Nirgide · Aryan Achary — guided by Dr Anoop B N.
