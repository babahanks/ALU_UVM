`ifndef __ALU_OUTPUT_IF__
 `define __ALU_OUTPUT_IF__


interface alu_output_if();
  logic[31:0] result;
  logic	      result_valid;	   
endinterface

`endif