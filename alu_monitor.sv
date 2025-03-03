`ifndef __ALU_MONITOR__
 `define __ALU_MONITOR__

`include "uvm_macros.svh" // Required for UVM macros
`include "alu_if.sv"
`include "alu_seq_item.sv"

import uvm_pkg::*;        // Imports all UVM 

class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)
  
  virtual alu_if vif; //  ALU Interface
  uvm_analysis_port#(alu_seq_item) mon_ap; //  Sends observed transactions

  function new(string name = "alu_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif))
      `uvm_fatal("MONITOR", "Failed to get virtual interface alu_if")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      alu_seq_item txn;
      @(posedge vif.clk);
      
      txn = alu_seq_item::type_id::create("txn");

      //  Capture ALU Inputs and Output
      txn.op_code = vif.op_code;
      txn.input_A = vif.input_A;
      txn.input_B = vif.input_B;
      txn.result = vif.result;
      txn.result_valid = vif.result_valid;
      txn.inputs_valid = vif.inputs_valid;

      //  Send the observed transaction to the scoreboard
      mon_ap.write(txn);

      `uvm_info("MONITOR", $sformatf("Captured ALU result: op_code=%0d, A=%0d, B=%0d, Result=%0d",
                                    txn.op_code, txn.input_A, txn.input_B, txn.result), UVM_MEDIUM)
    end
  endtask

endclass

`endif
