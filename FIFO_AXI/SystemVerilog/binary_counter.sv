module binary_counter
# (
  parameter p_up_count = 1'b1,
  parameter p_init_value = 0,
  parameter p_width = 8
)
(
  input logic i_clk,
  input logic i_reset,
  input logic i_ce,
  input logic i_sclr,
  output logic [p_width - 1:0] o_count
);

  logic [p_width - 1:0] r_cntr;

  function logic [p_width - 1:0] count (input bit up_count);
    if (up_count == 1'b1)
      return r_cntr + 1;
    else
      return r_cntr - 1;
  endfunction

  // FSM
  always_ff @(posedge i_clk, posedge i_reset)
      if (i_reset)
        r_cntr <= p_init_value;
      else begin
        if (i_ce)
          r_cntr <= count(p_up_count);

        if (i_sclr)
          r_cntr <= p_init_value;
      end

  assign o_count = r_cntr;

endmodule