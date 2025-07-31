module ser_mux_ready #(parameter LAYER_ID = 1, NUM_NEURON = 30)
  (
    input [NUM_NEURON-1:0] i_next_layer_output_ready,
    input [31:0] i_neuron_id,
    input [31:0] i_layer_id,
    output o_ready
  );

  logic r_ready;

  always_comb begin
    if (i_layer_id == LAYER_ID)
      r_ready = i_next_layer_output_ready[i_neuron_id];
    else
      r_ready = 1'b0;
    
  end

  assign o_ready = r_ready;

endmodule