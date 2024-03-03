library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.GPS_Package.all;
-----------------------------------
entity Coord_Calc is
    port(
        i_Clk       :   in      std_logic;
        i_GPS_Data  :   in      std_logic_vector(7 downto 0);
        i_Valid     :   in      std_logic;
        o_Busy		:	out		std_logic;
        o_Valid		:	out		std_logic;
        o_Time      :   out     std_logic_vector(26 downto 0);
        o_Latitude  :   out     std_logic_vector(26 downto 0);
        o_Longitude :   out     std_logic_vector(27 downto 0);
        o_Altitude  :   out     std_logic_vector(17 downto 0)
    );
end entity;
-----------------------------------
architecture behavioral of Coord_Calc is

    type t_States is (s1, s2, s3, s4, s5, s6, s7);
    signal  r_State         :   t_States    := s1;

    signal  r_Field_Cntr    :   integer range 0 to 15   := 0;
    signal  r_Digit_Cntr    :   integer range 0 to 15    := 9;
    signal	r_GPS_Data		:	std_logic_vector(7 downto 0);
    signal  r_Digit         :   std_logic_vector(3 downto 0);
    signal	r_Valid			:	std_logic	:= '0';
    signal	r_Busy			:	std_logic	:= '0';
	signal	r_Position_Fix	:	std_logic	:= '0';
	signal	r_GPGGA			:	std_logic	:=	'0';

    signal r_Time           : unsigned(26 downto 0) := (others => '0');
    signal r_Time_H         : unsigned(17 downto 0) := (others => '0');
    signal r_Time_M         : unsigned(11 downto 0) := (others => '0');
    signal r_Time_S         : unsigned(5 downto 0)  := (others => '0');
    signal r_Latitude       : signed(26 downto 0)   := (others => '0');
    signal r_Latitude_D     : unsigned(12 downto 0) := (others => '0');
    signal r_Latitude_M     : unsigned(9 downto 0)  := (others => '0');
    signal r_Longitude      : signed(27 downto 0)   := (others => '0');
    signal r_Longitude_D    : unsigned(13 downto 0)   := (others => '0');
    signal r_Longitude_M    : unsigned(9 downto 0)   := (others => '0');
    signal r_Altitude       : signed(17 downto 0)   := (others => '0');
    signal r_Altitude_sign	: std_logic	:= '0';
    
    attribute mark_debug	:	string;
    attribute mark_debug of r_Time			:	signal is "True";
    attribute mark_debug of r_Latitude		:	signal is "True";
    attribute mark_debug of r_Longitude		:	signal is "True";
    attribute mark_debug of r_Altitude		:	signal is "True";
    attribute mark_debug of r_Valid			:	signal is "True";
    
