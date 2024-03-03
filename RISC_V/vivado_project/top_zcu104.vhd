library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------
entity top_zcu104 is
  port (
    i_clk_p : in  std_logic;
    i_clk_n : in  std_logic;
    i_rst   : in  std_logic;
    i_Rx    : in  std_logic;
    o_Tx    : out std_logic
  );
end top_zcu104;
---------------------------------
architecture str of top_zcu104 is

	component clk_wiz_0
		port (	
			Clk_out1   : out    std_logic;
			clk_in1_p  : in     std_logic;
			clk_in1_n  : in     std_logic
		);
	end component;

  signal  w_clk_100 : std_logic;

begin

  MMCM_0 : clk_wiz_0
		port map ( 
			Clk_out1 	  => w_clk_100,
			clk_in1_p 	=> i_clk_p,
			clk_in1_n 	=> i_clk_n
		);

  TOP : entity work.top(str)
    generic map (
      clk_hz => 100e6,
      baud_rate => 115200,
      rst_in_active_value => '1',
      program_hex_file => "..\program\hello_world.hex"
    )
    port map (
      clk => w_clk_100,
      rst_async => i_rst,
      uart_rx => i_Rx,
      uart_tx => o_Tx,
      uart_rx_fifo_full => open,
      uart_tx_fifo_full => open,
      uart_rx_stop_bit_error => open 
    );

end architecture;