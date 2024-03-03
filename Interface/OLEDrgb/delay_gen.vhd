library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------
entity delay_gen is
    port(
        i_Clk           :   in      std_logic;
        i_En            :   in      std_logic;
        i_Max_Count     :   in      std_logic_vector;
        o_Done          :   out     std_logic
    );
end entity;
------------------------------------
architecture behavioral of delay_gen is

    type t_States is (s_Idle, s_Count);

    signal  r_State     :   t_States    := s_Idle;
    
    signal  r_Cntr      :   unsigned(i_Max_Count'range) := (others => '0');
    signal  r_En        :   std_logic;
    signal  r_Done      :   std_logic;

begin

    process(i_Clk)
    begin
        if rising_edge(i_Clk) then
            r_En    <=  i_En;
            ----- default -----
            r_Done  <=  '0';

            case r_State is
                when    s_Idle  =>
                    if (r_En = '0' and i_En = '1') then
                        r_State <=  s_Count;
                    end if;
                when    s_Count =>
                    if (r_Cntr < unsigned(i_Max_Count) - 1) then
                        r_Cntr  <=  r_Cntr + 1;
                    else
                        r_Cntr  <=  (others => '0');
                        r_Done  <=  '1';
                        r_State <=  s_Idle;
                    end if;
            end case;
            
        end if;
    end process;
    
    o_Done  <=  r_Done;

end architecture;