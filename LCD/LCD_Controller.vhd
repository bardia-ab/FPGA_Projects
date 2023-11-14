library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
--------------------------------------
entity LCD_Controller is
    generic(
        g_Sys_Freq      :   integer := 1e8  --Hz
    );
    port(
        i_Clk           :   in      std_logic;
        i_Data          :   in      std_logic_vector(7 downto 0);
        i_Init          :   in      std_logic;
        i_Update        :   in      std_logic;
        i_Shift         :   in      std_logic;
        o_Busy          :   out     std_logic;
        o_DDRAM_Addr    :   out     std_logic_vector(5 downto 0);
        o_RS            :   out     std_logic;
        o_RW            :   out     std_logic;
        o_E             :   out     std_logic;
        io_DB           :   inout   std_logic_vector(7 downto 0)
    );
end entity;
--------------------------------------
architecture beahavioral of LCD_Controller is

    ---------------- Constants -------------------------
    constant    c_Function_Set      :   std_logic_vector(9 downto 0)    := "0000111100";
    constant    c_Display_On_Off    :   std_logic_vector(9 downto 0)    := "0000001100";
    constant    c_Display_Clear     :   std_logic_vector(9 downto 0)    := "0000000001";
    constant    c_Entry_Mode_Set    :   std_logic_vector(9 downto 0)    := "0000000110";
    constant    c_Shift_Display     :   std_logic_vector(9 downto 0)    := "0000011000";
    constant    c_DDRAM_Address     :   std_logic_vector(9 downto 0)    := "0010000000";
    ---------------- Types -------------------------
    type t_Update_States is (s_Idle, s_Set_DDRAM_Address, s_Wait_1, s_Wait_2, s_Send_Data, s_Decision);
    type t_Init_States is (s_Idle, s_Function_Set, s_Display_On_Off, s_Display_Clear, s_Entry_Mode_Set, s_Null);
    type t_Shift_States is (s_Idle, s_Shift_Display, s_Wait);
    signal  r_Update_State          :   t_Update_States := s_Idle;
    signal  r_Init_State            :   t_Init_States   := s_Idle;
    signal  r_Shift_State            :   t_Shift_States   := s_Idle;
    ---------------- I/O Registers -----------------
    signal  r_Init                  :   std_logic;
    signal  r_Update                :   std_logic;
    signal  r_Shift                 :   std_logic;
    signal  r_Busy                  :   std_logic;
    signal  r_DDRAM_Addr            :   unsigned(5 downto 0)    := (others => '0');
    ---------------- Timing_Controller --------------
    signal  r_Send                  :   std_logic;
    signal  r_Command_Data          :   std_logic_vector(9 downto 0);
    signal  r_LCD_Busy              :   std_logic;
    signal  r_Busy_Flag             :   std_logic;
    --------------- Internal Registers --------------
    signal  r_LCD_Line              :   std_logic_vector(0 downto 0)    := "0";
    --------------- Counters ------------------------
    signal  r_Wait_Cntr             :   integer;

