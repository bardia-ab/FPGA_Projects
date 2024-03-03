library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;
---------------------------------
entity riscv is
  generic(g_program_hex_file    :   string);
  port (
    i_clk           : in std_logic;
    i_rst           : in std_logic;
    o_uart_tx_data  : out std_logic_vector(7 downto 0);
    o_uart_tx_valid : out std_logic
  );
end riscv;
---------------------------------
architecture str of riscv is

  -- Decoder Signals
  signal  w_en_decoder  :   std_logic;
  signal  w_op          :   t_op;
  signal  w_rd          :   std_logic_vector(4 downto 0);
  signal  w_rs_1        :   std_logic_vector(4 downto 0);
  signal  w_rs_2        :   std_logic_vector(4 downto 0);
  signal  w_imm_i       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_imm_s       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_imm_b       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_imm_u       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_imm_j       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);

  -- Memory Signals
  signal  w_dout_mem    : std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_din_mem     : std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_wr_en_mem   : std_logic;
  signal  w_addr_mem    : std_logic_vector(c_ram_word_addr_bits - 1 downto 0);
  signal  w_byte_addr_mem : std_logic_vector(c_ram_byte_addr_bits - 1 downto 0);

  -- ALU Signals
  signal  w_op_alu      :   t_alu_op;
  signal  w_res         : std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_src_1       : std_logic_vector(c_ram_word_width_bits - 1 downto 0);
  signal  w_src_2       : std_logic_vector(c_ram_word_width_bits - 1 downto 0);



begin

  Controller: entity work.control(rtl)
    port map(
      i_clk           => i_clk,     
      i_rst           => i_rst,     
      i_op            => w_op,     
      i_rd            => w_rd,     
      i_rs_1          => w_rs_1,     
      i_rs_2          => w_rs_2,     
      i_imm_i         => w_imm_i,     
      i_imm_s         => w_imm_s,     
      i_imm_b         => w_imm_b,     
      i_imm_u         => w_imm_u,     
      i_imm_j         => w_imm_j,     
      o_en_decoder    => w_en_decoder,     
      i_res_alu       => w_res,     
      o_op_alu        => w_op_alu,     
      o_src_1_alu     => w_src_1,     
      o_src_2_alu     => w_src_2,     
      i_dout_ram      => w_dout_mem,     
      o_wr_en_ram     => w_wr_en_mem,     
      o_byte_addr_ram => w_byte_addr_mem,     
      o_din_ram       => w_din_mem,     
      o_uart_tx_data  => o_uart_tx_data,     
      o_uart_tx_valid => o_uart_tx_valid     
    );
  
  Memory: entity work.mem(rtl)
    generic map(g_program_hex_file => g_program_hex_file)
    port map(
      i_clk   => i_clk,
      i_wr_en => w_wr_en_mem,
      i_addr  => w_addr_mem,
      i_din   => w_din_mem,
      o_dout  => w_dout_mem
    );

  Decode: entity work.decoder(rtl)
    port map(
      i_clk       => i_clk,  
      i_rst       => i_rst,  
      i_en        => w_en_decoder,  
      i_ram_dout  => w_dout_mem,  
      o_op        => w_op,  
      o_rd        => w_rd,  
      o_rs_1      => w_rs_1,  
      o_rs_2      => w_rs_2,  
      o_imm_i     => w_imm_i,  
      o_imm_s     => w_imm_s,  
      o_imm_b     => w_imm_b,  
      o_imm_u     => w_imm_u,  
      o_imm_j     => w_imm_j  
    );

  ALU:  entity work.alu(rtl)
    port map(
      i_op    => w_op_alu,
      i_src_1 => w_src_1,
      i_src_2 => w_src_2,
      o_res   => w_res
    );

    w_addr_mem <= w_byte_addr_mem(w_byte_addr_mem'high downto 2);

end architecture;