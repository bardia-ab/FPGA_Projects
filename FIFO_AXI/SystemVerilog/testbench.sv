class transaction;
  // AXI input interface
  rand bit [7:0] i_data_in;
  rand bit i_valid_in;
  bit o_ready_in;

  // AXI output interface
  bit [7:0] o_data_out;
  rand bit i_ready_out;
  bit o_valid_out;

  constraint wr_rd {
    i_valid_in dist {0 :/ 50, 1 :/ 50};
    i_ready_out dist {0 :/ 50, 1 :/ 50};
  }

  constraint data_con {
    i_data_in > 1;
    i_data_in < 5;
  }

  function void display(string tag);
    $display("[%0s] : WR : %0b\t RD : %0b\t DATA_IN : %0d\t DATA_OUT : %0d\t FULL : %0b\t EMPTY : %0b @ %0t",
    tag, i_valid_in, i_ready_out, i_data_in, o_data_out, ~ o_ready_in, ~ o_valid_out, $time);
  endfunction

  function transaction copy();
    copy = new();
    copy.i_data_in = i_data_in;
    copy.i_valid_in = i_valid_in;
    copy.o_ready_in = o_ready_in;
    copy.o_data_out = o_data_out;
    copy.i_ready_out = i_ready_out;
    copy.o_valid_out = o_valid_out;
  endfunction

endclass

class generator;
  transaction tr;
  mailbox #(transaction) mbx;
  int count = 0;

  event next;
  event done;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction

  task run();
    repeat(count) begin
      assert (tr.randomize()) else $error("Randomization failed");
      mbx.put(tr.copy);
      tr.display("GEN");
      @(next);
    end
    -> done;
  endtask

endclass

class driver;
  virtual fifo_if fif;
  mailbox #(transaction) mbx;
  transaction datac;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task reset();
    fif.i_reset <= 1'b1;
    fif.i_data_in <= 0;
    fif.i_valid_in <= 1'b0;
    fif.i_ready_out <= 1'b0;
    repeat(5) @(posedge fif.i_clk);
    fif.i_reset <= 1'b0;
    $display("[DRV] : DUT RESET DONE");
  endtask;

  task run();
    forever begin
      mbx.get(datac);
      datac.display("DRV");
      fif.i_data_in <= datac.i_data_in;
      fif.i_valid_in <= datac.i_valid_in;
      fif.i_ready_out <= datac.i_ready_out;
      repeat(1) @(posedge fif.i_clk);
    end
  endtask

endclass

class monitor;
  virtual fifo_if fif;
  mailbox #(transaction) mbx;
  transaction tr;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    tr = new();  

    forever begin  
      repeat(2) @(posedge fif.i_clk);
      tr.i_data_in = fif.i_data_in;
      tr.i_valid_in = fif.i_valid_in;
      tr.o_ready_in = fif.o_ready_in;
      tr.o_data_out = fif.o_data_out;
      tr.i_ready_out = fif.i_ready_out;
      tr.o_valid_out = fif.o_valid_out;

      mbx.put(tr);
      tr.display("MON");
    end
  endtask

endclass

class scoreboard;
  mailbox #(transaction) mbx;
  transaction tr;

  bit [7:0] queue[$];
  bit [7:0] temp;

  event next;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    forever begin
      mbx.get(tr);
      tr.display("SCO");

      if (tr.i_valid_in) begin
        queue.push_front(tr.i_data_in);
        $display("[SCO] : DATA STORED IN QUEUE : %0d", tr.i_data_in);
      end

      if (tr.i_ready_out)
        if (tr.o_valid_out) begin
          temp = queue.pop_back();

          if (tr.o_data_out == temp)
            $display("[SCO] : DATA MATCH");
          else
            $display("[SCO] : DATA MISMATCH : %0d", temp);
        end else
          $display("[SCO] : FIFO IS EMPTY");
    
      -> next;
    end
  endtask

  
endclass

class environment;
  mailbox #(transaction) gdmbx;
  generator gen;
  driver drv;

  virtual fifo_if fif;

  mailbox #(transaction) msmbx;
  monitor mon;
  scoreboard sco;

  event nextgs;

  function new(virtual fifo_if fif);
    gdmbx = new();
    gen = new(gdmbx);
    drv = new(gdmbx);

    msmbx = new();
    mon = new(msmbx);
    sco = new(msmbx);

    // interface
    this.fif = fif;
    drv.fif = this.fif;
    mon.fif = this.fif;

    // event
    gen.next = nextgs;
    sco.next = nextgs;

  endfunction

  task pre_test();
    drv.reset();
  endtask

  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();  
    join_any
  endtask

  task post_test();
    wait(gen.done.triggered);
    $finish();
  endtask

  task run();
    pre_test();
    test();
    post_test();
  endtask

endclass

module tb;
  fifo_if fif();
  fifo_axi dut (fif.i_clk, fif.i_reset, fif.i_data_in, fif.i_valid_in, fif.o_ready_in, fif.o_data_out, fif.i_ready_out, fif.o_valid_out);
  environment env = new(fif);

  initial fif.i_clk <= 1'b0;
  always #5 fif.i_clk <= ~ fif.i_clk;
  
  initial begin
    env.gen.count = 20;
    env.run();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule