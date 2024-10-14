library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------
entity binary_counter is
  generic (
    g_up_count   : std_logic := '1';
    g_init_value : integer   := 0;
    g_width      : integer
  );
  port (
    i_clk   : in std_logic;
    i_reset : in std_logic;
    i_ce    : in std_logic;
    i_sclr  : in std_logic;
    o_count : out std_logic_vector(g_width - 1 downto 0)
  );
end binary_counter;
-----------------------------------
architecture rtl of binary_counter is

  signal r_cntr : unsigned(g_width - 1 downto 0) := to_unsigned(g_init_value, g_width);

  function count(
    cntr     : unsigned(g_width - 1 downto 0);
    up_count : std_logic) return unsigned is

  begin
    if (up_count = '1') then
      return cntr + 1;
    else
      return cntr - 1;
    end if;
  end function;

begin

  CNTR_PROC : process (i_clk, i_reset)
  begin
    if (i_reset = '1') then
      r_cntr <= to_unsigned(g_init_value, g_width);

    elsif rising_edge(i_clk) then
      if (i_sclr = '1') then
        r_cntr <= to_unsigned(g_init_value, g_width);

      else
        if (i_ce = '1') then
          r_cntr <= count(r_cntr, g_up_count);
        end if;

      end if;
    end if;
  end process;

  o_count <= std_logic_vector(r_cntr);

end architecture;