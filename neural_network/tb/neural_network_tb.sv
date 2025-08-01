`timescale 1ns / 1ps

`include "../SystemVerilog/configuration.svh"

module neural_network_tb ();

  localparam PERIOD = 10;
  localparam NUM_TESTS = 10;

  reg i_clk = 1'b1;
  reg i_reset = 1'b0;
  reg [31:0] i_layer_id;
  reg [31:0] i_neuron_id;
  reg [`DATA_WIDTH - 1:0] i_s_axis_data;
  reg i_s_axis_valid = 1'b0;
  reg [`NUM_NEURON_L1 - 1:0] o_s_axis_ready;
  reg i_m_axis_ready = 1'b0;
  reg [31:0] o_m_axis_data;
  reg o_m_axis_valid;
  string r_file_name;
  string r_file_name_fmt = "../test_input/test_data_";
  logic [`DATA_WIDTH - 1:0] r_expected = 0;
  integer r_correct = 0;
  integer i;

  task send_input(input string file_name);
    logic [`DATA_WIDTH - 1:0] mem [0:784];

    $readmemb(file_name, mem);
    r_expected = mem[784];

    //////////////// Layer 1 /////////////////////
    i_layer_id = 1;

    for (int j=0; j < `NUM_NEURON_L1; j++)
    begin
      i_neuron_id = j;
      for (int i = 0; i < `NUM_WEIGHT_L1; i++)
      begin
        wait (o_s_axis_ready[j]);
        i_s_axis_valid = 1'b1;
        i_s_axis_data = mem[i];
        @(negedge o_s_axis_ready[j]);
        i_s_axis_valid = 1'b0;
      end
      @(posedge neural_network_inst.layer_1_inst.o_output_valid[j]);
      //$display("Neuron_%0d_%0d: %0d", i_layer_id, j, neural_network_inst.layer_1_inst.o_output[j * 16 +: 16]);
    end 
    
    ///////////////// Layer 2 /////////////////////
    i_layer_id = 2;

    for (int j=0; j < `NUM_NEURON_L2; j++)
    begin
      wait (neural_network_inst.r_serializer_1_ready);
      i_neuron_id = j;
      @(posedge neural_network_inst.layer_2_inst.o_output_valid[j]);
	//$display("Neuron_%0d_%0d: %0d", i_layer_id, j, neural_network_inst.layer_2_inst.o_output[j * 16 +: 16]);
    end

    //////////////// Layer 3 /////////////////////
    i_layer_id = 3;
	i_neuron_id = 0;

    for (int j=0; j < `NUM_NEURON_L3; j++)
    begin
      wait (neural_network_inst.r_serializer_2_ready);
      i_neuron_id = j;
      @(posedge neural_network_inst.layer_3_inst.o_output_valid[j]);
	//$display("Neuron_%0d_%0d: %0d", i_layer_id, j, neural_network_inst.layer_3_inst.o_output[j * 16 +: 16]);
    end

    //////////////// Layer 4 /////////////////////
    i_layer_id = 4;

    for (int j=0; j < `NUM_NEURON_L4; j++)
    begin
      wait (neural_network_inst.r_serializer_3_ready);
      i_neuron_id = j;
      @(posedge neural_network_inst.layer_4_inst.o_output_valid[j]);
	//$display("Neuron_%0d_%0d: %0d", i_layer_id, j, neural_network_inst.layer_4_inst.o_output[j * 16 +: 16]);
    end
	//$display("Expected Value: %0d", r_expected);

    i_layer_id = 1;

  endtask


  function string int_to_str(int value);
    automatic string str = "";
    int mod;
    while (value > 0)
    begin
      mod = 48 + (value % 10);
      str = {mod, str};
      value = value / 10;
    end
    return str;
  endfunction

  function string get_test_idx(int idx);
    if (idx == 0)
      return "0000";
    else if (idx < 10)
      return {"000", int_to_str(idx)};
    else if (idx < 100)
      return {"00", int_to_str(idx)};
    else if (idx < 10000)
      return {"0", int_to_str(idx)};
    else
      return int_to_str(idx);

  endfunction



  neural_network  neural_network_inst (
                    .i_clk(i_clk),
                    .i_reset(i_reset),
                    .i_weight(),
                    .i_weight_valid(),
                    .i_bias(),
                    .i_bias_valid(),
                    .i_layer_id(i_layer_id),
                    .i_neuron_id(i_neuron_id),
                    .i_s_axis_data(i_s_axis_data),
                    .i_s_axis_valid(i_s_axis_valid),
                    .o_s_axis_ready(o_s_axis_ready),
                    .i_m_axis_ready(i_m_axis_ready),
                    .o_m_axis_data(o_m_axis_data),
                    .o_m_axis_valid(o_m_axis_valid)
                  );

  // clock generation
  always #(PERIOD / 2) i_clk = !i_clk;

  initial
  begin
    // send input test data
    for (i = 0; i < NUM_TESTS; i++)
    begin
      // assert reset
      @(posedge i_clk);
      i_reset = 1'b1;
      repeat(3) @(posedge i_clk);
      // deassert ereset
      i_reset = 1'b0;
      @(posedge i_clk);

      r_file_name = {r_file_name_fmt, get_test_idx(i), ".txt"};
      send_input(r_file_name);

      wait(o_m_axis_valid);
      @(posedge i_clk);
      if (r_expected == o_m_axis_data)
        r_correct = r_correct + 1;

      $display("%0d- Accuracy: %.2f, Detected digit: %0x, Expected digit: %0x", (i + 1), r_correct * 100.0 / (i + 1), o_m_axis_data, r_expected);
    end

    $display("Accuracy: %.2f", r_correct * 100.0 / i);
    $stop;
  end

endmodule
