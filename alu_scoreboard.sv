`ifndef __ALU_SCOREBOARD__
 `define __ALU_SCOREBOARD__
`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
//`include "alu_if.sv"
`include "alu_seq_item.sv"
import uvm_pkg::*;        // Imports all UVM 

class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)

  // Declare UVM Analysis Imports for Expected & Actual Transactions
  uvm_analysis_imp#(alu_seq_item, alu_scoreboard) expected_imp;
  uvm_analysis_imp#(alu_seq_item, alu_scoreboard) actual_imp;
  
  int pass_count = 0; // Track passed tests
  int fail_count = 0; // Track failed tests
  int total_tests = 0;

  alu_seq_item expected_queue[$]; // Queue for Expected Results
  alu_seq_item actual_queue[$];   // Queue for Actual Results

  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    expected_imp = new("expected_imp", this);
    actual_imp = new("actual_imp", this);
  endfunction

  function void write_expected(alu_seq_item txn);
    `uvm_info("SCOREBOARD", "in write_expected", UVM_LOW);
    expected_queue.push_back(txn);
  endfunction

  function void write_actual(alu_seq_item txn);
    `uvm_info("SCOREBOARD", "in write_actual", UVM_LOW);
    actual_queue.push_back(txn);
  endfunction
  
  // Implement `write()` method required by `uvm_analysis_imp`
  function void write(alu_seq_item txn);
    if ($cast(txn, txn)) begin
      `uvm_info("SCOREBOARD", "in write.. actual", UVM_LOW);
      actual_queue.push_back(txn);
    end else begin
      `uvm_info("SCOREBOARD", "in write.. expected", UVM_LOW);
      expected_queue.push_back(txn);
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      #10;
      `uvm_info("SCOREBOARD", "in forever", UVM_LOW);
      `uvm_info("SCOREBOARD", $sformatf("expected_queue.size: %d", expected_queue.size()), UVM_LOW);
      `uvm_info("SCOREBOARD", $sformatf("actual_queue.size: %d"  , actual_queue.size()),   UVM_LOW);

      if (expected_queue.size() > 0 && actual_queue.size() > 0) begin
        alu_seq_item exp, act;
        exp = expected_queue.pop_front();
        act = actual_queue.pop_front();
        total_tests++;
        
        `uvm_info("SCOREBOARD", $sformatf("act.result %0d", act.result), UVM_LOW);
        `uvm_info("SCOREBOARD", $sformatf("exp.result %0d", exp.result), UVM_LOW);
        `uvm_info("SCOREBOARD", $sformatf("act.result_valid %0d", act.result_valid), UVM_LOW);
        `uvm_info("SCOREBOARD", $sformatf("exp.result_valid %0d", exp.result_valid), UVM_LOW);

        if (exp.result == act.result && exp.result_valid == act.result_valid) begin
          pass_count++;
          `uvm_info("SCOREBOARD", $sformatf("[PASSED] Test %0d: Expected=%0d, Actual=%0d", 
                                           total_tests, exp.result, act.result), UVM_LOW)
        end else begin
          fail_count++;
          `uvm_error("SCOREBOARD", $sformatf("[FAILED] Test %0d: Expected=%0d, Actual=%0d",
                                            total_tests, exp.result, act.result))
        end
      end
    end
  endtask


  function void print_results();
    `uvm_info("SCOREBOARD", $sformatf("Total Tests Run: %0d", total_tests), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Tests Passed: %0d", pass_count), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Tests Failed: %0d", fail_count), UVM_NONE)

    if (fail_count == 0)
      `uvm_info("SCOREBOARD", " ALL TESTS PASSED ", UVM_NONE)
    else
      `uvm_info("SCOREBOARD", " SOME TESTS FAILED ", UVM_NONE)
  endfunction
      
endclass

`endif
