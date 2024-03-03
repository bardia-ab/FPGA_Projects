library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_lights is
generic(clk_hz : integer);
port(
  clk : in std_logic;
  rst : in std_logic;
  north_red : out std_logic;
  north_yellow : out std_logic;
  north_green : out std_logic;
  west_red : out std_logic;
  west_yellow : out std_logic;
  west_green : out std_logic
  );
end entity;

architecture rtl of traffic_lights is

    -- Enumerated type declaration and state signal declaration
    type t_state is (NORTH_NEXT, START_NORTH, NORTH, STOP_NORTH,
                        WEST_NEXT, START_WEST, WEST, STOP_WEST);
    signal state : t_state;

    -- counter for counting clock periods, 1 minute max
    signal counter : integer range 0 to clk_hz * 60;

begin

    process(clk) is

        -- Procedure for changing state after a given time
        procedure change_state(to_state : t_state;
                              minutes : integer := 0;
                              seconds : integer := 0) is
            variable total_seconds : integer;
            variable clock_cycles  : integer;
        begin
            total_seconds := seconds + minutes * 60;
            clock_cycles  := total_seconds * clk_hz -1;
            if counter = clock_cycles then
                counter <= 0;
                state   <= to_state;
            end if;
        end procedure;

    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset values
                state   <= NORTH_NEXT;
                counter <= 0;
                north_red    <= '1';
                north_yellow <= '0';
                north_green  <= '0';
                west_red     <= '1';
                west_yellow  <= '0';
                west_green   <= '0';

            else
                -- Default values
                north_red    <= '0';
                north_yellow <= '0';
                north_green  <= '0';
                west_red     <= '0';
                west_yellow  <= '0';
                west_green   <= '0';

                counter <= counter + 1;

                case state is

                    -- Red in all directions
                    when NORTH_NEXT =>
                        north_red <= '1';
                        west_red  <= '1';
                        change_state(START_NORTH, seconds => 5);

                    -- Red and yellow in north/south direction
                    when START_NORTH =>
                        north_red    <= '1';
                        north_yellow <= '1';
                        west_red     <= '1';
                        change_state(NORTH, seconds => 5);

                    -- Green in north/south direction
                    when NORTH =>
                        north_green <= '1';
                        west_red    <= '1';
                        change_state(STOP_NORTH, minutes => 1);

                    -- Yellow in north/south direction
                    when STOP_NORTH =>
                        north_yellow <= '1';
                        west_red     <= '1';
                        change_state(WEST_NEXT, seconds => 5);

                    -- Red in all directions
                    when WEST_NEXT =>
                        north_red <= '1';
                        west_red  <= '1';
                        change_state(START_WEST, seconds => 5);

                    -- Red and yellow in west/east direction
                    when START_WEST =>
                        north_red   <= '1';
                        west_red    <= '1';
                        west_yellow <= '1';
                        change_state(WEST, seconds => 5);

                    -- Green in west/east direction
                    when WEST =>
                        north_red  <= '1';
                        west_green <= '1';
                        change_state(STOP_WEST, minutes => 1);

                    -- Yellow in west/east direction
                    when STOP_WEST =>
                        north_red   <= '1';
                        west_yellow <= '1';
                        change_state(NORTH_NEXT, seconds => 5);

                end case;

            end if;
        end if;
    end process;

end architecture;