begin

    process(i_Clk)
    begin

        if (i_Clk'event and i_Clk = '1') then

            if (i_Valid = '1') then
				r_GPS_Data		<=	i_GPS_Data;
				if (r_Digit_Cntr < 15) then
					r_Digit_Cntr    <=  r_Digit_Cntr + 1;
				else
					r_Digit_Cntr	<=	0;
				end if;
				
				if (get_ascii(i_GPS_Data) = ',') then
					r_Field_Cntr    <=  r_Field_Cntr + 1;
					r_Digit_Cntr    <=  0;
				end if;
	
				case r_State is
					when s1     =>
						if (get_ascii(i_GPS_Data) = '$') then
							r_GPGGA			<=	'0';
							-- r_Field_Cntr    <=  0; 
							r_Time          <=  (others => '0');
							r_Time_H        <=  (others => '0');
							r_Time_M        <=  (others => '0');
							r_Time_S        <=  (others => '0');
							r_Latitude      <=  (others => '0');
							r_Latitude_D    <=  (others => '0');
							r_Latitude_M    <=  (others => '0');
							r_Longitude     <=  (others => '0');
							r_Longitude_D   <=  (others => '0');
							r_Longitude_M   <=  (others => '0');
							r_Altitude      <=  (others => '0'); 
							r_Altitude_sign	<=	'0'; 
							
							r_Busy	<=	'1';
							r_State <=  s2;
						end if;
					when s2     =>
						if (get_ascii(i_GPS_Data) = 'G') then
							r_State <=  s3;
						else
							r_State <=  s1;
						end if;
					when s3     =>
						if (get_ascii(i_GPS_Data) = 'P') then
							r_State <=  s4;
						else
							r_State <=  s1;
						end if;
					when s4     =>
						if (get_ascii(i_GPS_Data) = 'G') then
							r_State <=  s5;
						else
							r_State <=  s1;
						end if;
					when s5     => 
						if (get_ascii(i_GPS_Data) = 'G') then
							r_State <=  s6;
						else
							r_State <=  s1;
						end if;
					when s6     =>
						r_State <=  s7;    
	
						if (get_ascii(i_GPS_Data) = 'A') then
							r_Field_Cntr    <=  0; 
						end if;
					when s7     =>
                        case r_Field_Cntr is
                            when 1 =>
                                if (r_Digit_Cntr < 2) then
                                    r_Time_H  <=  mult_10(r_Time_H) + resize(unsigned(r_Digit), r_Time_H'length);        
                                elsif (r_Digit_Cntr >= 2 and r_Digit_Cntr < 4) then
                                    r_Time_M  <=  mult_10(r_Time_M) + resize(unsigned(r_Digit), r_Time_M'length);
                                    if (r_Digit_Cntr = 2) then
                                        r_Time_H  <=  mult_60(r_Time_H);
                                    end if;
                                elsif (r_Digit_Cntr >= 4 and r_Digit_Cntr < 6) then
                                    r_Time_S  <=  mult_10(r_Time_S) + resize(unsigned(r_Digit), r_Time_S'length);
                                    if (r_Digit_Cntr = 4) then
                                        r_Time_H  <=  mult_60(r_Time_H);
                                        r_Time_M  <=  mult_60(r_Time_M);
                                    end if;
                                elsif (r_Digit_Cntr = 6) then           -- period
                                    r_Time <=   resize(r_Time_H, r_Time'length) + resize(r_Time_M, r_Time'length) + resize(r_Time_S, r_Time'length);
                                elsif (r_Digit_Cntr > 6 and r_Digit_Cntr <= 9) then
                                    r_Time  <=  mult_10(r_Time) + resize(unsigned(r_Digit), r_Time'length);
                                end if;
                            when 2 =>
                                if (r_Digit_Cntr < 2) then
                                    r_Latitude_D    <=  mult_10(r_Latitude_D) + resize(unsigned(r_Digit), r_Latitude_D'length);
                                elsif (r_Digit_Cntr >= 2 and r_Digit_Cntr < 4) then
                                    r_Latitude_M    <=  mult_10(r_Latitude_M) + resize(unsigned(r_Digit), r_Latitude_M'length);
                                    if (r_Digit_Cntr = 2) then
                                        r_Latitude_D  <=  mult_60(r_Latitude_D);
                                    end if;
                                elsif (r_Digit_Cntr = 4) then           -- period
                                    r_Latitude <=   signed(resize(r_Latitude_D, r_Latitude'length)) + signed(resize(r_Latitude_M, r_Latitude'length));
                                elsif (r_Digit_Cntr > 4 and r_Digit_Cntr < 9) then
                                    r_Latitude  <=  mult_10(r_Latitude) + signed(resize(unsigned(r_Digit), r_Latitude'length));
                                end if;
                            when 3 =>
                                if (get_ascii(r_GPS_Data) = 'S') then
                                    r_Latitude	<=	to_signed(0, r_Latitude'length) - r_Latitude;
                                end if;
                            when 4 =>
                                if (r_Digit_Cntr < 3) then
                                    r_Longitude_D	<=	mult_10(r_Longitude_D) + resize(unsigned(r_Digit), r_Longitude_D'length);
                                elsif (r_Digit_Cntr >= 3 and r_Digit_Cntr < 5) then
                                    r_Longitude_M	<=	mult_10(r_Longitude_M) + resize(unsigned(r_Digit), r_Longitude_M'length);
                                    if (r_Digit_Cntr = 3) then
                                        r_Longitude_D	<=	mult_60(r_Longitude_D);
                                    end if;
                                elsif (r_Digit_Cntr = 5) then			-- period
                                    r_Longitude	<=	signed(resize(r_Longitude_D, r_Longitude'length)) + signed(resize(r_Longitude_M, r_Longitude'length));
                                elsif (r_Digit_Cntr > 5 and r_Digit_Cntr <= 9) then
                                    r_Longitude	<=	mult_10(r_Longitude) + signed(resize(unsigned(r_Digit), r_Longitude'length));
                                end if;
                            when 5 =>
                                if (get_ascii(r_GPS_Data) = 'W') then
                                    r_Longitude	<=	to_signed(0, r_Longitude'length) - r_Longitude;
                                end if;
                            when 6 =>
                                if (get_ascii(r_GPS_Data) = '2') then
                                    r_Position_Fix	<=	'1';
                                end if;
                            when 9 =>
                                if (r_Digit_Cntr = 0 and get_ascii(r_GPS_Data) = '-') then
                                    r_Altitude_Sign	<=	'1';
                                elsif (get_ascii(i_GPS_Data) /= '.' and r_Digit_Cntr < 4) then
                                    r_Altitude	<=	mult_10(r_Altitude) + signed(resize(unsigned(r_Digit), r_Altitude'length));
                                end if;
                            when 10 =>
                                r_Busy		<=	'0';
                                r_Valid		<=	r_Position_Fix;
        
                                if (r_Altitude_Sign = '1') then
                                    r_Altitude	<=	to_signed(0, r_Altitude'length) - r_Altitude;
                                end if;
                            when 11 =>
                                r_Valid			<=	'0';
                                r_Position_Fix	<=	'0';
                                r_State         <=  s1; 
        
                            when others =>
                                null;
                        end case;
    
                    when others =>
						r_State <=  s1;
				end case;
			end if;
        end if;

    end process;

	r_Digit	<=	i_GPS_Data(3 downto 0);
	o_Valid	<=	r_Valid;
	o_Busy	<=	r_Busy;
	o_Time     	<=	std_logic_vector(r_Time); 
	o_Latitude 	<=	std_logic_vector(r_Latitude); 
	o_Longitude	<=	std_logic_vector(r_Longitude); 
	o_Altitude 	<=	std_logic_vector(r_Altitude); 

end architecture;