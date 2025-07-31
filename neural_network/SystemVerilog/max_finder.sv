`timescale 1ns / 1ps

module max_finder # (parameter N_PARALLEL = 30, DATA_WIDTH = 16) (
  input i_clk,
  input i_reset,
  // slave axi interface
  input [N_PARALLEL * DATA_WIDTH - 1:0] i_data,
  input i_valid,
  output o_ready,
  // master axi interface
  input i_ready,
  output [31:0] o_data,
  output o_valid
);

  // axi signals
  logic r_ready;
  logic [31:0] r_data;
  logic r_valid;

  // counter
  localparam COUNTER_WIDTH = $clog2(N_PARALLEL);
  logic [COUNTER_WIDTH - 1:0] r_cntr;

  // buffer
  logic [DATA_WIDTH - 1:0] r_max;
  logic [N_PARALLEL * DATA_WIDTH - 1:0] r_buffer;

  // FSM
  typedef enum {s_IDLE, s_COMPARE} t_states;
  t_states r_state = s_IDLE;

  always_ff @(posedge i_clk)
    if (i_reset) begin
      r_state <= s_IDLE;
      r_cntr <= 0;
      r_max <= 0;
      r_ready <= 1'b1;
      r_valid <= 1'b0;
    end
    else begin
      // default
      r_valid <= 1'b0;

      case (r_state)
        s_IDLE: begin
          if (i_valid) begin
            r_buffer <= i_data;
            r_max <= i_data[r_cntr * DATA_WIDTH +: DATA_WIDTH];
            r_data <= 0;
            r_cntr <= r_cntr + 1;
            r_ready <= 1'b0;
            r_state <= s_COMPARE;
          end
        end

        s_COMPARE: begin
          if (r_cntr < N_PARALLEL) begin
            r_cntr <= r_cntr + 1;
            
            if (i_data[r_cntr * DATA_WIDTH +: DATA_WIDTH] > r_max) begin
              r_max <= i_data[r_cntr * DATA_WIDTH +: DATA_WIDTH];
              r_data <= r_cntr;
            end
          end
          else begin
            r_cntr <= 0;
            r_valid <= 1'b1;
            r_state <= s_IDLE;
          end
        end

      endcase
    end

  // output assignemnts
  assign o_ready = r_ready;
  assign o_data = r_data;
  assign o_valid = r_valid;

endmodule