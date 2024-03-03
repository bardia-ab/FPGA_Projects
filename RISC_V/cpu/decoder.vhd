library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;
----------------------------------
entity decoder is
	port(
		i_clk       :   in      std_logic;
		i_rst       :   in      std_logic;
		i_en        :   in      std_logic;

		-- Instruction word (little-endian)
		i_ram_dout  :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);

		-- Instruction fields
		o_op        :   out     t_op;
		o_rd        :   out     std_logic_vector(4 downto 0);
		o_rs_1      :   out     std_logic_vector(4 downto 0);
		o_rs_2      :   out     std_logic_vector(4 downto 0);
		o_imm_i     :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_imm_s     :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_imm_b     :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_imm_u     :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_imm_j     :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0)
	);
end entity;
----------------------------------
architecture rtl of decoder is

	signal  r_instr  	:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_opcode 	:   std_logic_vector(6 downto 0);
	signal  r_funct_7	:   std_logic_vector(6 downto 0);
	signal  r_funct_3	:   std_logic_vector(2 downto 0);

	signal  r_op     	:   t_op;
	signal  r_rd     	:   std_logic_vector(4 downto 0);
	signal  r_rs_1   	:   std_logic_vector(4 downto 0);
	signal  r_rs_2   	:   std_logic_vector(4 downto 0);
	signal  r_imm_i  	:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_imm_s  	:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_imm_b  	:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_imm_u  	:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_imm_j  	:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);

begin

	r_instr <=  convert_endianness(i_ram_dout);

	-- Figure 2.2 page 16
	r_funct_7	<=  r_instr(31 downto 25);
	r_funct_3	<=  r_instr(14 downto 12);
	r_opcode 	<=  r_instr(6 downto 0);

	Immediate   :   process(i_clk)
	begin
		if rising_edge(i_clk) then
			if (i_rst = '1') then
				r_rd   	<=  (others => '0');
				r_rs_1 	<=  (others => '0');
				r_rs_2 	<=  (others => '0');
				r_imm_i	<=  (others => '0');
				r_imm_s	<=  (others => '0');
				r_imm_b	<=  (others => '0');
				r_imm_u	<=  (others => '0');
				r_imm_j	<=  (others => '0');
			else
				if (i_en = '1') then
					-- Figure 2.2 page 16
					r_rs_2  <=  r_instr(24 downto 20);  
					r_rs_1	<=  r_instr(19 downto 15);
					r_rd		<=  r_instr(11 downto 7);
					
					--Figure 2.4 page 17
					r_imm_i(31 downto 11)  <=  (others => r_instr(31));
					r_imm_i(10 downto 0)   <=  r_instr(30 downto 20);

					r_imm_s(31 downto 11)  <=  (others => r_instr(31));
					r_imm_s(10 downto 5)   <=  r_instr(30 downto 25);
					r_imm_s(4 downto 0)    <=  r_instr(11 downto 7);

					r_imm_b(31 downto 12)  <=  (others => r_instr(31));
					r_imm_b(11)            <=  r_instr(7);
					r_imm_b(10 downto 5)   <=  r_instr(30 downto 25);
					r_imm_b(4 downto 1)    <=  r_instr(11 downto 8);
					r_imm_b(0)             <=  '0';

					r_imm_u(31 downto 12)  <=  r_instr(31 downto 12);
					r_imm_u(11 downto 0)   <=  (others => '0');

					r_imm_j(31 downto 20)  <=  (others => r_instr(31));
					r_imm_j(19 downto 12)  <=  r_instr(19 downto 12);
					r_imm_j(11)            <=  r_instr(20);
					r_imm_j(10 downto 5)   <=  r_instr(30 downto 25);
					r_imm_j(4 downto 1)    <=  r_instr(24 downto 21);
					r_imm_j(0)             <=  '0';

				end if;
			end if;
		end if;
	end process;

	Decode_Opcode   :   process(i_clk)
	begin
		if rising_edge(i_clk) then
			if (i_rst = '1') then
				r_op    <=  NOP;
			else
				-- RV32I Base Instruction Set page 130
				if (i_en = '0') then
					null;

				elsif (r_opcode = "0010011" and r_funct_3 = "000") then
					r_op    <=  ADDI;

				elsif (r_opcode = "0110111") then
					r_op    <=  LUI;

				elsif (r_opcode = "0100011" and r_funct_3 = "000") then
					r_op    <=  SB;

				elsif (r_opcode = "0000011" and r_funct_3 = "100") then
					r_op    <=  LBU;

				elsif (r_opcode = "1100011" and r_funct_3 = "000") then
					r_op    <=  BEQ;

				elsif (r_opcode = "1100011" and r_funct_3 = "001") then
					r_op    <=  BNE;

				elsif (r_opcode = "1101111") then
					r_op    <=  JAL;

				elsif (r_opcode = "1100111" and r_funct_3 = "000") then
					r_op    <=  JALR;

				else
					r_op    <=  UNKNOWN;
					
				end if;
			end if;
		end if;
	end process;

	o_op   	<=  r_op;
	o_rd   	<=  r_rd;
	o_rs_1 	<=  r_rs_1;
	o_rs_2 	<=  r_rs_2;
	o_imm_i	<=  r_imm_i;
	o_imm_s	<=  r_imm_s;
	o_imm_b	<=  r_imm_b;
	o_imm_u	<=  r_imm_u;
	o_imm_j	<=  r_imm_j;

end architecture;