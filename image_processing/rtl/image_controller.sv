`timescale 1ns / 1ps

module image_controller # (parameter LINE_WIDTH = 512)(
  input i_clk,
  input i_reset,
  input i_valid,
  output [1:0] o_wr_demux_slct,
  output [1:0] o_rd_mux_slct,
  output o_lb_ready,
  output o_intr
);

  // signals
  logic [1:0] r_wr_demux_slct;
  logic [1:0] r_rd_mux_slct;
  logic r_lb_ready = 1'b0;
  logic r_intr;

  // counters signals
  logic [11: 0] r_pixel_cntr = 0;
  logic [$clog2(LINE_WIDTH) - 1:0] r_wr_ptr;
  logic [$clog2(LINE_WIDTH) - 1:0] r_rd_ptr;

  // FSM
  typedef enum {s_IDLE, s_READ} t_states;
  t_states r_state = s_IDLE;

  /***************** counters *****************/
  // pixel counter
  always_ff @(posedge i_clk) begin
    if (i_reset)
      r_pixel_cntr <= 0;
    else if (i_valid && !r_lb_ready)
      r_pixel_cntr <= r_pixel_cntr + 1;
    else if (!i_valid && r_lb_ready)
      r_pixel_cntr <= r_pixel_cntr - 1;
  end

  // wr_ptr & wr_demux_slct
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      r_wr_ptr <= 0;
      r_wr_demux_slct <= 2'b00;
    end
    else if (r_wr_ptr == (LINE_WIDTH - 1) && i_valid) begin
      r_wr_ptr <= 0;
      r_wr_demux_slct <= r_wr_demux_slct + 1;
    end
    else if (i_valid) begin
        r_wr_ptr <= r_wr_ptr + 1;
    end
  end

  // rd_ptr & rd_mux_slct
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      r_rd_ptr <= 0;
      r_rd_mux_slct <= 2'b00;
    end
    else if (r_rd_ptr == (LINE_WIDTH - 1) && r_lb_ready) begin
      r_rd_ptr <= 0;
      r_rd_mux_slct <= r_rd_mux_slct + 1;
    end
    else if (r_lb_ready) begin
        r_rd_ptr <= r_rd_ptr + 1;
		end
  end

  /***************** line buffer read *****************/
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      r_state <= s_IDLE;
      r_lb_ready <= 1'b0;
      r_intr <= 1'b0;
    end
    else
      case (r_state)
        s_IDLE:
          if (r_pixel_cntr >= 3 * LINE_WIDTH) begin
            r_lb_ready <= 1'b1;
            r_intr <= 1'b0;
            r_state <= s_READ;
          end

        s_READ:
        if (r_rd_ptr == (LINE_WIDTH - 1)) begin
          r_state <= s_IDLE;
          r_lb_ready <= 1'b0;
          r_intr <= 1'b1;
        end
      endcase
  end

  // output assignments
  assign o_wr_demux_slct = r_wr_demux_slct;
  assign o_rd_mux_slct = r_rd_mux_slct;
  assign o_lb_ready = r_lb_ready;
  assign o_intr = r_intr;

endmodule