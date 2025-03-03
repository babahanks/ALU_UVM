`ifndef __ALU_PKG__
 `define __ALU_PKG__

package alu_pkg;

  typedef enum logic [3:0] {

    ADD         	= 4'b0000,
    SUBTRACT        = 4'b0001,
    XOR       	    = 4'b0010,
    OR        	    = 4'b0011,
    AND       	    = 4'b0100,
    SHIFT_LT_LOG    = 4'b0101,
    SHIFT_RT_LOG    = 4'b0110,
    SHIFT_RT_AR     = 4'b0111,
    BARREL_SHIFTER  = 4'b1000,
    IS_EQUAL        = 4'b1001,
    IS_GREATER      = 4'b1010
  } 
  ALU_OP_CODE;

endpackage
`endif