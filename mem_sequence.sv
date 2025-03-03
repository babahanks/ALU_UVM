class mem_sequence extends uvm_sequence;
  `uvm_object_utils(mem_sequence)

  function new(string name = "mem_sequence");
    super.new(name);
  endfunction

  task body();
    $display("Memory Sequence Running...");
    // Add memory read/write operations here
  endtask
endclass