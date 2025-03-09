`timescale 1ns / 1 ps

module line_buffer #(parameter LINE_WIDTH = 512)(
  input i_clk,
  input i_reset,
  // slave AXI interface
  input i_valid,
  input [7:0] i_data,
  output o_ready,
  // master AXI interface
  input i_ready,
  output [23:0] o_data,
  output o_valid
);

  // signals
  logic r_s_axis_ready = 1'b1;
  logic [23:0] r_m_axis_data;
  logic r_m_axis_valid = 1'b0;

  // buffer signals
  logic [7:0] r_line [0:LINE_WIDTH - 1];
  logic r_line_wr_complete = 1'b0;
  logic r_line_rd_complete = 1'b0;
  logic [$clog2(LINE_WIDTH) - 1:0] r_wr_ptr = 0;
  logic [$clog2(LINE_WIDTH) - 1:0] r_rd_ptr = 0;

  /**************** writing to line buffer ******************/
  // wr_ptr
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      r_wr_ptr <= 0;
      r_line_wr_complete <= 1'b0;
    end
    else if (i_valid && r_s_axis_ready) begin
      r_line_wr_complete <= 1'b0;
      r_wr_ptr <= r_wr_ptr + 1;

      if (r_wr_ptr == (LINE_WIDTH - 1)) begin
        r_wr_ptr <= 0;
        r_line_wr_complete <= 1'b1;
      end
    end
  end

  // r_s_axis_ready
  always_ff @(posedge i_clk) begin
    if (i_reset)
      r_s_axis_ready <= 1'b1;
    else if (r_wr_ptr == (LINE_WIDTH - 1) && i_valid)
      r_s_axis_ready <= 1'b0;
    else if (r_line_wr_complete && !r_line_rd_complete)
      r_s_axis_ready <= 1'b0;
    else
      r_s_axis_ready <= 1'b1;
  end

  // write to line
  always_ff @(posedge i_clk)
    if (i_valid && r_s_axis_ready)
      r_line[r_wr_ptr] <= i_data;

  /**************** reading from line buffer ******************/
  // rd_ptr
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      r_rd_ptr <= 0;
      r_line_rd_complete <= 1'b0;
    end
    else if (i_ready) begin
      r_rd_ptr <= r_rd_ptr + 1;
      r_line_rd_complete <= 1'b0;

      if (r_rd_ptr == (LINE_WIDTH - 1)) begin
        r_rd_ptr <= 0;
        r_line_rd_complete <= 1'b1;
      end
    end
  end

  // r_m_axis_valid
  always_ff @(posedge i_clk) begin
    if (i_reset)
      r_m_axis_valid  <= 1'b0;
    else if ((r_wr_ptr - r_rd_ptr >= 3) || (r_line_wr_complete && !r_line_rd_complete))
      r_m_axis_valid  <= 1'b1;
    else
      r_m_axis_valid  <= 1'b0;
  end

  // read from line
  always_comb
    if (i_ready && r_m_axis_valid)
      if (LINE_WIDTH - r_rd_ptr >= 2)
        r_m_axis_data <= {r_line[r_rd_ptr + 2], r_line[r_rd_ptr + 1], r_line[r_rd_ptr]};
      else if (r_wr_ptr - r_rd_ptr == 1)
        r_m_axis_data <= {8'h00, r_line[r_rd_ptr + 1], r_line[r_rd_ptr]};
      else
        r_m_axis_data <= {8'h00, 8'h00, r_line[r_rd_ptr]};
    else
      r_m_axis_data <= 24'h000000;
      
  // output assignments
  assign o_ready = r_s_axis_ready;
  assign o_valid = r_m_axis_valid;
  assign o_data = r_m_axis_data;

endmodule