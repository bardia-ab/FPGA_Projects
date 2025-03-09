`timescale 1ns / 1ps

`include "../SystemVerilog/configuration.svh"

module neural_network_tb ();

  localparam PERIOD = 10;
  localparam NUM_TESTS = 1000;

  reg i_clk = 1'b1;
  reg i_reset = 1'b0;
  reg [`DATA_WIDTH - 1:0] i_s_axis_data;
  reg i_s_axis_valid = 1'b0;
  reg o_s_axis_ready;
  reg i_m_axis_ready = 1'b0;
  reg [31:0] o_m_axis_data;
  reg o_m_axis_valid;
  string r_file_name;
  string r_file_name_fmt = "../test_input/test_data_%04d.txt";
  logic [`DATA_WIDTH - 1:0] r_expected;
  integer r_correct = 0;
  integer i;

  task send_input(input string file_name, input o_s_axis_ready, output i_s_axis_valid,output [`DATA_WIDTH - 1:0] expected_value);
    logic [`DATA_WIDTH - 1:0] mem [0:784];
    $readmemb(file_name,  mem);
    expected_value = mem[784];

    for (integer i = 0; i < 784; i++) begin
      i_s_axis_valid = 1'b0;
      @(posedge i_clk);
      wait (o_s_axis_ready);
      @(posedge i_clk);
      i_s_axis_valid = 1'b1;     
    end

    i_s_axis_valid = 1'b0;
    @(posedge i_clk);

  endtask

  neural_network  neural_network_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_weight(),
    .i_weight_valid(),
    .i_bias(),
    .i_bias_valid(),
    .i_layer_id(),
    .i_neuron_id(),
    .i_s_axis_data(i_s_axis_data),
    .i_s_axis_valid(i_s_axis_valid),
    .o_s_axis_ready(o_s_axis_ready),
    .i_m_axis_ready(i_m_axis_ready),
    .o_m_axis_data(o_m_axis_data),
    .o_m_axis_valid(o_m_axis_valid)
  );

  // clock generation
  always #(PERIOD / 2) i_clk = !i_clk;

  initial begin
    // assert reset
    @(posedge i_clk);
    i_reset = 1'b1;
    repeat(3) @(posedge i_clk);
    // deassert ereset
    i_reset = 1'b0;
    @(posedge i_clk);
    
    // send input test data
    for (i = 0; i < NUM_TESTS; i++) begin
      r_file_name = $sformatf(r_file_name_fmt, i);
      $display(r_file_name);
      send_input(r_file_name, o_s_axis_ready, i_s_axis_valid, r_expected);

      wait(o_m_axis_valid);
      @(posedge i_clk);
      if (r_expected == o_m_axis_data)
        r_correct = r_correct + 1;

      $display("Accuracy: %f, Detected digit: %0x, Expected digit: %0x", r_correct / (i + 1) * 100, o_m_axis_data, r_expected);
    end

    $display("Accuracy: %f", r_correct / (i + 1) * 100);
    $stop;
  end

endmodule