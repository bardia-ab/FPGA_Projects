library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
---------------------------------------
entity fifo_axi is
  generic (
    g_width : positive;
    g_depth : positive
  );
  port (
    i_clk   : in std_logic;
    i_reset : in std_logic;

    -- AXI input interface
    i_data_in  : in std_logic_vector(g_width - 1 downto 0);
    i_valid_in : in std_logic;
    o_ready_in : out std_logic;

    -- AXI output interface
    o_data_out  : out std_logic_vector(g_width - 1 downto 0);
    i_ready_out : in std_logic;
    o_valid_out : out std_logic
  );
end fifo_axi;
---------------------------------------
architecture rtl of fifo_axi is

  function get_log2 (input : integer) return integer is
  begin
    if input > 1 then
      return integer(floor(log2(real(input - 1))));
    else
      return 0;
    end if;
  end get_log2;

  -- State
  type t_states is (s_empty, s_partial, s_full);
  signal r_state : t_states := s_empty;

  -- Memory
  type t_mem is array(0 to g_depth - 1) of std_logic_vector(g_width - 1 downto 0);
  subtype st_index is integer range t_mem'range;

  signal r_mem         : t_mem;
  signal w_mem_we      : std_logic := '0';
  signal w_mem_wr_addr : integer range 0 to g_depth - 1;
  signal w_mem_rd_addr : integer range 0 to g_depth - 1;
  signal r_data_out    : std_logic_vector(g_width - 1 downto 0);

  -- Pointr Signals
  signal r_head    : std_logic_vector(get_log2(g_depth) downto 0); -- wr pointer
  signal r_tail    : std_logic_vector(get_log2(g_depth) downto 0); -- rd pointer
  signal r_head_ce : std_logic;
  signal r_tail_ce : std_logic;

  -- Full & Empty signals
  signal r_full  : std_logic := '0';
  signal r_empty : std_logic := '1';

  -- Internal signals
  signal r_ready_in  : std_logic := '1';
  signal r_valid_out : std_logic := '0';

begin

  FSM_PROC : process (i_clk)
  begin
    if rising_edge(i_clk) then
      if (i_reset = '1') then
        r_state     <= s_empty;
        r_ready_in  <= '1';
        r_valid_out <= '0';

      else

        case r_state is

          when s_empty =>
            r_ready_in  <= '1';
            r_valid_out <= '0';

            if (i_valid_in = '1') then
              r_state <= s_partial;
            end if;

          when s_partial =>
            r_ready_in  <= '1';
            r_valid_out <= '1';

            if (unsigned(r_head) = (unsigned(r_tail) + 1)) then
              if (r_tail_ce = '1') then
                r_ready_in  <= '1';
                r_valid_out <= '0';
                r_state     <= s_empty;
              end if;
            end if;

            if ((unsigned(r_head) + 1) = unsigned(r_tail)) then
              if (r_head_ce = '1') then
                r_ready_in  <= '0';
                r_valid_out <= '1';
                r_state     <= s_full;
              end if;

            end if;

          when s_full =>
            r_ready_in  <= '0';
            r_valid_out <= '1';

            if (i_ready_out = '1') then
              r_ready_in <= '1';
              r_state    <= s_partial;
            end if;

          when others =>
            null;

        end case;

      end if;
    end if;
  end process;

  HEAD_COUNTER : entity work.binary_counter
    generic map(
      g_width => get_log2(g_depth) + 1
    )
    port map(
      i_clk   => i_clk,
      i_reset => i_reset,
      i_ce    => r_head_ce,
      i_sclr  => '0',
      o_count => r_head
    );

  TAIL_COUNTER : entity work.binary_counter
    generic map(
      g_width => get_log2(g_depth) + 1
    )
    port map(
      i_clk   => i_clk,
      i_reset => i_reset,
      i_ce    => r_tail_ce,
      i_sclr  => '0',
      o_count => r_tail
    );

  -- BRAM inference
  PROC_MEM : process (i_clk)
  begin
    if rising_edge(i_clk) then

      if (w_mem_we = '1') then
        r_mem(w_mem_wr_addr) <= i_data_in;
      end if;

      r_data_out <= r_mem(w_mem_rd_addr);
    end if;
  end process;

  w_mem_we      <= i_valid_in and r_ready_in;
  w_mem_wr_addr <= to_integer(unsigned(r_head));
  w_mem_rd_addr <= to_integer(unsigned(r_tail));

  r_head_ce <= i_valid_in and r_ready_in;
  r_tail_ce <= i_ready_out and r_valid_out;

  -- output ports
  o_ready_in  <= r_ready_in;
  o_valid_out <= r_valid_out;
  o_data_out  <= r_data_out;

end architecture;