library ieee;
use ieee.std_logic_1164.all;
------------------------------------
entity GPS_Top is
    port(
        i_Clk_P     :   in      std_logic;
        i_Clk_N     :   in      std_logic;
        i_Req       :   in      std_logic;
--        o_Coord     :   out     std_logic_vector();
        o_Tx        :   out     std_logic;
        o_LED       :   out     std_logic;
        -- GPS Ports
        i_GPS_Tx    :   in      std_logic;
        i_GPS_3DF   :   in      std_logic;
        i_GPS_1PPS  :   in      std_logic;
        o_GPS_Rx    :   out     std_logic
    );
end entity;
------------------------------------
architecture behavioral of GPS_Top is

    component clk_wiz_0
		port(
			clk_out1          : out    std_logic;
			clk_in1_p         : in     std_logic;
			clk_in1_n         : in     std_logic
		);
	end component;
	
	COMPONENT vio_0
		PORT (
			clk : IN STD_LOGIC;
			probe_in0 : IN STD_LOGIC_VECTOR(26 DOWNTO 0);
			probe_in1 : IN STD_LOGIC_VECTOR(26 DOWNTO 0);
			probe_in2 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
			probe_in3 : IN STD_LOGIC_VECTOR(17 DOWNTO 0)
		);
	END COMPONENT;
    
    signal  w_Clk_100   :   std_logic;
    signal  w_Validate  :   std_logic;
    signal  w_GPS_Data  :   std_logic_vector(7 downto 0);
    
--    signal  w_GPS_Tx    :   std_logic;
--    signal  w_GPS_3DF   :   std_logic;
--    signal  w_GPS_1PPS  :   std_logic;
    signal  w_GPS_Rx    :   std_logic   := '1';
    
    signal	w_Time		:	std_logic_vector(26 downto 0);
    signal	w_Latitude	:	std_logic_vector(26 downto 0);
    signal	w_Longitude	:	std_logic_vector(27 downto 0);
    signal	w_Altitude	:	std_logic_vector(17 downto 0);

begin

    CM_100_Inst : clk_wiz_0
		port map ( 
			clk_out1 	=> w_Clk_100,
			clk_in1_p 	=> i_Clk_P,
			clk_in1_n 	=> i_Clk_N
		);

   UART_Rx_Inst    :   entity work.UART_Rx
       generic map(
           g_Parity    =>  "0",
           g_N_Bits    =>  8,
           g_Baud_Rate =>  9600,
           g_Frequency =>  1e8
       )
       port map(
           i_Clk       =>  w_Clk_100,
           i_Rx        =>  i_GPS_Tx,
           o_Valid     =>  w_Validate,
           o_Busy      =>  open,
           o_Data_Out  =>  w_GPS_Data
       );

   Coord_Calc_Inst :   entity work.Coord_Calc_2
       port map(
           i_Clk       =>  w_Clk_100,
           i_GPS_Data  =>  w_GPS_Data,
           i_Valid     =>  w_Validate,
           o_Time      =>  w_Time,
           o_Latitude  =>  w_Latitude,
           o_Longitude =>  w_Longitude,
           o_Altitude  =>  w_Altitude
       );

--	your_instance_name : vio_0
--		PORT MAP (
--			clk 		=> w_Clk_100,
--			probe_in0 	=> w_Time,
--			probe_in1 	=> w_Latitude,
--			probe_in2 	=> w_Longitude,
--			probe_in3 	=> w_Altitude
--		);
  
	o_GPS_Rx	<=	w_GPS_Rx;
	o_LED		<=	i_GPS_3DF;
	o_Tx		<=	i_GPS_Tx;

end architecture;