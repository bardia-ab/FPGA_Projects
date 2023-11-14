library ieee;
use ieee.std_logic_1164.all;
-------------------------------
entity RW_Timing_Controller_tb is
end entity;
-------------------------------
architecture rtl of RW_Timing_Controller_tb is

    constant	Period		:	time		:= 10 ns;
    
    signal  w_Clk           :   std_logic   := '0';
    signal	w_Send			:	std_logic	:= '0';
    signal  w_Command_Data  :   std_logic_vector(9 downto 0)    := b"10_0000_1111";
    signal  w_RS            :   std_logic;
    signal  w_Rw            :   std_logic;
    signal  w_E             :   std_logic;
    signal  w_DB            :   std_logic_vector(7 downto 0);

begin

    Timing_Controller   :   entity work.RW_Timing_Controller
        generic map(g_Sys_Freq => 1e8)
        port map(
            i_Clk           =>  w_Clk, 
            i_Command_Data  =>  w_Command_Data, 
            i_Send          =>  w_Send, 
            o_Busy          =>  open, 
            o_Data_Read     =>  open, 
            o_Valid         =>  open, 
            o_RS            =>  w_RS, 
            o_RW            =>  w_RW, 
            o_E             =>  w_E, 
            io_DB           =>  w_DB 
        );
        
	w_Clk	<=	not w_Clk after Period/2;
	w_Send	<=	'1' after 147 ns, '0' after 160 ns, '1' after 1300 ns, '0' after 1310 ns;

end architecture;