# Pipelined ALU in Verilog

##  Overview

This project implements a **4-stage pipelined Arithmetic Logic Unit (ALU)** using Verilog. The design performs multiple arithmetic and logical operations using a register bank and demonstrates how pipelining improves system performance by increasing throughput.

---

##  How the ALU Works

The ALU takes inputs from a **register bank**, performs operations based on a control signal (`func`), and produces the result through a pipeline.

### 🔹 Inputs

* `rs1`, `rs2` → Source register indices
* `rd` → Destination register index
* `func` → Operation selector
* `addr` → Memory address
* `clk` → Clock signal

### 🔹 Output

* `zout` → Final ALU result

---

##  Pipeline Architecture

The design is divided into **4 pipeline stages**, each separated by registers:

###  Stage 1: Register Read (Fetch Stage)

* Reads operands from the register bank
* Stores inputs into pipeline registers (`L12_*`)

---

###  Stage 2: Execute Stage

* Performs ALU operations based on `func`
* Operations include:

  * Addition, Subtraction, Multiplication, Division
  * Bitwise AND, OR, XOR
  * NOT operations
  * Shift operations

---

###  Stage 3: Write Back Stage

* Writes the computed result back into the register bank
* Passes result to next pipeline stage

---

###  Stage 4: Memory Stage

* Writes the result into memory (if required)

---
##  Supported Operations

| Func Code | Operation     |
| --------- | ------------- |
| 0         | ADD           |
| 1         | SUB           |
| 2         | MUL           |
| 3         | DIV           |
| 4         | AND           |
| 5         | OR            |
| 6         | XOR           |
| 7         | NOT A         |
| 8         | NOT B         |
| 9         | Shift Left A  |
| 10        | Shift Left B  |
| 11        | Shift Right B |
| 12        | Shift Right A |

---

##  Why Pipelining is Better

### Without Pipelining

* Each instruction completes **one after another**
* Total time = Sum of all instruction delays
* Low throughput

---

###  With Pipelining

* Multiple instructions are processed **simultaneously in different stages**
* After pipeline is filled:

  * One result is produced **every clock cycle**

---

###  Example

| Clock Cycle | Stage 1 | Stage 2 | Stage 3 | Stage 4 |
| ----------- | ------- | ------- | ------- | ------- |
| 1           | Instr1  | —       | —       | —       |
| 2           | Instr2  | Instr1  | —       | —       |
| 3           | Instr3  | Instr2  | Instr1  | —       |
| 4           | Instr4  | Instr3  | Instr2  | Instr1  |

 This overlap increases **throughput significantly**

---

##  Key Advantage

* **Higher Throughput**: More operations per unit time
* **Better Resource Utilization**
* **Faster overall computation for multiple instructions**

---

##  Limitation

* The design does not handle **data hazards (RAW hazards)**
* Dependent instructions may produce incorrect results
* No forwarding or stalling logic implemented

---

##  Testbench

* Initializes register bank (`reg_bank[i] = i`)
* Applies multiple test cases
* Verifies outputs using simulation

---

##  How to Run

1. Open project in Vivado / ModelSim
2. Compile:

   ```
   pipelined_alu.v
   pipelined_alu_tb.v
   ```
3. Run simulation
4. Observe:

   * Waveforms
   * Console output

---

##  Future Improvements

* Add data forwarding
* Implement hazard detection unit
* Introduce pipeline stalling
* Convert to single-clock industrial design

---


