module fifo_axi 
# (
  parameter p_width = 8,
  parameter p_depth = 32,
  parameter p_full_threshold = 0
) 
(
  input logic i_clk,
  input logic i_reset,

  // AXI input interfece
  input logic [p_width - 1:0] i_data_in,
  input logic i_valid_in,
  output logic o_ready_in,

  // AXI output reference
  output logic [p_width - 1:0] o_data_out,
  input logic i_ready_out,
  output logic o_valid_out
);

  // states
  typedef enum {s_empty, s_partial, s_full} t_states;
  t_states r_state;

  // memory
  logic [p_width - 1:0] r_mem [p_depth - 1:0] = '{default: 0};
  logic w_mem_we;
  logic [p_width - 1:0] r_data_out;

  // pointers
  logic [$clog2(p_depth) - 1:0] r_head;
  logic [$clog2(p_depth) - 1:0] r_tail;
  logic r_head_ce;
  logic r_tail_ce;
  logic [$clog2(p_depth) - 1:0] w_full_threshold;
  
  // AXI
  logic r_ready_in = 1'b1;
  logic r_valid_out = 1'b0;

  // FSM
  always_ff @(posedge i_clk)
  if (i_reset) begin
    r_state <= s_empty;
    r_ready_in <= 1'b1;
    r_valid_out <= 1'b0;
  end

  else begin
    case (r_state)
      s_empty: begin
        r_ready_in <= 1'b1;
        r_valid_out <= 1'b0;
        
        if (i_valid_in == 1'b1)
          r_state <= s_partial;
        
      end
      s_partial: begin
        r_ready_in <= 1'b1;
        r_valid_out <= 1'b1;

        if ((r_head == r_tail + 1) && r_tail_ce == 1'b1) begin
          r_ready_in <= 1'b1;
          r_valid_out <= 1'b0;
          r_state <= s_empty;
        end

        if ((r_tail == (r_head + 1 + p_depth - w_full_threshold)) && r_head_ce == 1'b1) begin
          r_ready_in <= 1'b0;
          r_valid_out <= 1'b1;
          r_state <= s_full;
        end
      end

      s_full: begin
        r_ready_in <= 1'b0;
        r_valid_out <= 1'b1;

        if (i_ready_out == 1'b1) begin
          r_ready_in <= 1'b1;
          r_state <= s_partial;
        end
      end

      default:  ;
    endcase
  end

  // head counter
  binary_counter # (
    .p_up_count(1'b1),
    .p_init_value(0),
    .p_width($clog2(p_depth))
  )
  head_counter (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_ce(r_head_ce),
    .i_sclr(1'b0),
    .o_count(r_head)
  );

  // tail counter
  binary_counter # (
    .p_up_count(1'b1),
    .p_init_value(0),
    .p_width($clog2(p_depth))
  )
  tail_counter (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_ce(r_tail_ce),
    .i_sclr(1'b0),
    .o_count(r_tail)
  );

  // BRAM
  always_ff @(posedge i_clk) begin
    if (w_mem_we)
      r_mem[r_head] <= i_data_in;

    r_data_out <= r_mem[r_tail];
  end

  assign w_mem_we = i_valid_in & r_ready_in;
  assign r_head_ce = i_valid_in & r_ready_in;
  assign r_tail_ce = i_ready_out & r_valid_out;
  assign w_full_threshold = (p_full_threshold > 0) ? p_full_threshold : p_depth;

  // output assignments
  assign o_ready_in = r_ready_in;
  assign o_valid_out = r_valid_out;
  assign o_data_out = r_data_out;

endmodule
