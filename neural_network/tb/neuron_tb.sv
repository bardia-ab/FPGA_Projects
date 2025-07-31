`timescale 1ns / 1ps

`include "../SystemVerilog/configuration.svh"

module neuron_tb();

  localparam PERIOD = 10;

  reg i_clk = 1'b1;
  reg i_reset;
  reg [`DATA_WIDTH - 1:0] i_input = 1;
  reg i_input_valid;
  reg o_input_ready;
  reg [31:0] i_weight;
  reg i_weight_valid;
  reg [31:0] i_bias;
  reg i_bias_valid;
  reg [31:0] i_layer_id = 1;
  reg [31:0] i_neuron_id = 0;
  reg [`DATA_WIDTH - 1:0] o_output;
  reg o_output_valid;

  always #(PERIOD / 2) i_clk <= ! i_clk;


neuron # (
  .LAYER_ID(1),
  .NEURON_ID(0),
  .NUM_WEIGHT(`NUM_WEIGHT_L1),
  .DATA_WIDTH(`DATA_WIDTH),
  .SIGMOID_SIZE(`SIGMOID_SIZE),
  .ACT_TYPE(`ACT_TYPE_L1),
  .WEIGHT_FILE("../MIF/w_1_0.mif"),
  .BIAS_FILE("../MIF/b_1_0.mif"),
  .SIGMOID_FILE("../MIF/sig_content.mif")
)
neuron_inst (
  .i_clk(i_clk),
  .i_reset(i_reset),
  .i_input(i_input),
  .i_input_valid(i_input_valid),
  .o_input_ready(o_input_ready),
  .i_weight(i_weight),
  .i_weight_valid(i_weight_valid),
  .i_bias(i_bias),
  .i_bias_valid(i_bias_valid),
  .i_layer_id(i_layer_id),
  .i_neuron_id(i_neuron_id),
  .o_output(o_output),
  .o_output_valid(o_output_valid)
);

  initial begin
    i_reset = 1'b1;
    @(posedge i_clk);
    @(posedge i_clk);
    @(posedge i_clk);
    i_reset = 1'b0;

    for (integer i=0; i <= `NUM_WEIGHT_L1; i++) begin
      $display("i: %0d\t time: %0t\n", i, $time);
      @(posedge i_clk);
      @(posedge o_input_ready)
      i_input_valid = 1'b1;
      @(posedge i_clk);
      i_input_valid = 1'b0;
      @(posedge i_clk);
    end
    @(posedge i_clk);
    @(posedge i_clk);
    @(posedge i_clk);
    @(posedge i_clk);
    $finish();
  end

endmodule