begin

    Timing_Controller   :   entity work.RW_Timing_Controller
    generic map(g_Sys_Freq => g_Sys_Freq)
    port map(
        i_Clk           =>  i_Clk, 
        i_Command_Data  =>  r_Command_Data, 
        i_Send          =>  r_Send, 
        o_Busy          =>  r_LCD_Busy, 
        o_Data_Read     =>  open, 
        o_Valid         =>  open, 
        o_RS            =>  o_RS, 
        o_RW            =>  o_RW, 
        o_E             =>  o_E, 
        io_DB           =>  io_DB 
    );

    process(i_Clk)
        impure function time_elapsed(delay  :   real) return boolean is
            variable    v_Result    :   boolean;
            constant    c_Max       :   integer := integer(ceil(delay * real(g_Sys_Freq)));
        begin
            if (r_Wait_Cntr = c_Max) then
                r_Wait_Cntr <=  0;
                v_Result    := True;
            else
                v_Result    := False;
            end if;
            return v_Result;
        end time_elapsed;

    begin
        if rising_edge(i_Clk) then
            r_Update    <=  i_Update;
            r_Shift     <=  i_Shift;
            r_Init      <=  i_Init;
            -------- Default ---------
            r_Send      <=  '0';
            r_Wait_Cntr <=  r_Wait_Cntr + 1;

            -------- Initialization ----------
            case r_Init_State is
                when s_Idle =>
                    if (r_Init = '0' and i_Init = '1') then
                        r_Init_State        <=  s_Function_Set;
                    end if;
                when s_Function_Set =>
                    r_Command_Data      <=  c_Function_Set;
                    r_Send              <=  '1';
                    r_Wait_Cntr         <=  0;
                    r_Init_State        <=  s_Display_On_Off;
                when s_Display_On_Off =>
                    if time_elapsed(40.0e-6) then
                        r_Command_Data      <=  c_Display_On_Off;
                        r_Send              <=  '1';
                        r_Init_State        <=  s_Display_Clear;
                    end if;
                when s_Display_Clear =>
                    if time_elapsed(40.0e-6) then
                        r_Command_Data      <=  c_Display_Clear;
                        r_Send              <=  '1';
                        r_Init_State        <=  s_Entry_Mode_Set;
                    end if;
                when s_Entry_Mode_Set =>
                    if time_elapsed(1.54e-3) then
                        r_Command_Data      <=  c_Entry_Mode_Set;
                        r_Send              <=  '1';
                        r_Init_State        <=  s_Null;
                    end if;
                when s_Null =>
                    null;

            end case;

            ------ Update_FSM ------
            case r_Update_State is
                when s_Idle =>
                    r_Busy  <=  '0';
                    if (r_Update = '0' and i_Update = '1') then
                        r_Busy          <=  '1';
                        r_DDRAM_Addr    <=  (others => '0');
                        r_Update_State  <=  s_Set_DDRAM_Address;
                        r_Shift_State   <=  s_Idle;
                    end if;
                when s_Set_DDRAM_Address =>
                    r_Command_Data          <=  c_DDRAM_Address;
                    r_Send                  <=  '1';
                    r_LCD_Line              <=  "0";
                    r_Wait_Cntr             <=  0;
                    r_Update_State          <=  s_Wait_1;
                when s_Wait_1 =>
                    if time_elapsed(40.0e-6) then
                        r_Update_State  <=  s_Send_Data;
                    end if;
                when s_Send_Data =>
                    r_Command_Data          <=  "10" & i_Data;
                    r_Send                  <=  '1';
                    r_Wait_Cntr             <=  0;
                    r_Update_State          <=  s_Wait_2;
                when s_Wait_2 =>
                    if time_elapsed(44.0e-6) then
                        r_Update_State  <=  s_Decision;
                    end if;
                when s_Decision =>
                    if (r_DDRAM_Addr < to_unsigned(39, r_DDRAM_Addr'length)) then
                        r_DDRAM_Addr            <=  r_DDRAM_Addr + 1;
                        r_Update_State          <=  s_Send_Data;
                    elsif (r_LCD_Line = "1") then
                        r_Update_State  <=  s_Idle;
                    else
                        r_DDRAM_Addr    <=  (others => '0');
                        r_LCD_Line      <=  "1";
                        r_Update_State  <=  s_Send_Data;
                    end if;
            end case;

            -------- Shift LCD -------
            case r_Shift_State is
                when s_Idle =>
                    if (r_Shift = '0' and i_Shift = '1') then
                        r_Shift_State   <=  s_Shift_Display;  
                    end if;
                when s_Shift_Display =>
                    if (r_Busy = '0') then
                        r_Command_Data          <=  c_Shift_Display;
                        r_Send                  <=  '1';
                        r_Wait_Cntr             <=  0;
                        r_Shift_State          <=  s_Wait;
                    end if;
                when s_Wait =>
                    if time_elapsed(0.5) then
                        r_Shift_State  <=  s_Shift_Display;
                    end if;
            end case;
        end if;
    end process;
    
    r_Busy_Flag     <=  io_DB(7) when (r_Command_Data(9 downto 8) = "01") else '1';
    o_Busy          <=  r_Busy;
    o_DDRAM_Addr    <=  std_logic_vector(r_DDRAM_Addr);

end architecture;