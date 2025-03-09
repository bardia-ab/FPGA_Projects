`timescale 1ns/1ps

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

  logic [7:0] r_kernel_x [8:0];
  logic [7:0] r_kernel_y [8:0];
  logic [10:0] r_mult_x [8:0];
  logic [10:0] r_mult_y [8:0];
  logic [10:0] w_sum_x;
  logic [10:0] w_sum_y;
  logic [10:0] r_sum_x;
  logic [10:0] r_sum_y;
  logic [20:0] r_convolve_x;
  logic [20:0] r_convolve_y;
  logic [3:0] r_data_valid = 4'b0;
  logic [21:0] r_convolved_data;
  logic [7:0] r_convolved_data_threshold;
  logic r_s_axis_ready = 1'b1;

  localparam P_THRESHOLD = 5000;

  initial begin
    r_kernel_x[0] = 1;
    r_kernel_x[1] = 0;
    r_kernel_x[2] = -1;
    r_kernel_x[3] = 2;
    r_kernel_x[4] = 0;
    r_kernel_x[5] = -2;
    r_kernel_x[6] = 1;
    r_kernel_x[7] = 0;
    r_kernel_x[8] = -1;
    
    r_kernel_y[0] = 1;
    r_kernel_y[1] = 2;
    r_kernel_y[2] = 1;
    r_kernel_y[3] = 0;
    r_kernel_y[4] = 0;
    r_kernel_y[5] = 0;
    r_kernel_y[6] = -1;
    r_kernel_y[7] = -2;
    r_kernel_y[8] = -1;
  end

  always_ff @(posedge i_clk) 
    for (int i=0; i<9; i++) begin
      r_mult_x[i] <= $signed(r_kernel_x[i]) * $signed({1'b0, i_data[8*i+:8]});
      r_mult_y[i] <= $signed(r_kernel_y[i]) * $signed({1'b0, i_data[8*i+:8]});
    end

  always_comb begin
    w_sum_x = 0;
    w_sum_y = 0;

    for (int j=0; j<9; j++) begin
      w_sum_x = $signed(w_sum_x) + $signed(r_mult_x[j]);
      w_sum_y = $signed(w_sum_y) + $signed(r_mult_y[j]);
    end
  end

  always_ff @(posedge i_clk) begin
    r_sum_x <= w_sum_x;
    r_sum_y <= w_sum_y;
  end

  always_ff @(posedge i_clk) begin
    r_convolve_x <= $signed(r_sum_x) * $signed(r_sum_x);
    r_convolve_y <= $signed(r_sum_y) * $signed(r_sum_y);
  end

  assign r_convolved_data = r_convolve_x + r_convolve_y;

  always_ff @(posedge i_clk)
    if (r_convolved_data > P_THRESHOLD)
      r_convolved_data_threshold <= 8'hff;
    else  
      r_convolved_data_threshold <= 8'h00;

  always_ff @(posedge i_clk) begin
    r_data_valid <= {r_data_valid[2:0], i_valid};
  end

  // output assignments
  assign o_ready = r_s_axis_ready;
  assign o_valid = r_data_valid[3];
  assign o_data = r_convolved_data_threshold;

endmodule