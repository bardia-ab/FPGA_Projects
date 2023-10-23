library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------
entity SPI_Slave_tb is
end entity;
----------------------------------
architecture behavioral of SPI_Slave_tb is

    constant    clk_period  :   time    := 10 ns;
    
    signal  Clk         :   std_logic               := '0';
    signal  Send        :   std_logic               := '0';
    signal  MISO        :   std_logic               := '0';
    signal  MOSI        :   std_logic;
    signal  SCLK        :   std_logic;
    signal  CS          :   std_logic;
    signal	Data_In		:   unsigned(7 downto 0)	:= x"36";
    signal  CS_reg      :   std_logic;
    signal  Busy        :   std_logic;

begin

    Master :   entity work.SPI_Master
        generic map(
            g_Mode          =>  "00",  
            g_N_Bits        =>  8,
            g_Sys_Freq      =>  1e8,
            g_SPI_Freq      =>  4e5,
            g_t_Setup       =>  2.0e-6,
            g_t_Hold        =>  2.0e-6,
            g_t_Turn        =>  2.0e-6
        )
        port map(
            i_Clk       =>  Clk,    
            i_Send      =>  Send,   
            i_Data_In	=>	std_logic_vector(Data_In), 
            i_MISO      =>  MISO,    
            o_MOSI      =>  MOSI,    
            o_SCLK      =>  SCLK,    
            o_CS        =>  CS,
            o_Busy      =>  Busy     
        );

    Slave   :   entity work.SPI_Slave
            generic map(
                g_Mode          =>  "00",  
                g_N_Bits        =>  8  
            )
            port map(
                i_Clk   =>  Clk,
                i_MOSI  =>  MOSI,
                i_SCLK  =>  SCLK,
                i_CS    =>  CS,
                o_MISO  =>  MISO
            );

    Clk     <=  not Clk after clk_period/2;
    
    process(Clk)
    begin
        if rising_edge(Clk) then
            CS_reg	<=	CS;
            Send    <=  '0';
			
            if (CS_reg = '1' and CS = '0') then
                Data_In <=  Data_In + 1;
            end if;

			if (Busy = '0') then
                Send    <=  '1';
            end if;
        end if;
    end process;

end architecture;