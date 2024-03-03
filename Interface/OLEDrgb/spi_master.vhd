library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
------------------------------------
entity SPI_Master is
    generic(
        g_Mode      :   std_logic_vector(1 downto 0)    := "00";
        g_N_Bits    :   integer                         := 8;
        g_Sys_Freq  :   integer                         := 1e8; --Hz
        g_SPI_Freq  :   integer                         := 4e5; --Hz
        g_t_Setup   :   real                            := 0.0; --s
        g_t_Hold    :   real                            := 0.0; --s
        g_t_Turn    :   real                            := 0.0  --s
    );
    port(
        i_Clk       :   in      std_logic;
        i_Send      :   in      std_logic;
		i_Data_In	:	in		std_logic_vector(g_N_Bits - 1 downto 0);
        i_MISO      :   in      std_logic;
        o_MOSI      :   out     std_logic;
        o_SCLK      :   out     std_logic;
        o_CS        :   out     std_logic;
        o_Done      :   out     std_logic
    );
end entity;
------------------------------------
architecture behavioral of SPI_Master is

    ---------------------- Constants -------------------------
    constant c_Half_Period : integer := (g_Sys_Freq / (2 * g_SPI_Freq));
    ---------------------- Types -------------------------
    type t_States is (s_IDLE, s_SETUP, s_DRIVE, s_SAMPLE, s_HOLD, s_TURNAROUND);
    signal  r_State             :   t_States    := s_IDLE;
    ---------------------- Registers -------------------------
    signal  r_Send              :   std_logic;
    signal  r_MOSI              :   std_logic;
    signal  r_SCLK              :   std_logic   := g_Mode(1);
    signal  r_CS                :   std_logic   := '1';
    signal  r_Done              :   std_logic;
    signal  r_Shift_Reg         :   std_logic_vector(g_N_Bits - 1 downto 0) := (others => '0');
    ---------------------- Counters -------------------------
    signal  r_Half_Period_Cntr  :   integer range 0 to c_Half_Period - 1 := c_Half_Period - 1;
    signal  r_Setup_Max         :   integer;
    signal  r_Hold_Max          :   integer;
    signal  r_Turn_Max          :   integer;
    signal  r_Setup_Cntr        :   integer :=  0;
    signal  r_Hold_Cntr         :   integer :=  0;
    signal  r_Turn_Cntr         :   integer :=  0;
    signal  r_Bit_Cntr          :   integer range 0 to g_N_Bits - 1      := g_N_Bits - 1;
    

begin

    process(i_Clk)
        impure function time_elapsed(constant reset_value   :   integer) return boolean is
            variable    v_Result    :   boolean;
        begin
            if (r_Half_Period_Cntr > 0) then
                v_Result            := False;
            else
                v_Result            := True;
                r_Half_Period_Cntr  <=  reset_value;
            end if;
            return v_Result;
        end time_elapsed;

        impure function transmission_done(constant reset_value   :   integer) return boolean is
            variable    v_Result    :   boolean;
        begin
            if (r_Bit_Cntr > 0) then
                v_Result            := False;
            else
                v_Result            := True;
                r_Bit_Cntr          <=  reset_value;
            end if;
            return v_Result;
        end transmission_done;

    begin

        if rising_edge(i_Clk) then
            r_Send  <=  i_Send;
            ------ Default ------
            r_Done  <=  '0';
            
	    if (r_Half_Period_Cntr > 0) then
            	r_Half_Period_Cntr  <=  r_Half_Period_Cntr - 1;
	    else
		r_Half_Period_Cntr	<=	0;
	    end if;

            case r_State is
                when s_IDLE         =>
                    if (r_Send = '0' and i_Send = '1') then
						r_Shift_reg		<=	i_Data_In;
                        r_CS          	<=  '0';
                        r_SCLK        	<=  g_Mode(1);
                        r_Setup_Cntr  	<=  r_Setup_Max;
                        r_State       	<=  s_SETUP;
                    end if;
                when s_SETUP        =>
                    if (r_Setup_Cntr > 0) then
                        r_Setup_Cntr    <=  r_Setup_Cntr - 1;
                    else
                        r_SCLK              <=  g_Mode(1) xor g_Mode(0);
                        r_MOSI              <=  r_Shift_Reg(r_Bit_Cntr);
                        r_Half_Period_Cntr  <=  c_Half_Period - 1;
                        r_State             <=  s_DRIVE;
                    end if;
                when s_DRIVE        =>
                    if time_elapsed(c_Half_Period - 1) then
                        r_SCLK      <=  not r_SCLK;
                        r_Shift_Reg(r_Bit_Cntr) <=  i_MISO;
                        r_State     <=  s_SAMPLE;
                    end if;
                when s_SAMPLE       =>
                    if time_elapsed(c_Half_Period - 1) then
                        r_SCLK      <=  not r_SCLK;
                        
                        if transmission_done(g_N_Bits - 1) then
                            r_Hold_Cntr <=  r_Hold_Max;
                            r_State     <=  s_HOLD;
                        else
			                r_Bit_Cntr  <=  r_Bit_Cntr - 1;
                            r_MOSI      <=  r_Shift_Reg(r_Bit_Cntr - 1);
                            r_State     <=  s_DRIVE;
                        end if;
                    end if;
                when s_HOLD         =>
                    if (r_Hold_Cntr > 0) then
                        r_Hold_Cntr <=  r_Hold_Cntr - 1;
                    else
                        r_Turn_Cntr <=  r_Turn_Max;
                        r_CS        <=  '1';
                        r_State     <=  s_TURNAROUND;
                    end if;
                when s_TURNAROUND   =>
                    if (r_Turn_Cntr > 0) then
                        r_Turn_Cntr <=  r_Turn_Cntr - 1;
                    else
                        r_Done  <=  '1';
                        r_State <=  s_IDLE;
                    end if;
                when others         =>
                    null;
            end case;
        end if;
    end process;

    r_Setup_Max     <=  (c_Half_Period - 1)   when    (g_t_Setup = 0.0)  else   integer(ceil(g_t_Setup * real(g_Sys_Freq))) - 1; 
    r_Hold_Max      <=  (c_Half_Period - 1)   when    (g_t_Hold = 0.0)  else   integer(ceil(g_t_Hold * real(g_Sys_Freq))) - 1;
    r_Turn_Max      <=  (c_Half_Period - 1)   when    (g_t_Turn = 0.0)  else   integer(ceil(g_t_Turn * real(g_Sys_Freq))) - 1;
        
    
    o_MOSI      <=  r_MOSI;
    o_SCLK      <=  r_SCLK;
    o_CS        <=  r_CS;
    o_Done      <=  r_Done;

end architecture;