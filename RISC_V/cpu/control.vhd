library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;
----------------------------------
entity control is
	port(
		i_clk               :   in      std_logic;
		i_rst               :   in      std_logic;
		
		-- Decoder Interface
		i_op                :   in      t_op;
		i_rd                :   in      std_logic_vector(4 downto 0);
		i_rs_1              :   in      std_logic_vector(4 downto 0);
		i_rs_2              :   in      std_logic_vector(4 downto 0);
		i_imm_i            :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		i_imm_s            :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		i_imm_b            :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		i_imm_u            :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		i_imm_j            :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_en_decoder        :   out     std_logic;

		-- ALU Interface
		i_res_alu           :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_op_alu            :   out     t_alu_op;
		o_src_1_alu         :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_src_2_alu         :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);

		-- RAM Interface
		i_dout_ram          :   in      std_logic_vector(c_ram_word_width_bits - 1 downto 0);
		o_wr_en_ram         :   out     std_logic;
		o_byte_addr_ram     :   out     std_logic_vector(c_ram_byte_addr_bits - 1 downto 0);
		o_din_ram           :   out     std_logic_vector(c_ram_word_width_bits - 1 downto 0);

		-- UART Interface
		o_uart_tx_data      :   out     std_logic_vector(7 downto 0);
		o_uart_tx_valid     :   out     std_logic
	);
end entity;
----------------------------------
architecture rtl of control is

	type t_states is (
		S_FETCH_1,
		S_FETCH_2,
		S_DECODE_1,
		S_DECODE_2,
		S_EXECUTE_1,
		S_EXECUTE_2,
		S_MEM_READ_1,
		S_MEM_READ_2,
		S_MEM_WRITE,
		S_WRITEBACK
	);
	type t_regs is array(0 to 31) of std_logic_vector(c_ram_word_width_bits - 1 downto 0);

	signal  r_state         :   t_states;
	signal  r_pc            :   unsigned(31 downto 0);
	signal  r_curr_pc       :   unsigned(31 downto 0);
	signal  r_regs          :   t_regs;
	signal  r_wr_back       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);

	signal  r_en_decoder    :   std_logic;
	signal  r_op_alu        :   t_alu_op;
	signal  r_src_1_alu 		:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_src_2_alu 		:   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_wr_en_ram     :   std_logic;
	signal  r_byte_addr_ram :   std_logic_vector(c_ram_byte_addr_bits - 1 downto 0);
	signal  r_din_ram       :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	signal  r_uart_tx_data  :   std_logic_vector(7 downto 0);
	signal  r_uart_tx_valid :   std_logic;

	-- signal  r_src_1_alu         :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);
	-- signal  r_src_2_alu         :   std_logic_vector(c_ram_word_width_bits - 1 downto 0);

