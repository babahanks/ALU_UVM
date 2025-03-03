`ifndef __ALU__
 `define __ALU__

`include "alu_pkg.sv"
`include "alu_input_if.sv"
`include "alu_output_if.sv"

module alu (
  alu_input_if  alu_input_if_i, 
  alu_output_if alu_output_if_i );

  always_ff @(posedge alu_input_if_i.clk) begin
    if (alu_input_if_i.reset) begin
        alu_output_if_i.result_valid <= 1'b0;
    end
    else begin
      if (alu_input_if_i.inputs_valid) begin
        case (alu_input_if_i.op_code)
            ADD:            alu_output_if_i.result <= alu_input_if_i.input_A + alu_input_if_i.input_B;               
            SUBTRACT:       alu_output_if_i.result <= alu_input_if_i.input_A - alu_input_if_i.input_B;
            XOR:            alu_output_if_i.result <= alu_input_if_i.input_A ^ alu_input_if_i.input_B;
            OR:             alu_output_if_i.result <= alu_input_if_i.input_A | alu_input_if_i.input_B;
            AND:            alu_output_if_i.result <= alu_input_if_i.input_A & alu_input_if_i.input_B;
            SHIFT_LT_LOG:   alu_output_if_i.result <= alu_input_if_i.input_A << alu_input_if_i.input_B;
            SHIFT_RT_LOG:   alu_output_if_i.result <= alu_input_if_i.input_A >> alu_input_if_i.input_B;
            SHIFT_RT_AR:    alu_output_if_i.result <= alu_input_if_i.input_A >>> alu_input_if_i.input_B;
            //BARREL_SHIFTER: 
            IS_EQUAL:       alu_output_if_i.result <= alu_input_if_i.input_A == alu_input_if_i.input_B;
            IS_GREATER:     alu_output_if_i.result <= alu_input_if_i.input_A >  alu_input_if_i.input_B; 
          endcase
          alu_output_if_i.result_valid <= 1'b1;
        end      
      if (alu_output_if_i.result_valid) begin // bring it down next 
          alu_output_if_i.result_valid <= 1'b0;        
        end
    end // else begin    
  end

endmodule
`endif
