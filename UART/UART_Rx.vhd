library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use	IEEE.math_real.all;
use ieee.std_logic_misc.all;
-----------------------------------------
entity UART_Rx is
	generic(
		g_Parity	:	std_logic_vector(0 downto 0)	:= "0";
		g_N_Bits	:	integer							:=	8;
		g_Baud_Rate	:	integer							:=	9600;
		g_Frequency	:	integer							:=	1e8		-- In Hertz
	);
	port(
		i_Clk		:	in		std_logic;
		i_Rx		:	in		std_logic;
		o_Valid		:	out		std_logic;
		o_Busy		:	out		std_logic;
		o_Data_Out	:	out		std_logic_vector((g_N_Bits - 1) downto 0)
	);
end entity;
-----------------------------------------
Architecture Behavioral of UART_Rx is

	-------- Types --------
	type t_States is (s_IDLE, s_ADJUST_SAMPLER, s_RECEIVE, s_END_BIT);
	
	-------- Constants --------
	constant	c_Clks_Per_Bit		:	integer		:=	integer(ceil(real(g_Frequency) / real(g_Baud_Rate)));
	constant	c_Packet_Width		:	integer		:=	g_N_Bits + 1 + to_integer(unsigned(g_Parity));
	-------- Internal Signals --------			
	signal	r_State				    :	t_States									:=	s_IDLE;
	signal	r_Parity_Bit			:	std_logic									:=	'0';
	signal	r_Rx			        :	std_logic									:=	'1';
	signal	r_Valid			        :	std_logic									:=	'0';
	signal	r_Busy			        :	std_logic									:=	'0';
	signal	r_Data_Out		        :	std_logic_vector((c_Packet_Width - 1) downto 0)	:=	(others => '0');
	
	-------- Counters --------
	signal	r_Bit_Index	            :	integer range 0 to (c_Packet_Width - 1)			:=	0;
	signal	r_Bit_Width_Cntr	    :	integer range 0 to (c_Clks_Per_Bit - 1)	    :=	(c_Clks_Per_Bit - 1);
	
begin

	process(i_Clk)
	
	begin
	
		if (i_Clk'event and i_Clk = '1') then
			r_Rx	    <=	i_Rx;
            r_Valid	    <=	'0';
			
			case	r_State	is
			
			when	s_IDLE			=>
                r_Busy	<=	'0';

                if (r_Rx = '1' and i_Rx = '0') then
                    r_Bit_Width_Cntr    <=  r_Bit_Width_Cntr - 1;
                    r_State		        <=	s_ADJUST_SAMPLER;
                    r_Busy	            <=	'1';
                    r_Valid	    <=	'0';
                end if;
							
			when	s_ADJUST_SAMPLER	=>
                if (r_Bit_Width_Cntr > (c_Clks_Per_Bit / 2)) then
                    r_Bit_Width_Cntr	<=	r_Bit_Width_Cntr - 1;
                else
                	r_Bit_Width_Cntr			<=	(c_Clks_Per_Bit - 1);
                	
                    if (i_Rx = '1') then
                        r_State <=  s_IDLE;
                    else
                        r_Data_Out(r_Bit_Index)		<=	i_Rx;
                        r_Bit_Index					<=	r_Bit_Index + 1;
                        r_State	                    <=	s_RECEIVE;
                    end if;
                end if;
							
			when	s_RECEIVE		=>
                if (r_Bit_Width_Cntr > 0) then
                    r_Bit_Width_Cntr	<=	r_Bit_Width_Cntr - 1; 
                else
                    r_Data_Out(r_Bit_Index)		<=	i_Rx;
                    r_Bit_Width_Cntr            <=  (c_Clks_Per_Bit - 1);

                    if (r_Bit_Index < (c_Packet_Width - 1)) then
                        r_Bit_Index	<=	r_Bit_Index + 1;
                    else
                        r_Bit_Index	<=	0;
                        r_State		<=	s_END_BIT;
						
                    end if; 
                end if;
														
			when    s_END_BIT   =>
--                if (r_Bit_Width_Cntr > (c_Clks_Per_Bit / 2)) then
--                    r_Bit_Width_Cntr	<=	r_Bit_Width_Cntr - 1;
--                else
--                	r_Bit_Width_Cntr    <=  (c_Clks_Per_Bit - 1);
--                    r_State				<=	s_IDLE;

--                    if (i_Rx = '0') then
--                        r_Valid <=  '0';
--                    else
--                        r_Valid <=  r_Parity_Bit;
--                    end if;
--                end if;
				if (i_Rx = '1') then
					if (i_Rx = '0') then
                        r_Valid <=  '0';
                    else
                        r_Valid <=  r_Parity_Bit;
                    end if;
                    r_State	<=	s_IDLE;
				end if;

            when	others	    =>
                r_State			<=	s_IDLE;
							
			end case;
			
		end if;
	
	end process;
	
	r_Parity_Bit	<=	xnor_reduce (r_Data_Out(g_N_Bits + 1 downto 1)) when (g_Parity = "1") else '1';
	o_Valid			<=	r_Valid;
	o_Busy			<=	r_Busy;
	o_Data_Out		<=	r_Data_Out(g_N_Bits downto 1);


end Architecture;