`timescale 1ns / 1ps

module serializer # (parameter N_PARALLEL = 30, DATA_WIDTH = 16) (
  input i_clk,
  input i_reset,
  // slave axi interface
  input [N_PARALLEL * DATA_WIDTH - 1:0] i_data,
  input i_valid,
  output o_ready,
  // master axi interface
  input i_ready,
  output [DATA_WIDTH - 1:0] o_data,
  output o_valid
);

  // axi signals
  logic r_ready;
  logic [DATA_WIDTH - 1:0] r_data;
  logic r_valid;

  // counter
  localparam COUNTER_WIDTH = $clog2(N_PARALLEL);
  logic [COUNTER_WIDTH - 1:0] r_cntr;

  // buffer
  logic [N_PARALLEL * DATA_WIDTH - 1:0] r_buffer;

  // FSM
  typedef enum {s_IDLE, s_SEND} t_states;
  t_states r_state = s_IDLE;

  always_ff @(posedge i_clk)
    if (i_reset) begin
      r_state <= s_IDLE;
      r_cntr <= N_PARALLEL - 1;
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
            r_ready <= 1'b0;
            r_state <= s_SEND;
          end
        end

        s_SEND: begin
          r_cntr <= r_cntr - 1;
          r_valid <= 1'b1;
          r_data <= r_buffer[DATA_WIDTH - 1:0];
          r_buffer <= r_buffer >> DATA_WIDTH;
          
          if (r_cntr == 0)  begin
            r_cntr <= N_PARALLEL - 1;
            r_valid <= 1'b0;
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