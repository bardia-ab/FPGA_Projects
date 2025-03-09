module layer_1 #(parameter NUM_NEURON = 30, LAYER_ID = 1, NUM_WEIGHT = 784, DATA_WIDTH = 16, SIGMOID_SIZE = 10, ACT_TYPE = "SIGMOID")
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_0.mif"), .BIAS_FILE("b_1_0.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_0 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_1.mif"), .BIAS_FILE("b_1_1.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_1 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_2.mif"), .BIAS_FILE("b_1_2.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_2 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_3.mif"), .BIAS_FILE("b_1_3.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_3 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_4.mif"), .BIAS_FILE("b_1_4.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_4 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_5.mif"), .BIAS_FILE("b_1_5.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_5 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_6.mif"), .BIAS_FILE("b_1_6.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_6 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_7.mif"), .BIAS_FILE("b_1_7.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_7 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_8.mif"), .BIAS_FILE("b_1_8.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_8 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_9.mif"), .BIAS_FILE("b_1_9.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_9 (
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

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_10.mif"), .BIAS_FILE("b_1_10.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_10 (
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
	.o_output(o_output[10 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[10])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_11.mif"), .BIAS_FILE("b_1_11.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_11 (
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
	.o_output(o_output[11 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[11])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_12.mif"), .BIAS_FILE("b_1_12.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_12 (
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
	.o_output(o_output[12 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[12])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_13.mif"), .BIAS_FILE("b_1_13.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_13 (
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
	.o_output(o_output[13 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[13])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_14.mif"), .BIAS_FILE("b_1_14.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_14 (
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
	.o_output(o_output[14 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[14])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_15.mif"), .BIAS_FILE("b_1_15.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_15 (
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
	.o_output(o_output[15 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[15])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_16.mif"), .BIAS_FILE("b_1_16.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_16 (
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
	.o_output(o_output[16 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[16])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_17.mif"), .BIAS_FILE("b_1_17.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_17 (
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
	.o_output(o_output[17 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[17])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_18.mif"), .BIAS_FILE("b_1_18.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_18 (
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
	.o_output(o_output[18 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[18])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_19.mif"), .BIAS_FILE("b_1_19.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_19 (
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
	.o_output(o_output[19 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[19])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_20.mif"), .BIAS_FILE("b_1_20.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_20 (
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
	.o_output(o_output[20 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[20])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_21.mif"), .BIAS_FILE("b_1_21.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_21 (
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
	.o_output(o_output[21 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[21])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_22.mif"), .BIAS_FILE("b_1_22.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_22 (
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
	.o_output(o_output[22 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[22])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_23.mif"), .BIAS_FILE("b_1_23.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_23 (
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
	.o_output(o_output[23 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[23])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_24.mif"), .BIAS_FILE("b_1_24.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_24 (
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
	.o_output(o_output[24 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[24])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_25.mif"), .BIAS_FILE("b_1_25.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_25 (
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
	.o_output(o_output[25 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[25])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_26.mif"), .BIAS_FILE("b_1_26.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_26 (
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
	.o_output(o_output[26 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[26])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_27.mif"), .BIAS_FILE("b_1_27.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_27 (
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
	.o_output(o_output[27 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[27])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_28.mif"), .BIAS_FILE("b_1_28.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_28 (
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
	.o_output(o_output[28 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[28])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("w_1_29.mif"), .BIAS_FILE("b_1_29.mif"), .SIGMOID_FILE("sig_contents.mif")) neuron_29 (
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
	.o_output(o_output[29 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[29])
);

endmodule