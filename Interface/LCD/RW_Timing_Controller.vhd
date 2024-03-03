library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
---------------------------------------
entity RW_Timing_Controller is
    generic(
        g_Sys_Freq      :   integer := 1e8  -- Hz
    );
    port(
        i_Clk           :   in      std_logic;
        i_Command_Data  :   in      std_logic_vector(9 downto 0);
        i_Send          :   in      std_logic;
        o_Busy          :   out     std_logic;
        o_Data_Read     :   out     std_logic_vector(7 downto 0);
        o_Valid         :   out     std_logic;
        -------- LCD I/O ---------
        o_RS            :   out     std_logic;  -- '1': Data    '0': command
        o_RW            :   out     std_logic;  -- '1': Read    '0': Write
        o_E             :   out     std_logic;
        io_DB           :   inout   std_logic_vector(7 downto 0)
    );
end entity;
---------------------------------------
architecture behavioral of RW_Timing_Controller is

    ----------------- Types -----------------------------
    type t_States is (s_Idle, s_Setup, s_High, s_Low);
    signal  r_State     :   t_States    := s_Idle;
    ----------------- I/O Registers ---------------------
    signal  r_Data_Wr   :   std_logic_vector(7 downto 0);
    signal  r_Send      :   std_logic;
    signal  r_Busy      :   std_logic   := '0';
    signal  r_Valid     :   std_logic   := '0';
    signal  r_RS        :   std_logic   := '0';
    signal  r_RW        :   std_logic   := '1';
    signal  r_E         :   std_logic   := '0';
    ----------------- Counters ---------------------
    signal  r_Cntr      :   integer     := 0;

begin

    process(i_Clk)

    begin
        if rising_edge(i_Clk) then
            r_Send      <=  i_Send;
            -------- Default --------
            r_Valid     <=  '0';
            r_Cntr      <=   r_Cntr + 1; 

            case r_State is
                when    s_Idle  =>
                    r_Busy      <=  '0';

                    if (r_Send = '0' and i_Send = '1') then
                        r_Data_Wr   <=  i_Command_Data(7 downto 0);
                        r_RW        <=  i_Command_Data(8);
                        r_RS        <=  i_Command_Data(9);
                        r_E         <=  '0';
                        r_Cntr      <=  0;
                        r_Busy      <=  '1';
                        r_State     <=  s_Setup;
                    end if;
                when    s_Setup =>
                    if (r_Cntr = 6) then
                        r_E         <=  '1';
                        r_Cntr      <=  0;
                        r_State     <=  s_High;
                    end if;
                when    s_High  =>
                    if (r_Cntr = 49) then
                        r_E         <=  '0';
                        r_Cntr      <=  0;
                        r_State     <=  s_Low;
                    end if;

                    if (r_Cntr = 25) then
                        r_Valid <=  '1';
                    end if;
                when    s_Low   =>
                    if (r_Cntr = 49) then
                        r_State     <=  s_Idle;
                    end if;
            end case;
        end if;
    end process;

    -------------------- I/O Buffer -----------------------
    o_Data_Read         <=  io_DB(7 downto 0);
    io_DB(7 downto 0)   <=  r_Data_Wr when (r_RW = '0') else (others => 'Z');
    -------------------------------------------------------
    o_Busy      <=  r_Busy;
    o_Valid     <=  r_Valid;
    o_RS        <=  r_RS;
    o_RW        <=  r_RW;
    o_E         <=  r_E;

end architecture;