begin

	process(i_clk)
		variable    v_byte  :   std_logic_vector(7 downto 0);
	begin
		if rising_edge(i_clk) then

			if (i_rst = '1') then
				r_en_decoder    <=  '0';
				r_op_alu        <=  ADD;
				r_src_1_alu 		<=  (others => '0');
				r_src_2_alu 		<=  (others => '0');
				r_wr_en_ram     <=  '0';
				r_byte_addr_ram <=  (others => '0');
				r_din_ram       <=  (others => '0');
				r_uart_tx_data  <=  (others => '0');
				r_uart_tx_valid <=  '0';
				r_state         <=  S_FETCH_1;
				r_pc            <=  (others => '0');
				r_curr_pc       <=  (others => '0');
				r_regs          <=  (others => (others => '0'));
				r_wr_back       <=  (others => '0');

			else
				r_en_decoder    <=  '0';
				r_wr_en_ram     <=  '0';
				r_uart_tx_valid <=  '0';

				case r_state is
				when    S_FETCH_1       =>
					r_byte_addr_ram <=  std_logic_vector(r_pc(c_ram_byte_addr_bits - 1 downto 0));
					r_curr_pc       <=  r_pc;
					r_pc            <=  r_pc + c_word_bytes;
					r_state         <=  S_FETCH_2;

				when    S_FETCH_2       =>
					r_en_decoder    <=  '1';
					r_state         <=  S_DECODE_1;

				when    S_DECODE_1      =>
					r_state         <=  S_DECODE_2;

				when    S_DECODE_2      =>
					DECODE_OP_CASE: case i_op is

						when ADDI | LBU | JALR =>
							r_op_alu    <=  ADD;
							r_src_1_alu <=  r_regs(to_integer(unsigned(i_rs_1)));
							r_src_2_alu <=  i_imm_i;
							r_state     <=  S_EXECUTE_1;

						when LUI =>
							r_state     <=  S_EXECUTE_1;

						when SB =>
							r_op_alu    <=  ADD;
							r_src_1_alu <=  r_regs(to_integer(unsigned(i_rs_1)));
							r_src_2_alu <=  i_imm_s;
							r_state     <=  S_MEM_WRITE;

						when BEQ | BNE =>
							r_op_alu    <=  SUB;
							r_src_1_alu <=  r_regs(to_integer(unsigned(i_rs_1)));
							r_src_2_alu <=  r_regs(to_integer(unsigned(i_rs_2)));
							r_state     <=  S_EXECUTE_1;

						when JAL =>
							r_op_alu    <=  ADD;
							r_src_1_alu <=  i_imm_j;
							r_src_2_alu <=  std_logic_vector(r_curr_pc);
							r_state     <=  S_EXECUTE_1;

						when others =>
							null;
							debug_unsupported_instruction;

					end case DECODE_OP_CASE;

				when    S_EXECUTE_1     =>
					EXECUTE_1_OP_CASE: case i_op is
						
						when ADDI =>
							r_wr_back   <=  i_res_alu;
							r_state     <=  S_WRITEBACK;

						when LUI =>
							r_wr_back   <=  i_imm_u;
							r_state     <=  S_WRITEBACK;

						when LBU =>
							r_byte_addr_ram <=  i_res_alu(c_ram_byte_addr_bits - 1 downto 0);
							r_state     <=  S_MEM_READ_1;

						when BEQ =>
							if (i_res_alu = x"00000000") then
								r_op_alu    <=  ADD;
								r_src_1_alu <=  std_logic_vector((r_curr_pc));
								r_src_2_alu <=  i_imm_b;
								r_state     <=  S_EXECUTE_2;
							else
								r_state     <=  S_FETCH_1;
							end if;

						when BNE =>
							if (i_res_alu /= x"00000000") then
								r_op_alu    <=  ADD;
								r_src_1_alu <=  std_logic_vector((r_curr_pc));
								r_src_2_alu <=  i_imm_b;
								r_state     <=  S_EXECUTE_2;
							else
								r_state     <=  S_FETCH_1;
							end if;

						when JAL | JALR =>
							r_pc        <=  unsigned(i_res_alu);
							r_wr_back   <=  std_logic_vector(r_pc);
							r_state     <=  S_WRITEBACK;

						when others =>
							null;

					end case EXECUTE_1_OP_CASE;

				when    S_EXECUTE_2     => 
					EXECUTE_2_OP_CASE: case i_op is
						when BEQ | BNE =>
							r_pc        <=  unsigned(i_res_alu);
							r_state     <=  S_FETCH_1;

						when others =>
							null;

					end case EXECUTE_2_OP_CASE;

				when    S_MEM_READ_1    =>
					r_state         <=  S_MEM_READ_2;

				when    S_MEM_READ_2    =>
					MEM_READ_2_OP_CASE: case i_op is
						
						when LBU =>
							case r_byte_addr_ram(1 downto 0) is
								when "00" =>
									v_byte  :=  i_dout_ram(31 downto 24);   -- memory content is in little-endian

								when "01" =>
									v_byte  :=  i_dout_ram(23 downto 16);

								when "10" =>
									v_byte  :=  i_dout_ram(15 downto 8);

								when others =>  -- "11"
									v_byte  :=  i_dout_ram(7 downto 0);

							end case;

							r_wr_back               <=  (others => '0');
							r_wr_back(7 downto 0)   <=  v_byte;
							r_state     <=  S_WRITEBACK;

						when others =>
							null;

					end case MEM_READ_2_OP_CASE;

				when    S_MEM_WRITE     =>
					MEM_WRITE_OP_CASE: case i_op is
						
						when SB  =>
							if (i_res_alu = c_uart_tx_mem_addr) then
								r_uart_tx_data  <=  r_regs(to_integer(unsigned(i_rs_2)))(7 downto 0);
								r_uart_tx_valid <=  '1';

							else
								report "RAM writes not supported yet!" severity failure;

							end if;

							r_state     <=  S_FETCH_1;

						when others =>
							null;

					end case MEM_WRITE_OP_CASE;

				when    S_WRITEBACK     =>
					r_regs(to_integer(unsigned(i_rd)))  <=  r_wr_back;                    
					r_regs(0)   <=  (others => '0');                    -- Register x0 is tighed into all zeros
					r_state     <=  S_FETCH_1;

				end case;
			end if;
		end if;
	end process;

	o_en_decoder    <=  r_en_decoder;
	o_op_alu        <=  r_op_alu;
	o_src_1_alu     <=  r_src_1_alu;
	o_src_2_alu     <=  r_src_2_alu;
	o_wr_en_ram     <=  r_wr_en_ram;
	o_byte_addr_ram <=  r_byte_addr_ram;
	o_din_ram       <=  r_din_ram;
	o_uart_tx_data  <=  r_uart_tx_data;
	o_uart_tx_valid <=  r_uart_tx_valid;

end architecture;