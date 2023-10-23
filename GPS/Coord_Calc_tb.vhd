library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.GPS_Package.all;
------------------------------------
entity Coord_Calc_tb is
end entity;
------------------------------------
architecture rtl of Coord_Calc_tb is

	constant	period	:	time	:= 10 ns;
	
	signal	r_Clk		:	std_logic	:= '1';
	signal	r_GPS_Data	:	std_logic_vector(7 downto 0);
	signal	r_Valid_In	:	std_logic	:= '0';
	signal	r_Valid_Out	:	std_logic	:= '0';
	signal	r_Busy		:	std_logic	:= '0';
	signal	r_Time		:	std_logic_vector(26 downto 0);
	signal	r_Latitude	:	std_logic_vector(26 downto 0);
	signal	r_Longitude	:	std_logic_vector(27 downto 0);
	signal	r_Altitude	:	std_logic_vector(17 downto 0);
	
begin

	UUT	:	entity work.Coord_Calc
		port map(
			i_Clk		=>	r_Clk,
			i_GPS_Data	=>	r_GPS_Data,
			i_Valid		=>	r_Valid_In,
			o_Valid		=>	r_Valid_Out,
			o_Busy		=>	r_Busy,
			o_Time		=>	r_Time,
			o_Latitude	=>	r_Latitude,
			o_Longitude	=>	r_Longitude,
			o_Altitude	=>	r_Altitude
		);

	process
		file fin	:	text open read_mode is "C:\Users\t26607bb\Desktop\Interface_Course\GPS\gps.txt";
		variable v_line		:	line;
		variable v_packet	:	string(1 to 70);
	begin
		wait for 100 ns;
		while not(endfile(fin)) loop
			readline(fin, v_line);
			read(v_line, v_packet);
			
			for i in v_packet'range loop
				r_GPS_Data	<=	ascii2bin(v_packet(i));
				r_Valid_In	<=	'1';
				wait for period;
				r_Valid_In	<=	'0';
				wait for 5 * period;
			end loop;

		end loop;
	
		wait;
	end process;
	
	r_Clk	<=	not	r_Clk after period/2;

end architecture;