library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_bfm is
  generic (g_baud_rate  : positive);
  port (
    -- UART Tx Interface
    i_data_tx : in  std_logic_vector(7 downto 0);
    i_send    : in  std_logic;
    o_busy_tx : out std_logic;
    o_tx      : out std_logic;

    -- UART Rx Interface
    i_rx      : in  std_logic;
    o_busy_rx : out std_logic;
    o_valid   : out std_logic;
    o_data_rx : out std_logic_vector(7 downto 0)

  );
end uart_bfm;

architecture beh of uart_bfm is

  constant  c_data_width  : time := 1 sec / real(g_baud_rate);

begin

  PROC_RX : process
  begin
    o_busy_rx <= '0';
    -- o_data_rx <= x"00";

    -- start receiving
    report "i_rx at idle: " & to_string(i_rx);
    wait until i_rx = '0';

    -- move the sampling point half a cycle
    o_busy_rx <= '1';
    wait for (c_data_width * 1.5);

    for i in 0 to 7 loop
      o_data_rx(i) <= i_rx;
      report "bit " & to_string(i) & ": " & to_string(i_rx);
      wait for c_data_width;
      
    end loop;

    -- check stop bit
    assert i_rx = '1'
      report "Invalid Stop Bit: " & to_string(i_rx)
      severity failure;

    o_valid <= '1';
    report "received data: " & to_string(o_data_rx);
    wait for 0 ns;

  end process;
  
  PROC_TX : process
  begin
    -- idle
    o_busy_tx <= '0';
    o_tx <= '1';

    wait until rising_edge(i_send);

    -- start bit
    o_busy_tx <= '1';
    o_tx <= '0';
    wait for c_data_width;

    -- data transmission
    for i in 0 to 7 loop
      report "data to be transmit: " & to_string(i_data_tx);
      o_tx <= i_data_tx(i);
      wait for c_data_width;
      report "bit " & to_string(i) & ": " & to_string(o_tx);
    end loop;

    -- stop bit
    o_tx <= '1';
    wait for c_data_width;

  end process;

end architecture;