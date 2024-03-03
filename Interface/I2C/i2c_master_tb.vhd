library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------
entity I2C_Master_tb is
end entity;
-------------------------------------
architecture behavioral of I2C_Master_tb is

    constant    Period      :   time    := 10 ns;
    
    signal  Clk             :   std_logic   := '0';
    signal  CMD_Valid       :   std_logic   := '0';
    signal  Last_Rd_Byte    :   std_logic   := '0';
    signal  CMD             :   std_logic_vector(2 downto 0)    := "000";
    signal  Data_In         :   unsigned(7 downto 0)    := x"35";
    signal  Data_Out        :   std_logic_vector(7 downto 0);
    signal  Ackn            :   std_logic;
    signal  Busy            :   std_logic;
    signal  Done            :   std_logic;
    signal  SCL             :   std_logic;
    signal  SDA             :   std_logic   := 'Z';

    signal  state           :   unsigned(2 downto 0)    := "000";

begin

    UUT :   entity work.I2C_Master
        generic map(
            g_Sys_Freq  =>  1e8,
            g_I2C_Freq  =>  4e5
        )
        port map(
            i_Clk          =>   Clk, 
            i_CMD_Valid    =>   CMD_Valid, 
            i_Last_Rd_Byte =>   Last_Rd_Byte, 
            i_CMD          =>   CMD, 
            i_Data_In      =>   std_logic_vector(Data_In), 
            o_Data_Out     =>   Data_Out, 
            o_Ack          =>   Ackn, 
            o_Busy         =>   Busy, 
            o_Done         =>   Done, 
            o_SCL          =>   SCL, 
            io_SDA         =>   SDA
        );

    Clk <=  not Clk after Period/2;

    process(Clk)
    begin
        
        if rising_edge(Clk) then
            CMD_Valid   <=  '0';

            case    state   is
                when    "000"   =>
                    if (Busy = '0') then
                        CMD_Valid   <=  '1';
                        state       <=  "001";
                    end if;
                when    "001"   =>
                    CMD         <=  "001";
                    state       <=  "010";
                when    "010"   =>
                    if (Busy = '0') then
                        CMD_Valid   <=  '1';
                        state       <=  "011";
                    end if;
                when    "011"   =>
                    Data_In <=  Data_In + 1;
                    state   <=  "100";
                when    "100"   =>
                    if (Busy = '0') then
                        CMD_Valid   <=  '1';
                        state       <=  "101";
                    end if;
                when    "101"   =>
                    CMD         <=  "011";
                    state       <=  "110";
                when    "110"   =>
                    if (Busy = '0') then
                        CMD         <=  "000";
                        state       <=  "000";
                    end if;
                when    others   =>
            end case;
            
            
        end if;

    end process;

end architecture;