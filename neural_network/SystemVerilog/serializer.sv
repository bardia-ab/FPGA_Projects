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
  logic [2:0] r_wait_cntr;

  // buffer
  logic [N_PARALLEL * DATA_WIDTH - 1:0] r_buffer;

  // FSM
  typedef enum {s_IDLE, s_SEND, s_WAIT, s_BIAS, s_END, s_WAIT2} t_states;
  t_states r_state = s_IDLE;

  always_ff @(posedge i_clk)
    if (i_reset)
    begin
      r_state <= s_IDLE;
      r_cntr <= N_PARALLEL - 1;
      r_wait_cntr <= '{default:1};
      r_ready <= 1'b1;
      r_valid <= 1'b0;
    end
    else
    begin
      // default
      r_valid <= 1'b0;
      r_data <= r_buffer[DATA_WIDTH - 1:0];

      case (r_state)
        s_IDLE:
        begin
          r_ready <= 1'b1;

          if (i_valid)
          begin
            r_buffer <= i_data;
            r_ready <= 1'b0;
            r_state <= s_SEND;
          end
        end

        s_SEND:
        begin
          if (i_ready)
          begin
            r_cntr <= r_cntr - 1;
            r_valid <= 1'b1;
            r_buffer <= r_buffer >> DATA_WIDTH;
            r_state <= s_WAIT;
          end
          else
          begin
            r_cntr <= r_cntr;
            r_buffer <= r_buffer;
            r_state <= s_SEND;
          end
        end
        s_WAIT:
        begin
          if (!i_ready)
          begin
            r_state <= s_SEND;

            if (r_cntr == 0)
            begin
              r_cntr <= N_PARALLEL - 1;
              r_state <= s_BIAS;
            end

          end
          else
            r_state <= s_WAIT;
        end
        s_BIAS:
        begin
          if (i_ready)
          begin
            r_valid <= 1'b1;
            r_state <= s_END;
          end

        end

        s_END:
        begin
          r_state <= s_END;

          if (!i_ready)
            r_state <= s_WAIT2;

        end

        s_WAIT2: begin
        if (r_wait_cntr > 0)
            r_wait_cntr <= r_wait_cntr - 1;
          else
          begin
            r_wait_cntr <= '{default:1};
            r_ready <= 1'b1;
            r_state <= s_IDLE;
          end
        end
        default:
          r_state <= s_IDLE;
      endcase
    end

  // output assignemnts
  assign o_ready = r_ready;
  assign o_data = r_data;
  assign o_valid = r_valid;

endmodule
