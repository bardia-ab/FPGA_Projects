`timescale 1ns / 1ps

module sigmoid_rom #(parameter ADDR_WIDTH = 10, DATA_WIDTH = 16, MIF_FILE = "") (
  input i_clk,
  input [ADDR_WIDTH - 1:0] i_addr,
  output [DATA_WIDTH - 1:0] o_out
);

  logic [DATA_WIDTH - 1:0] r_rom [0: 2 ** ADDR_WIDTH - 1];
  logic [ADDR_WIDTH - 1:0] r_addr;
  logic [DATA_WIDTH - 1:0] r_out;

  initial begin
    $readmemb(MIF_FILE, r_rom);
  end

  assign r_addr = i_addr + 2 ** (ADDR_WIDTH - 1);

  always_ff @(posedge i_clk) begin
    r_out <= r_rom[r_addr];
  end

  assign o_out = r_out;

endmodule