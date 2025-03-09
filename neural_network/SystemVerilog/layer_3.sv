module layer_3 #(parameter NUM_NEURON = 30, LAYER_ID = 1, NUM_WEIGHT = 784, DATA_WIDTH = 16, SIGMOID_SIZE = 10, ACT_TYPE = "SIGMOID")
(
	input i_clk,
	input i_reset,
	input [DATA_WIDTH - 1:0] i_input,
	input i_input_valid,
	output o_input_ready,
	input [31:0] i_weight,
	input i_weight_valid,
	input [31:0] i_bias,
	input i_bias_valid,
	input [31:0] i_layer_id,
	input [31:0] i_neuron_id,
	output [NUM_NEURON * DATA_WIDTH - 1:0] o_output,
	output [NUM_NEURON - 1:0] o_output_valid
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_0.mif"), .BIAS_FILE("b_3_0.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_0 (
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
	.o_output(o_output[0 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[0])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_1.mif"), .BIAS_FILE("b_3_1.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_1 (
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
	.o_output(o_output[1 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[1])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_2.mif"), .BIAS_FILE("b_3_2.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_2 (
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
	.o_output(o_output[2 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[2])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_3.mif"), .BIAS_FILE("b_3_3.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_3 (
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
	.o_output(o_output[3 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[3])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_4.mif"), .BIAS_FILE("b_3_4.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_4 (
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
	.o_output(o_output[4 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[4])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_5.mif"), .BIAS_FILE("b_3_5.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_5 (
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
	.o_output(o_output[5 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[5])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_6.mif"), .BIAS_FILE("b_3_6.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_6 (
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
	.o_output(o_output[6 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[6])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_7.mif"), .BIAS_FILE("b_3_7.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_7 (
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
	.o_output(o_output[7 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[7])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_8.mif"), .BIAS_FILE("b_3_8.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_8 (
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
	.o_output(o_output[8 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[8])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_3_9.mif"), .BIAS_FILE("b_3_9.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_9 (
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
	.o_output(o_output[9 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[9])
);

endmodule