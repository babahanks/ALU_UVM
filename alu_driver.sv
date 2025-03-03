`ifndef __ALU_DRIVER__
 `define __ALU_DRIVER__

`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
`include "alu_if.sv"
`include "alu_seq_item.sv"
import uvm_pkg::*;        // Imports all UVM

class alu_driver extends uvm_driver#(alu_seq_item);
  `uvm_component_utils(alu_driver)
  
  virtual alu_if vif; // ALU Interface
  uvm_analysis_port#(alu_seq_item) drv_ap; // ✅ Sends expected values to the scoreboard

  function new(string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
    drv_ap = new("drv_ap", this); // ✅ Initialize Analysis Port
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif)) 
      begin
      `uvm_fatal("DRIVER", "Failed to get virtual interface alu_if")
      end
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      alu_seq_item txn;
      
      // sequence_item_prt set by the generic: class alu_driver extends uvm_driver#(alu_seq_item);
      seq_item_port.get_next_item(txn); // ✅ Get transaction from sequence

      // ✅ Apply stimulus to DUT via virtual interface
      vif.op_code       <= txn.op_code;
      vif.input_A       <= txn.input_A;
      vif.input_B       <= txn.input_B;
      vif.inputs_valid  <= txn.inputs_valid;

      // ✅ Wait for response from ALU
      @(posedge vif.clk);

      // ✅ Capture ALU response
      txn.result        = vif.result;
      txn.result_valid  = vif.result_valid;

      // ✅ Compute expected ALU result (AFTER stimulus is applied)
      if (~txn.inputs_valid) begin
        txn.result_valid = 1'b0;
      end
      else begin
        case (txn.op_code)
          4'b0000: txn.result = txn.input_A + txn.input_B;  // ADD
          4'b0001: txn.result = txn.input_A - txn.input_B;  // SUBTRACT
          4'b0010: txn.result = txn.input_A ^ txn.input_B;  // XOR
          4'b0011: txn.result = txn.input_A | txn.input_B;  // OR
          4'b0100: txn.result = txn.input_A & txn.input_B;  // AND
          4'b0101: txn.result = txn.input_A << txn.input_B; // Shift Left
          4'b0110: txn.result = txn.input_A >> txn.input_B; // Shift Right Logical
          4'b0111: txn.result = txn.input_A >>> txn.input_B; // Shift Right Arithmetic
          4'b1000: txn.result = (txn.input_A == txn.input_B); // IS_EQUAL
          4'b1001: txn.result = (txn.input_A > txn.input_B); // IS_GREATER
          default: txn.result = 32'hDEADBEEF; // Default Error Value
        endcase
        txn.result_valid = 1'b1;
      end

      // ✅ Print debug info
      `uvm_info("DRIVER", $sformatf("Sent transaction: op=%0b, A=%0d, B=%0d, Expected Result=%0d, DUT Result=%0d",
                                    txn.op_code, txn.input_A, txn.input_B, txn.result, vif.result), UVM_MEDIUM)

      // ✅ Send expected transaction to scoreboard
      drv_ap.write(txn);

      seq_item_port.item_done();
    end
  endtask

endclass
`endif     