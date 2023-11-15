library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
--------------------------------------
entity BRAM is 
    generic(
		g_Init_File		:	string	:= "";
        g_Data_Width    :   integer := 32;
        g_Addr_Width    :   integer := 9
    );
    port(
        i_Clk           :   in      std_logic;
        i_Enable        :   in      std_logic;
        i_RW            :   in      std_logic;  -- R = '1'  W = '0'
        i_Addr          :   in      std_logic_vector(g_Addr_Width - 1 downto 0);
        i_Data_In       :   in      std_logic_vector(g_Data_Width - 1 downto 0);
        o_Data_Out      :   out     std_logic_vector(g_Data_Width - 1 downto 0)
    );
end entity;    
--------------------------------------
architecture behavioral of BRAM is

    type t_Mem is array (0 to 2 ** g_Addr_Width - 1) of std_logic_vector(g_Data_Width - 1 downto 0);
	impure function init_ram (txt_file	:	string) return t_Mem is
		file fin				:	text open read_mode is txt_file;
		variable	v_Line		:	line;
		variable	v_Mem		:	t_Mem										:= (others => (others => '0'));
		variable	v_Idx		:	integer range 0 to 2 ** g_Addr_Width - 1	:= 0;
	begin
		if (txt_file /= "") then
			while not(endfile(fin)) loop
				readline(fin, v_line);
				read(v_Line, v_Mem(v_Idx));
				v_Idx	:=	v_Idx + 1;
			end loop;
		end if;
		return v_Mem;
	end init_ram;
	
    signal r_Ram : t_Mem	:=	init_ram(g_Init_File);

    attribute ram_style :   string;
    attribute ram_style of r_Ram    :   signal is "block";

begin
    
    process(i_Clk)
    begin
        if (i_Clk'event and i_Clk = '1') then
            if (i_Enable = '1') then
                if (i_RW = '0') then
                    r_Ram(to_integer(unsigned(i_Addr))) <=  i_Data_In;
                else
                    o_Data_Out  <=  r_Ram(to_integer(unsigned(i_Addr)));
                end if;
            end if;
        end if;
    end process;

end architecture;    