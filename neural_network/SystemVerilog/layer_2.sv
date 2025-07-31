module layer_2 #(parameter NUM_NEURON = 30, LAYER_ID = 1, NUM_WEIGHT = 784, DATA_WIDTH = 16, SIGMOID_SIZE = 10, ACT_TYPE = "SIGMOID")
(
	input i_clk,
	input i_reset,
	input [DATA_WIDTH - 1:0] i_input,
	input i_input_valid,
	output [NUM_NEURON - 1:0] o_input_ready,
	input [31:0] i_weight,
	input i_weight_valid,
	input [31:0] i_bias,
	input i_bias_valid,
	input [31:0] i_layer_id,
	input [31:0] i_neuron_id,
	output [NUM_NEURON * DATA_WIDTH - 1:0] o_output,
	output [NUM_NEURON - 1:0] o_output_valid
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(0), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_0.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_0.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_0 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[0]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[0 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[0])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(1), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_1.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_1.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_1 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[1]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[1 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[1])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(2), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_2.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_2.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_2 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[2]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[2 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[2])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(3), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_3.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_3.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_3 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[3]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[3 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[3])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(4), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_4.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_4.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_4 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[4]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[4 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[4])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(5), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_5.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_5.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_5 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[5]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[5 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[5])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(6), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_6.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_6.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_6 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[6]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[6 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[6])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(7), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_7.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_7.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_7 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[7]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[7 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[7])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(8), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_8.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_8.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_8 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[8]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[8 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[8])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(9), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_9.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_9.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_9 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[9]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[9 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[9])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(10), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_10.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_10.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_10 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[10]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[10 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[10])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(11), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_11.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_11.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_11 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[11]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[11 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[11])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(12), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_12.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_12.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_12 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[12]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[12 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[12])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(13), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_13.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_13.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_13 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[13]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[13 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[13])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(14), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_14.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_14.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_14 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[14]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[14 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[14])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(15), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_15.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_15.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_15 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[15]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[15 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[15])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(16), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_16.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_16.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_16 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[16]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[16 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[16])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(17), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_17.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_17.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_17 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[17]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[17 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[17])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(18), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_18.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_18.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_18 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[18]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[18 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[18])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(19), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_19.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_19.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_19 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[19]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[19 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[19])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(20), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_20.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_20.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_20 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[20]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[20 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[20])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(21), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_21.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_21.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_21 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[21]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[21 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[21])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(22), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_22.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_22.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_22 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[22]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[22 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[22])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(23), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_23.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_23.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_23 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[23]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[23 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[23])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(24), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_24.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_24.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_24 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[24]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[24 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[24])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(25), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_25.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_25.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_25 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[25]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[25 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[25])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(26), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_26.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_26.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_26 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[26]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[26 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[26])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(27), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_27.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_27.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_27 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[27]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[27 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[27])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(28), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_28.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_28.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_28 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[28]),
	.i_weight(i_weight),
	.i_weight_valid(i_weight_valid),
	.i_bias(i_bias),
	.i_bias_valid(i_bias_valid),
	.i_layer_id(i_layer_id),
	.i_neuron_id(i_neuron_id),
	.o_output(o_output[28 * DATA_WIDTH +: DATA_WIDTH]),
	.o_output_valid(o_output_valid[28])
);

neuron #(.LAYER_ID(LAYER_ID), .NEURON_ID(29), .NUM_WEIGHT(NUM_WEIGHT), .DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE), .ACT_TYPE(ACT_TYPE), .WEIGHT_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/w_2_29.mif"), .BIAS_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/b_2_29.mif"), .SIGMOID_FILE("C:/Users/t26607bb/Desktop/Practice/Surrey/FPGA_Projects/neural_network/MIF/sig_contents.mif")) neuron_29 (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_input(i_input),
	.i_input_valid(i_input_valid),
	.o_input_ready(o_input_ready[29]),
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