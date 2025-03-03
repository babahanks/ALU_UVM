`ifndef __ALU_INPUT_IF__
 `define __ALU_INPUT_IF__
`include "alu_pkg.sv"
import alu_pkg::*;


interface alu_input_if(
 input  logic clk,
 input  logic reset);
  
  logic[31:0] input_A;
  logic[31:0] input_B;
  ALU_OP_CODE op_code;
  logic	      inputs_valid;
endinterface
`endif