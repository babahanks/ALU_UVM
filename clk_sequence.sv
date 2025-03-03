class clk_sequence extends uvm_sequence;
  `uvm_object_utils(clk_sequence)

  function new(string name = "clk_sequence");
    super.new(name);
  endfunction

  task body();
    $display("Clock Sequence Running...");
    // Add clock-related operations here
  endtask
endclass