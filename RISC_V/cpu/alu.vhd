library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;
----------------------------------
entity alu is
	port (
		i_op    : in t_alu_op;
		i_src_1 : in std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		i_src_2 : in std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_res   : out std_logic_vector(c_ram_word_width_bits - 1 downto 0)
	);
end entity;
----------------------------------
architecture rtl of alu is
    
	signal r_src_1 : signed(c_ram_word_width_bits - 1 downto 0);
	signal r_src_2 : signed(c_ram_word_width_bits - 1 downto 0);
	signal r_res : signed(c_ram_word_width_bits - 1 downto 0);

begin

	process (all)
	begin
		case i_op is
			when ADD =>
				r_res <= r_src_1 + r_src_2;
			when SUB =>
				r_res <= r_src_1 - r_src_2;
		end case;
	end process;

	o_res 	<= std_logic_vector(r_res);
	r_src_1 <= signed(i_src_1);
	r_src_2 <= signed(i_src_2);

end architecture;