
class alu_bfm_tester;
  
  virtual alu_bfm_if alu_bfm_if_i;
  
  function new (virtual alu_bfm_if b)
    alu_bfm_if_i = b;
  endfunction : new
  
  
  
  task execute();
    logic[31:0] i_A;
    logic[31:0] i_B;
    
  endtask : execute
  
endclass