`timescale 1ns / 1ps

`include "configuration.svh"

module neuron #(parameter LAYER_ID = 0, NEURON_ID = 1, NUM_WEIGHT = 784, DATA_WIDTH = 16, SIGMOID_SIZE = 5, ACT_TYPE = "sigmoid", WEIGHT_FILE = "", BIAS_FILE = "", SIGMOID_FILE = "") (
  input i_clk,
  input i_reset,
  input [DATA_WIDTH - 1:0] i_input,
  input i_input_valid,
  output o_input_ready,
  input [31:0] i_weight,
  input i_weight_valid,
  input [31:0] i_bias,
  input i_bias_valid,
  input [31:0] i_layer_id,
  input [31:0] i_neuron_id,
  output [DATA_WIDTH - 1:0] o_output,
  output o_output_valid
);

  localparam ADDR_WIDTH = $clog2(NUM_WEIGHT);

  // MAC signals
  logic [DATA_WIDTH - 1:0] r_input;
  logic [2 * DATA_WIDTH - 1:0] r_bias;
  logic [31:0] w_bias_mem [0:0];
  logic [2 * DATA_WIDTH - 1:0] r_mult;
  logic [2 * DATA_WIDTH - 1:0] r_sum;
  logic [2 * DATA_WIDTH - 1:0] w_comb_add;
  logic [2 * DATA_WIDTH - 1:0] w_bias_add;

  // weight memory signals
  logic [ADDR_WIDTH - 1:0] r_wm_waddr;
  logic r_wm_wen;
  logic [DATA_WIDTH - 1:0] r_weight_in;
  logic r_wm_wvalid;
  logic [ADDR_WIDTH - 1:0] r_wm_raddr;
  logic r_wm_ren;
  logic [DATA_WIDTH - 1:0] r_weight_out;
  logic r_wm_rvalid;
  logic w_overflow_comb;
  logic w_overflow_bias;
  logic w_underflow_comb;
  logic w_underflow_bias;

  logic r_input_ready;
  logic r_output_valid;

  // FSM
  typedef enum {s_INPUT_VALID, s_MULTIPLICATION, s_ACCUMULATION} t_states;
  t_states r_state = s_INPUT_VALID;
  

  /**************************** Weight Memory ***************************/
  // write address
  always_ff @(posedge i_clk)
    if (i_reset) begin
      r_wm_waddr <= '{default: 1'b1};
      r_wm_wen <= 1'b0;
    end
    else begin
      r_wm_wen <= 1'b0;

      if (i_weight_valid & i_layer_id == LAYER_ID && i_neuron_id == NEURON_ID) begin
        r_wm_waddr <= r_wm_waddr + 1;
        r_weight_in <= i_weight;
        r_wm_wen <= 1'b1;
      end
    end

  // bias
  `ifdef PRETRAINED
    initial begin
      $readmemb(BIAS_FILE, w_bias_mem);
			$display("pretrained!!!");
		end

    always_ff @(posedge i_clk)
      r_bias <= {w_bias_mem[0][DATA_WIDTH - 1:0], {DATA_WIDTH{1'b0}}};

  `else
    always_ff @(posedge i_clk)
    if (i_bias_valid)
      r_bias <= {i_bias[DATA_WIDTH - 1:0], {DATA_WIDTH{1'b0}}};

  `endif
  

  weight_memory # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .WEIGHT_FILE(WEIGHT_FILE)
  )
  weight_memory_inst (
    .i_clk(i_clk),
    .i_wen(r_wm_wen),
    .i_data(r_weight_in),
    .o_wvalid(r_wm_wvalid),
    .i_waddr(r_wm_waddr),
    .i_ren(r_wm_ren),
    .i_raddr(r_wm_raddr),
    .o_data(r_weight_out),
    .o_rvalid(r_wm_rvalid)
  );

  /**************************** MAC ***************************/
  always_ff @(posedge i_clk)
    if (i_reset) begin
      r_state <= s_INPUT_VALID;
      r_wm_ren <= 1'b0;
      r_wm_raddr <= '{default:1};
      r_sum <= 0;
      r_output_valid <= 1'b1;
    end
    else begin
      // default
      r_wm_ren <= 1'b0;
      r_input_ready <= 1'b0;

      case (r_state)
        s_INPUT_VALID: begin
          r_input_ready <= 1'b1;

          if (i_input_valid & i_layer_id == LAYER_ID && i_neuron_id == NEURON_ID) begin
            r_output_valid <= 1'b0;
            r_input <= i_input;
            r_wm_raddr <= r_wm_raddr + 1;
            r_wm_ren <= 1'b1;
            r_state <= s_MULTIPLICATION;
          end
        end

        s_MULTIPLICATION: begin            
          if (r_wm_rvalid) begin
            r_mult <= $signed(r_weight_out) * $signed(r_input);
            r_state <= s_ACCUMULATION;
          end
        end

        s_ACCUMULATION: begin          
          if (r_wm_raddr < NUM_WEIGHT) begin
            //r_input_ready <= 1'b1;
            r_state <= s_INPUT_VALID;

            if (w_overflow_comb)
              r_sum <= {1'b0, {(2 * DATA_WIDTH - 1){1'b1}}};
            else if (w_underflow_comb)
              r_sum <= {1'b1, {(2 * DATA_WIDTH - 1){1'b0}}};
            else
              r_sum <= w_comb_add;
          end
          else begin
            r_state <= s_INPUT_VALID;
            r_output_valid <= 1'b1;

            if (w_overflow_bias)
              r_sum <= {1'b0, {(2 * DATA_WIDTH - 1){1'b1}}};
            else if (w_underflow_bias)
              r_sum <= {1'b1, {(2 * DATA_WIDTH - 1){1'b0}}};
            else
              r_sum <= w_bias_add;
          end
        end
        default: 
          r_state <= s_INPUT_VALID;

      endcase
    end

  // adders
  assign w_comb_add = r_sum + r_mult;
  assign w_bias_add = r_sum + r_bias;

  // check overflow & underflow
  assign w_overflow_comb = !r_sum[2 * DATA_WIDTH - 1] & !r_mult[2 * DATA_WIDTH - 1] & w_comb_add[2 * DATA_WIDTH - 1];
  assign w_underflow_comb = r_sum[2 * DATA_WIDTH - 1] & r_mult[2 * DATA_WIDTH - 1] & !w_comb_add[2 * DATA_WIDTH - 1];
  assign w_overflow_bias = !r_sum[2 * DATA_WIDTH - 1] & !r_bias[2 * DATA_WIDTH - 1] & w_bias_add[2 * DATA_WIDTH - 1];
  assign w_underflow_bias = r_sum[2 * DATA_WIDTH - 1] & r_bias[2 * DATA_WIDTH - 1] & !w_bias_add[2 * DATA_WIDTH - 1];

  /**************************** Activation Function ***************************/
  generate
    if (ACT_TYPE == "sigmoid") begin
      sigmoid_rom # (
        .ADDR_WIDTH(SIGMOID_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .MIF_FILE(SIGMOID_FILE)
      )
      sigmoid_rom_inst (
        .i_clk(i_clk),
        .i_addr(r_sum[2 * DATA_WIDTH - 1 -: SIGMOID_SIZE]),
        .o_out(o_output)
      );
    end
    else begin
      
    end
  endgenerate

  // output assignment
  assign o_input_ready = r_input_ready;
  assign o_output_valid = r_output_valid;

endmodule