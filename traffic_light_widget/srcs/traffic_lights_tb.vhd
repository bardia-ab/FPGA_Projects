library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_lights_tb is
end entity;

architecture sim of traffic_lights_tb is

  -- We're slowing down the clock to speed up simulation time
  constant clk_hz : integer := 100; -- 100 Hz
  constant clk_period : time := 1000 ms / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal north_red : std_logic;
  signal north_yellow : std_logic;
  signal north_green : std_logic;
  signal west_red : std_logic;
  signal west_yellow : std_logic;
  signal west_green : std_logic;

begin

  -- The Device Under Test (DUT)
  DUT : entity work.traffic_lights(rtl)
  generic map(clk_hz => clk_hz)
  port map(
    clk  => clk,
    rst => rst,
    north_red => north_red,
    north_yellow => north_yellow,
    north_green => north_green,
    west_red => west_red,
    west_yellow => west_yellow,
    west_green => west_green
  );

  -- Process for generating the clock
  clk <= not clk after clk_period / 2;

  -- Testbench sequence
  SEQUENCER_PROC :process is
  begin
      wait until rising_edge(clk);
      wait until rising_edge(clk);

      -- Take the DUT out of reset
      rst <= '0';

      wait;
  end process;

end architecture;