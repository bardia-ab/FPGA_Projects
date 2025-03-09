`timescale 1ns / 1ps

module convolution(
  input i_clk,
  input i_reset,
  // slave AXI interface
  input i_valid,
  input [71:0] i_data,
  output o_ready,
  // master AXI interface
  input i_ready,
  output [7:0] o_data,
  output o_valid
);

  // signals
  logic [3:0] r_m_axis_valid = 4'b0000;
  logic [7:0] r_m_axis_data;
  logic r_s_axis_ready = 1'b1;

  logic [7:0] r_kernel [0:8] = '{default: 1};
  logic [15:0] r_mult [0:8];
  logic [15:0] w_sum;
  logic [15:0] r_sum;

  always_ff @(posedge i_clk)
    for (int i = 0; i < 9; i++)
      r_mult[i] <= r_kernel[i] * i_data[8*i+:8];

  always_comb begin
    w_sum = 0;

    for (int i = 0; i < 9; i++)
      w_sum = w_sum + r_mult[i];
  end

  always_ff @(posedge i_clk) r_sum <= w_sum;

  always_ff @(posedge i_clk) r_m_axis_data <= r_sum / 9;

  always_ff @(posedge i_clk) r_m_axis_valid <= {r_m_axis_valid[2:0], i_valid};

  // output assignments
  assign o_ready = r_s_axis_ready;
  assign o_valid = r_m_axis_valid[3];
  assign o_data = r_m_axis_data;

endmodule