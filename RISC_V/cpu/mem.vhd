library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.riscv_pkg.all;
-----------------------------------
entity mem is
    generic(g_program_hex_file    :   string);
    port(
			i_clk   :   in      std_logic;
			i_wr_en :   in      std_logic;
			i_addr  :   in      std_logic_vector(c_ram_word_addr_bits - 1 downto 0);
			i_din   :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
			o_dout  :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0)
    );
end entity;
-----------------------------------
architecture rtl of mem is
	------------------ Types --------------------------
	subtype st_ram_depth_range is integer range 0 to 2**c_ram_word_addr_bits - 1;
	type t_mem is array(st_ram_depth_range) of std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	------------------ Functions --------------------------
	impure function init_ram_hex return t_mem is
		file        text_file       :   text open read_mode is g_program_hex_file;
		variable    v_line          :   line;
		variable    v_byte          :   std_logic_vector(7 downto 0);
		variable    v_good          :   boolean;
		variable    v_word          :   std_logic_vector(c_ram_word_width_bits - 1 downto 0)    := (others => '0');
		variable    v_byte_idx      :   integer :=  c_word_bytes;
		variable    v_mem_idx       :   st_ram_depth_range  := 0;
		variable    v_mem           :   t_mem;
	begin
		while not endfile(text_file) loop
			readline(text_file, v_line);

			for i in 0 to (c_word_bytes - 1) loop
				hread(v_line, v_byte, v_good);

				if not (v_good) then
					exit;
				end if;

				v_word((8 * v_byte_idx - 1) downto 8 * (v_byte_idx - 1))    :=  v_byte;
				v_mem(v_mem_idx)    :=  v_word;
				v_byte_idx  :=  v_byte_idx - 1;
					
				if (v_byte_idx = 0) then
					v_mem_idx           :=  v_mem_idx + 1;
					v_byte_idx          :=  c_word_bytes;
					v_word              :=  (others => '0');
				end if;

			end loop;
		end loop;

		return v_mem;

	end function;
	------------------ Registers --------------------------
	signal  r_mem   : t_mem   :=  init_ram_hex;
	signal	r_dout	:	std_logic_vector(c_ram_word_width_bits - 1 downto 0);

begin

	process(i_clk)
	begin
		if rising_edge(i_clk) then
			r_dout <= r_mem(to_integer(unsigned(i_addr)));

			if (i_wr_en = '1') then
				r_mem(to_integer(unsigned(i_addr))) <=  i_din;
				
			end if; 
		end if;
	end process;

	o_dout <= r_dout;

end architecture;