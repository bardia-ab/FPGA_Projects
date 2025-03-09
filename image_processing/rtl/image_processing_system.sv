`timescale 1ns / 1ps

module image_processing_system #(parameter LINE_WIDTH = 512) (
  input i_clk,
  input i_reset_n,
  // slave AXI interface
  input i_valid,
  input [7:0] i_data,
  output o_ready,
  // master AXI interface
  input i_ready,
  output [7:0] o_data,
  output o_valid,
  // interrupt
  output o_intr
);

  // line buffer signals
  logic [23:0] w_lb_data_out [0:3];
  logic w_lb_rd_ready [0:3];
  logic w_control_lb_rd_ready;
  logic [3:0] w_lb_wr_valid;
  logic [1:0] w_wr_demux_slct;
  logic [1:0] w_rd_mux_slct;

  // convolution signals
  logic [71:0] w_conv_data_in;
  logic [7:0] w_conv_data_out;
  logic w_conv_m_valid;

  // image controller
  image_controller # (
    .LINE_WIDTH(LINE_WIDTH)
  )
  image_controller_inst (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_valid(i_valid),
    .o_wr_demux_slct(w_wr_demux_slct),
    .o_rd_mux_slct(w_rd_mux_slct),
    .o_lb_ready(w_control_lb_rd_ready),
    .o_intr(o_intr)
  );

  // convolution
  convolution  convolution_inst (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_valid(w_control_lb_rd_ready),
    .i_data(w_conv_data_in),
    .o_ready(),
    .i_ready(),
    .o_data(w_conv_data_out),
    .o_valid(w_conv_m_valid)
  );

  // line buffer
  line_buffer # (
    .LINE_WIDTH(LINE_WIDTH)
  )
  line_buffer_0 (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_valid(w_lb_wr_valid[0]),
    .i_data(i_data),
    .o_ready(),
    .i_ready(w_lb_rd_ready[0]),
    .o_data(w_lb_data_out[0]),
    .o_valid()
  );

  line_buffer # (
    .LINE_WIDTH(LINE_WIDTH)
  )
  line_buffer_1 (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_valid(w_lb_wr_valid[1]),
    .i_data(i_data),
    .o_ready(),
    .i_ready(w_lb_rd_ready[1]),
    .o_data(w_lb_data_out[1]),
    .o_valid()
  );

  line_buffer # (
    .LINE_WIDTH(LINE_WIDTH)
  )
  line_buffer_2 (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_valid(w_lb_wr_valid[2]),
    .i_data(i_data),
    .o_ready(),
    .i_ready(w_lb_rd_ready[2]),
    .o_data(w_lb_data_out[2]),
    .o_valid()
  );

  line_buffer # (
    .LINE_WIDTH(LINE_WIDTH)
  )
  line_buffer_3 (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_valid(w_lb_wr_valid[3]),
    .i_data(i_data),
    .o_ready(),
    .i_ready(w_lb_rd_ready[3]),
    .o_data(w_lb_data_out[3]),
    .o_valid()
  );

  // FIFO
  fifo_axi # (
    .p_width(8),
    .p_depth(16),
    .p_full_threshold(8)
  )
  fifo_axi_inst (
    .i_clk(i_clk),
    .i_reset(!i_reset_n),
    .i_data_in(w_conv_data_out),
    .i_valid_in(w_conv_m_valid),
    .o_ready_in(o_ready),
    .o_data_out(o_data),
    .i_ready_out(i_ready),
    .o_valid_out(o_valid)
  );

  // demux for i_valid of line buffers
  always_comb begin
    w_lb_wr_valid = 4'b0000;
    w_lb_wr_valid[w_wr_demux_slct] = i_valid;
  end

  // mux for i_data of convolution
  always_comb
    case (w_rd_mux_slct)
      2'b00: w_conv_data_in = {w_lb_data_out[2], w_lb_data_out[1], w_lb_data_out[0]};
      2'b01: w_conv_data_in = {w_lb_data_out[3], w_lb_data_out[2], w_lb_data_out[1]};
      2'b10: w_conv_data_in = {w_lb_data_out[0], w_lb_data_out[3], w_lb_data_out[2]};
      2'b11: w_conv_data_in = {w_lb_data_out[1], w_lb_data_out[0], w_lb_data_out[3]};
    endcase

  always_comb begin
    case (w_rd_mux_slct)
      2'b00: w_lb_rd_ready = {w_control_lb_rd_ready, w_control_lb_rd_ready, w_control_lb_rd_ready, 1'b0};
      2'b01: w_lb_rd_ready = {1'b0, w_control_lb_rd_ready, w_control_lb_rd_ready, w_control_lb_rd_ready};
      2'b10: w_lb_rd_ready = {w_control_lb_rd_ready, 1'b0, w_control_lb_rd_ready, w_control_lb_rd_ready};
      2'b11: w_lb_rd_ready = {w_control_lb_rd_ready, w_control_lb_rd_ready, 1'b0, w_control_lb_rd_ready};
    endcase
  end

endmodule