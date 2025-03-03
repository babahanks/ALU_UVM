`ifndef __ALU_TEST__
 `define __ALU_TEST__


`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
`include "alu_test_env.sv"
`include "alu_seq_item.sv"
`include "alu_sequence.sv"
import uvm_pkg::*;        // Imports all UVM componentsclass 

class alu_test extends uvm_test;
  `uvm_component_utils (alu_test)
  
  virtual alu_if vif;
  alu_test_env env;
  alu_sequence seq;
  
  function new(string name = "alu_test", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_test_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    //$display ("Hello World");
    phase.raise_objection(this);
    //`uvm_info("ALU_TEST", "Starting ALU test", UVM_MEDIUM);

    // Start sequence
    seq = alu_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);

    phase.drop_objection(this);
  endtask
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info("ALU_TEST", "Finalizing ALU test...", UVM_MEDIUM);
    env.scoreboard.print_results(); // ✅ Print test report
  endfunction
  
endclass
`endif