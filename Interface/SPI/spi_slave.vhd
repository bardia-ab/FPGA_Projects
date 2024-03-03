library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
------------------------------------
entity SPI_Slave is
    generic(
        g_Mode      :   std_logic_vector(1 downto 0)    := "00";
        g_N_Bits    :   integer                         := 8
    );
    port(
        i_Clk       :   in      std_logic;
        i_MOSI      :   in      std_logic;
        i_SCLK      :   in     std_logic;
        i_CS        :   in     std_logic;
        o_MISO      :   out     std_logic
    );
end entity;
------------------------------------
architecture behavioral of SPI_Slave is 

    ---------------------- Types -------------------------
    type t_States is (s_IDLE, s_DRIVE, s_SAMPLE);
    signal  r_State             :   t_States    := s_IDLE;
    ---------------------- Registers -------------------------
    signal  r_CS                :   std_logic;
    signal  r_MISO              :   std_logic;
    signal  r_Shift_Reg         :   std_logic_vector(g_N_Bits - 1 downto 0) := x"35";
    signal  r_SCLK              :   std_logic;
    signal  r_Post_Drive        :   std_logic;
    signal  r_Pre_Drive         :   std_logic;
    ---------------------- Counters -------------------------
    signal  r_Bit_Cntr          :   integer range 0 to g_N_Bits - 1      := g_N_Bits - 1;
    
begin

    process(i_CLK)
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
        if rising_edge(i_CLK) then
            r_SCLK  <=  i_SCLK;
            r_CS    <=  i_CS;

            case r_State    is
                when s_IDLE         =>
                    if (r_CS = '1' and i_CS = '0') then
                        r_MISO    <=  r_Shift_Reg(r_Bit_Cntr);
                        r_State   <=  s_DRIVE;
                    end if;
                when s_DRIVE        =>
                    if (r_SCLK = r_Post_Drive and i_SCLK = r_Pre_Drive) then -- sample edge
                        r_Shift_Reg(r_Bit_Cntr) <=  i_MOSI;
                        r_State   <=  s_SAMPLE;
                    end if;
                when s_SAMPLE       =>
                if (r_SCLK = r_Pre_Drive and i_SCLK = r_Post_Drive) then -- drive edge
                    if transmission_done(g_N_Bits - 1) then
                        r_State     <=  s_IDLE;
                    else
                        r_Bit_Cntr  <=  r_Bit_Cntr - 1;
                        r_MISO      <=  r_Shift_Reg(r_Bit_Cntr - 1);
                        r_State     <=  s_DRIVE;
                    end if;
                end if;
                when others         =>
                    null;
            end case;  
        end if;

    end process;
    
    r_Post_Drive    <=  g_Mode(1) xor g_Mode(0);
    r_Pre_Drive     <=  not r_Post_Drive;

    o_MISO  <=  r_MISO  when    (i_CS = '0')    else    'Z';

end architecture;