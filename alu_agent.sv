`ifndef __ALU_AGENT__
 `define __ALU_AGENT__

`include "uvm_macros.svh" // Required for UVM macros
`include "uvm_pkg.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
import uvm_pkg::*;        // Imports all UVM 


class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)

  alu_driver driver;  
  alu_monitor monitor;  
  uvm_sequencer#(alu_seq_item) sequencer;

  function new(string name = "alu_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = alu_driver::type_id::create("driver", this);
    monitor = alu_monitor::type_id::create("monitor", this);
    sequencer = uvm_sequencer#(alu_seq_item)::type_id::create("sequencer", this);
  
    if (driver == null)
      `uvm_fatal("AGENT", "Driver is NULL in build_phase")

    if (monitor == null)
      `uvm_fatal("AGENT", "Monitor is NULL in build_phase")

    if (sequencer == null)
      `uvm_fatal("AGENT", "Sequencer is NULL in build_phase")

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Ensure components are not null before connecting
    if (driver == null)
      `uvm_fatal("AGENT", "Driver is NULL in connect_phase")

    if (sequencer == null)
      `uvm_fatal("AGENT", "Sequencer is NULL in connect_phase")

    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      `uvm_info("AGENT", "Driver successfully connected to sequencer", UVM_MEDIUM)
    end

    
    //driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
  
endclass
`endif