`ifndef __ALU_SEQUENCE__
 `define __ALU_SEQUENCE__


`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
`include "alu_seq_item.sv"
import uvm_pkg::*;        // Imports all UVM 

class alu_sequence extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(alu_sequence)

  function new(string name = "alu_sequence");
    super.new(name);
  endfunction

  task body();
    alu_seq_item txn;

    for (int i = 0; i < 5; i++) begin
      txn = alu_seq_item::type_id::create("txn");
      txn.randomize();
      `uvm_info("SEQ", 
                $sformatf("Generated: op_code=%0d, A=%0d, B=%0d", 
                            txn.op_code, txn.input_A, txn.input_B), UVM_MEDIUM)
      
      start_item(txn);
      finish_item(txn);
    end
  endtask

endclass
`endif