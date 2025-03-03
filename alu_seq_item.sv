`ifndef __ALU_SEQ_ITEM__
 `define __ALU_SEQ_ITEM__


`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
import uvm_pkg::*;        // Imports all UVM 


class alu_seq_item extends uvm_sequence_item;
  `uvm_object_utils(alu_seq_item)  // Registers with the UVM factory
  
  rand logic[31:0] input_A;
  rand logic[31:0] input_B;
  rand ALU_OP_CODE op_code;
  //rand logic	   inputs_valid;
  
  //logic[31:0]      result;
  //logic	           result_valid;	   


  // Constraint: Op Code Should Be Between 0 and 9
  constraint op_code_range {
    op_code >= 4'b0000;
    op_code <= 4'b1010;
  }
  
  // Constructor
  function new(string name = "alu_seq_item");
    super.new(name);
  endfunction

  // Print Method
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    `uvm_info("SEQ_ITEM", 
              $sformatf("op_code=%0d, A=%0d, B=%0d",
                         op_code, input_A, input_B), 
              UVM_MEDIUM)
  endfunction
  
endclass
`endif