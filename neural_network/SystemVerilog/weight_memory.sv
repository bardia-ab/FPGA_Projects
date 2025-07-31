`timescale 1ns / 1ps

`include "configuration.svh"

module weight_memory #(parameter DATA_WIDTH = 16, ADDR_WIDTH = 10, WEIGHT_FILE = "") (
  input i_clk,
  // write interface
  input i_wen,
  input [DATA_WIDTH - 1:0] i_data,
  input [ADDR_WIDTH - 1:0] i_waddr,
  output o_wready,
  // read interface
  input i_ren,
  input [ADDR_WIDTH - 1:0] i_raddr,
  output [DATA_WIDTH - 1:0] o_data,
  output o_rvalid
);

  // signals
  logic [DATA_WIDTH - 1:0] r_data;
  logic [DATA_WIDTH - 1:0] r_mem [0: 2 ** ADDR_WIDTH];
  logic r_wready;
  logic r_rvalid;

  `ifdef PRETRAINED
    initial
      $readmemb(WEIGHT_FILE, r_mem);
  `else
    always_ff @(posedge i_clk) begin
      r_wready <= 1'b1;

      if (i_wen) begin
        r_mem[i_waddr] <= i_data;
        // r_wready <= 1'b0;
      end
    end
  `endif

  always_ff @(posedge i_clk) begin
    r_rvalid <= 1'b0;

    if (i_ren) begin
      r_data <= r_mem[i_raddr];
      r_rvalid <= 1'b1;
    end
  end

  // output assignments
  assign o_data = r_data;
  assign o_wready = r_wready;
  assign o_rvalid = r_rvalid;

endmodule