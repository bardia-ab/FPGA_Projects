`timescale 1ns / 1ps

`include "configuration.svh"

module neural_network #(
  parameter S_AXI_DATA_WIDTH = 32, S_AXI_ADDR_WIDTH = 5) (
  input i_clk,
  input i_reset,
  // user IO
  input [31:0] i_weight,
  input i_weight_valid,
  input [31:0] i_bias,
  input i_bias_valid,
  input [31:0] i_layer_id,
  input [31:0] i_neuron_id,
  // slave AXI stream interface
  input [`DATA_WIDTH - 1:0] i_s_axis_data,
  input i_s_axis_valid,
  output o_s_axis_ready,
  // master AXI stream interface
  input i_m_axis_ready,
  output [31:0] o_m_axis_data,
  output o_m_axis_valid
);

  //signals
  logic [`NUM_NEURON_L1 * `DATA_WIDTH - 1:0] r_L1_output;
  logic [`NUM_NEURON_L1 - 1:0] r_L1_output_valid;

  logic [`NUM_NEURON_L2 * `DATA_WIDTH - 1:0] r_L2_output;
  logic [`NUM_NEURON_L2 - 1:0] r_L2_output_valid;
  logic [`DATA_WIDTH - 1:0] r_L2_input;
  logic r_L2_input_valid;
  logic r_L2_input_ready;

  logic [`NUM_NEURON_L3 * `DATA_WIDTH - 1:0] r_L3_output;
  logic [`NUM_NEURON_L3 - 1:0] r_L3_output_valid;
  logic [`DATA_WIDTH - 1:0] r_L3_input;
  logic r_L3_input_valid;
  logic r_L3_input_ready;

  logic [`NUM_NEURON_L4 * `DATA_WIDTH - 1:0] r_L4_output;
  logic [`NUM_NEURON_L4 - 1:0] r_L4_output_valid;
  logic [`DATA_WIDTH - 1:0] r_L4_input;
  logic r_L4_input_valid;
  logic r_L4_input_ready;

  /********************* Layer 1 *********************/
  layer_1 # (
    .NUM_NEURON(`NUM_NEURON_L1),
    .LAYER_ID(1),
    .NUM_WEIGHT(`NUM_WEIGHT_L1),
    .DATA_WIDTH(`DATA_WIDTH),
    .SIGMOID_SIZE(`SIGMOID_SIZE),
    .ACT_TYPE(`ACT_TYPE_L1)
  )
  layer_1_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_input(i_s_axis_data),
    .i_input_valid(i_s_axis_valid),
    .o_input_ready(o_s_axis_ready),
    .i_weight(i_weight),
    .i_weight_valid(i_weight_valid),
    .i_bias(i_bias),
    .i_bias_valid(i_bias_valid),
    .i_layer_id(i_layer_id),
    .i_neuron_id(i_neuron_id),
    .o_output(r_L1_output),
    .o_output_valid(r_L1_output_valid)
  );

  serializer # (
    .N_PARALLEL(`NUM_NEURON_L1),
    .DATA_WIDTH(`DATA_WIDTH)
  )
  serializer_1_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_data(r_L1_output),
    .i_valid(r_L1_output_valid[0]),
    .o_ready(),
    .i_ready(r_L2_input_ready),
    .o_data(r_L2_input),
    .o_valid(r_L2_input_valid)
  );

  /********************* Layer 2 *********************/
  layer_2 # (
    .NUM_NEURON(`NUM_NEURON_L2),
    .LAYER_ID(2),
    .NUM_WEIGHT(`NUM_WEIGHT_L2),
    .DATA_WIDTH(`DATA_WIDTH),
    .SIGMOID_SIZE(`SIGMOID_SIZE),
    .ACT_TYPE(`ACT_TYPE_L2)
  )
  layer_2_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_input(r_L2_input),
    .i_input_valid(r_L2_input_valid),
    .o_input_ready(r_L2_input_ready),
    .i_weight(i_weight),
    .i_weight_valid(i_weight_valid),
    .i_bias(i_bias),
    .i_bias_valid(i_bias_valid),
    .i_layer_id(i_layer_id),
    .i_neuron_id(i_neuron_id),
    .o_output(r_L2_output),
    .o_output_valid(r_L2_output_valid)
  );

  serializer # (
    .N_PARALLEL(`NUM_NEURON_L2),
    .DATA_WIDTH(`DATA_WIDTH)
  )
  serializer_2_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_data(r_L2_output),
    .i_valid(r_L2_output_valid[0]),
    .o_ready(),
    .i_ready(r_L3_input_ready),
    .o_data(r_L3_input),
    .o_valid(r_L3_input_valid)
  );

  /********************* Layer 3 *********************/
  layer_3 # (
    .NUM_NEURON(`NUM_NEURON_L3),
    .LAYER_ID(3),
    .NUM_WEIGHT(`NUM_WEIGHT_L3),
    .DATA_WIDTH(`DATA_WIDTH),
    .SIGMOID_SIZE(`SIGMOID_SIZE),
    .ACT_TYPE(`ACT_TYPE_L3)
  )
  layer_3_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_input(r_L3_input),
    .i_input_valid(r_L3_input_valid),
    .o_input_ready(r_L3_input_ready),
    .i_weight(i_weight),
    .i_weight_valid(i_weight_valid),
    .i_bias(i_bias),
    .i_bias_valid(i_bias_valid),
    .i_layer_id(i_layer_id),
    .i_neuron_id(i_neuron_id),
    .o_output(r_L3_output),
    .o_output_valid(r_L3_output_valid)
  );

  serializer # (
    .N_PARALLEL(`NUM_NEURON_L3),
    .DATA_WIDTH(`DATA_WIDTH)
  )
  serializer_3_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_data(r_L3_output),
    .i_valid(r_L3_output_valid[0]),
    .o_ready(),
    .i_ready(r_L4_input_ready),
    .o_data(r_L4_input),
    .o_valid(r_L4_input_valid)
  );

  /********************* Layer 4 *********************/
  layer_4 # (
    .NUM_NEURON(`NUM_NEURON_L4),
    .LAYER_ID(4),
    .NUM_WEIGHT(`NUM_WEIGHT_L4),
    .DATA_WIDTH(`DATA_WIDTH),
    .SIGMOID_SIZE(`SIGMOID_SIZE),
    .ACT_TYPE(`ACT_TYPE_L4)
  )
  layer_4_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_input(r_L4_input),
    .i_input_valid(r_L4_input_valid),
    .o_input_ready(r_L4_input_ready),
    .i_weight(i_weight),
    .i_weight_valid(i_weight_valid),
    .i_bias(i_bias),
    .i_bias_valid(i_bias_valid),
    .i_layer_id(i_layer_id),
    .i_neuron_id(i_neuron_id),
    .o_output(r_L4_output),
    .o_output_valid(r_L4_output_valid)
  );

  max_finder # (
    .N_PARALLEL(`NUM_NEURON_L4),
    .DATA_WIDTH(`DATA_WIDTH)
  )
  max_finder_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_data(r_L4_output),
    .i_valid(r_L4_output_valid[0]),
    .o_ready(),
    .i_ready(i_m_axis_ready),
    .o_data(o_m_axis_data),
    .o_valid(o_m_axis_valid)
  );

endmodule