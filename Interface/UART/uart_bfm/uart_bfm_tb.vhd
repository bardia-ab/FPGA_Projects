library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity uart_bfm_tb is
  generic(runner_cfg  : string);
end uart_bfm_tb;

architecture sim of uart_bfm_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;
  constant c_baud_rate : positive := 115200;
  constant  c_data_width  : time := 1 sec / real(c_baud_rate);

  signal busy_tx : std_logic;
  signal tx : std_logic;
  signal send : std_logic := '0';
  signal data_tx : std_logic_vector(7 downto 0) := x"00";

  signal busy_rx : std_logic;
  signal rx : std_logic := '1';
  signal valid : std_logic;
  signal data_rx : std_logic_vector(7 downto 0);

begin

  -- clk <= not clk after clk_period / 2;

  DUT : entity work.uart_bfm(beh)
  generic map (g_baud_rate => c_baud_rate)
  port map (
    i_data_tx => data_tx,
    i_send    => send,
    o_busy_tx => busy_tx,
    o_tx      => tx, 
    i_rx      => rx,
    o_busy_rx => busy_rx,
    o_valid   => valid,
    o_data_rx => data_rx        
  );

  SEQUENCER_PROC : process
    variable v_data : std_logic_vector(7 downto 0);
    variable v_packet : std_logic_vector(9 downto 0);
  begin
    -- vunit setup
    test_runner_setup(runner, runner_cfg);

    if run("test_tx") then
      send <= '1';
      wait for clk_period;
      send <= '0';

      for i in 0 to 5 loop
        wait until busy_tx = '0';
        data_tx <= std_logic_vector(unsigned(data_tx) + 1);
        send <= '1';
        wait for clk_period;
        send <= '0';

      end loop;
    
    elsif run("test_rx") then

      for j in 0 to 5 loop
        v_data := std_logic_vector(to_unsigned(j, 8));
        v_packet := '1' & v_data & '0';
        info("data to be transmit: " & to_string(v_data));
        info("Packet: " & to_string(v_packet));
        -- data transmission
        for i in 0 to 9 loop
          rx <= v_packet(i);
          wait for 0 ns;
          info("Transmitted bit: " & to_string(rx));

          wait for c_data_width;
        end loop;

        wait for clk_period * 10;

      end loop;

    end if;

    -- vunit cleanup
    test_runner_cleanup(runner);
  end process;


end architecture;