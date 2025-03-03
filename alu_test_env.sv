`ifndef __ALU_TEST_ENV__
 `define __ALU_TEST_ENV__


`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
`include "alu_agent.sv"
`include "alu_scoreboard.sv"
`include "alu_monitor.sv"
import uvm_pkg::*;        // Imports all UVM 
class alu_test_env extends uvm_env;
  `uvm_component_utils (alu_test_env);
  
  
  alu_agent agent;
  alu_scoreboard scoreboard;
  
  function new(string name, uvm_component parent);
	super.new (name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent = alu_agent::type_id::create("agent", this);
    scoreboard = alu_scoreboard::type_id::create("scoreboard", this);

    if (agent == null)
      `uvm_fatal("TEST_ENV", "Agent is NULL in build_phase")

    if (scoreboard == null)
      `uvm_fatal("TEST_ENV", "Scoreboard is NULL in build_phase")
  
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    `uvm_info("TEST_ENV", "Entering connect_phase()", UVM_MEDIUM)
    
    if (agent == null) begin
      `uvm_fatal("TEST_ENV", "agent is NULL in connect_phase");
    end
    else `uvm_info("TEST_ENV", "connect_phase: agent is not null in ", UVM_MEDIUM)
      
    if (agent.driver == null)
      `uvm_fatal("TEST_ENV", "agent.driver is NULL in connect_phase")
    else `uvm_info("TEST_ENV", "connect_phase: agent.driver is not null in ", UVM_MEDIUM)
      
    if (agent.driver.drv_ap == null)
      `uvm_fatal("TEST_ENV", "agent.driver.drv_ap is NULL in connect_phase")
    else `uvm_info("TEST_ENV", "connect_phase: agent.driver.drv_ap is not null in ", UVM_MEDIUM)

    if (scoreboard == null)
      `uvm_fatal("TEST_ENV", "scoreboard is NULL in connect_phase")

    agent.driver.drv_ap.connect(scoreboard.expected_imp); //  Connect Expected Results
    agent.monitor.mon_ap.connect(scoreboard.actual_imp);  //  Connect Actual Results
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #50;
    phase.drop_objection(this);
  endtask
  
endclass
`endif