library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity uart_tb is
  generic (runner_cfg : string);
end uart_tb;

architecture sim of uart_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  -- UART TX signals
  signal busy_tx : std_logic;
  signal tx : std_logic;
  signal send : std_logic := '0';
  signal data_tx : std_logic_vector(7 downto 0) := x"00";

  -- UART RX signals
  signal valid_rx : std_logic;
  signal busy_rx : std_logic;
  signal data_rx : std_logic_vector(7 downto 0);

  -- UART BFM
  signal busy_bfm_rx : std_logic;
  signal rx : std_logic := '1';
  signal valid_bfm : std_logic;
  signal data_bfm_rx : std_logic_vector(7 downto 0);

  signal busy_bfm_tx : std_logic;
  signal send_bfm : std_logic;
  signal data_bfm_tx : std_logic_vector(7 downto 0);

begin

  clk <= not clk after clk_period / 2;

  UART_TX_INST : entity work.uart_tx(rtl)
  generic map(
    g_Parity		=> "0",
    g_N_Bits		=> 8,
    g_Baud_Rate	=> 115200,
    g_Frequency	=> 1e8
  )
  port map (
    i_Clk			=> clk,
    i_Send		=> send,
    i_Data_In	=> data_tx,
    o_Busy		=> busy_tx,
    o_Tx			=> tx
  );

  UART_RX_INST  : entity work.uart_rx(rtl)
  generic map(
    g_Parity		=> "0",
    g_N_Bits		=> 8,
    g_Baud_Rate	=> 115200,
    g_Frequency	=> 1e8
  )
  port map (
    i_Clk			  => clk,
    i_Rx			  => rx,
    o_Valid		  => valid_rx,
    o_Busy		  => busy_rx,
    o_Data_Out  => data_rx
  );

  UART_BFM_INST : entity work.uart_bfm(beh)
    generic map(g_baud_rate => 115200)
    port map(
      i_data_tx => data_bfm_tx,
      i_send    => send_bfm,
      o_busy_tx => busy_bfm_tx,
      o_tx      => rx, 
      i_rx      => tx,
      o_busy_rx => busy_bfm_rx,
      o_valid   => valid_bfm,
      o_data_rx => data_bfm_rx        
    );

  SEQUENCER_PROC : process
  begin
    
    -- setup test runner
    test_runner_setup(runner, runner_cfg);

    if run("test_uart_tx") then
      send <= '0';
      data_tx <= x"00";
      wait for clk_period;

      for i in 0 to 9 loop
        if (busy_tx = '0') then
          data_tx <= std_logic_vector(unsigned(data_tx) + 1);
          wait for clk_period;
          info("Transmitted data: " & to_string(data_tx));

          send <= '1';
          wait for clk_period;

          send <= '0';
          wait for 0 ns;

        end if;

        wait until falling_edge(busy_tx);
        wait for clk_period;

        assert data_bfm_rx = data_tx
        report "invalid data received: " & to_string(data_bfm_rx)
        severity failure;

      end loop;

      info("UART_Tx tested successfully!!!");

    elsif run("test_uart_rx") then
      send_bfm <= '0';
      data_bfm_tx <= x"00";
      wait for clk_period;

      for i in 0 to 10 loop
        if (busy_rx = '0') then
          send_bfm <= '1';
          wait for clk_period;

          send_bfm <= '0';
          wait for clk_period;

        end if;

        wait until valid_rx = '1';
        info("Transmitted data: " & to_string(data_bfm_tx));

        assert data_bfm_tx = data_rx
        report "received data is invalid: " & to_string(data_rx)
        severity failure;

        data_bfm_tx <= std_logic_vector(unsigned(data_bfm_tx) + 1);
        wait until busy_bfm_tx = '0';

      end loop;
    end if;

    info("UART_Rx tested successfully!!!");

    -- cleanup test runner
    test_runner_cleanup(runner);

  end process;

end architecture;