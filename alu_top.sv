`ifndef __ALU_TOP__
 `define __ALU_TOP__

`include "alu_pkg.sv"
`include "alu_input_if.sv"
`include "alu_output_if.sv"

`include "alu.sv"
//`include "alu_test.sv"

module alu_top();
  
  logic clk;
  logic reset;
  
  alu_input_if alu_input_if_i(clk, reset);
  alu_output_if alu_output_if_i();
  
  alu alu_i(.alu_input_if_i(alu_input_if_i),
            .alu_output_if_i(alu_output_if_i));
  
  always #5 clk = ~clk;
  
 initial begin
    clk = 0;
    reset = 1;
    #10 reset = 0;
   $finish();
  end

  
  /*
  initial begin
    clk = 0;
    reset = 1;
    #10 reset = 0;
  end

  
  initial begin
    uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top.env.agent.driver", "alu_if", alu_if_i);
    uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top.env.agent.monitor", "alu_if", alu_if_i); 
	run_test("alu_test");
  end
 */
endmodule
`endif