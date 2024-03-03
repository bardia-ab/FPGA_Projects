library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------
package riscv_pkg is

	-- each word is 32 bits
	constant c_ram_word_width_bits   :   natural := 32;

	-- number of bytes in each word
	constant    c_word_bytes    :   integer :=  c_ram_word_width_bits/8;

	-- 1024 32-bit words
	constant c_ram_word_addr_bits   :   natural := 10;

	-- each word has 4 bytes = 2**2
	constant c_ram_byte_addr_bits   :   natural := c_ram_word_addr_bits + 2;

	-- memory mapped address of the UART Tx interface
	constant c_uart_tx_mem_addr     :   std_logic_vector(c_ram_word_width_bits - 1 downto 0)    := x"10000000";

	-- RISC-V operations
	type t_op is (
		NOP,        -- no operation
		UNKNOWN,    -- instruction not recognized
		ADDI,       -- add immediate
		LUI,        -- load upper immediate
		SB,         -- store byte
		LBU,        -- load byte unsigned
		BEQ,        -- branch if equal
		BNE,        -- branch if not equal
		JAL,        -- jump and link
		JALR        -- jump and link register
	);

	-- ALUT operations
	type t_alu_op is (ADD, SUB);
	
	-- convert endianness
	function convert_endianness(word    :   std_logic_vector) return std_logic_vector;

	procedure debug_unsupported_instruction;

end package;
---------------------------------
package body riscv_pkg is

	function convert_endianness(word    :   std_logic_vector) return std_logic_vector is
			variable    v_converted     :   std_logic_vector(word'length - 1 downto 0);
	begin
			for i in 0 to (c_word_bytes - 1) loop
					v_converted(8 * (i + 1) - 1 downto (8 * i)) := word(8 * (c_word_bytes - i) - 1 downto 8 * (c_word_bytes - i - 1));
			end loop;

			return v_converted;

	end function;

	procedure debug_unsupported_instruction is
			alias instr is << signal DUT.RISCV.DECODER.instr : std_logic_vector >>;
			alias opcode is << signal DUT.RISCV.DECODER.opcode : std_logic_vector >>;
			alias funct3 is << signal DUT.RISCV.DECODER.funct3 : std_logic_vector >>;
			alias funct7 is << signal DUT.RISCV.DECODER.funct7 : std_logic_vector >>;
			alias rs1 is << signal DUT.RISCV.DECODER.rs1 : std_logic_vector >>;
			alias rs2 is << signal DUT.RISCV.DECODER.rs2 : std_logic_vector >>;
			alias rd is << signal DUT.RISCV.DECODER.rd : std_logic_vector >>;
			alias imm_i is << signal DUT.RISCV.DECODER.imm_i : std_logic_vector >>;
			alias imm_s is << signal DUT.RISCV.DECODER.imm_s : std_logic_vector >>;
			alias imm_b is << signal DUT.RISCV.DECODER.imm_b : std_logic_vector >>;
			alias imm_u is << signal DUT.RISCV.DECODER.imm_u : std_logic_vector >>;
			alias imm_j is << signal DUT.RISCV.DECODER.imm_j : std_logic_vector >>;
		begin
			
			report "Unsupported instruction 0x" & to_hstring(instr) &
				" (little-endian: 0x" & to_hstring(convert_endianness(instr)) & ")" & LF & LF &
				"opcode: 0b" & to_string(opcode) & LF &
				"funct3: 0b" & to_string(funct3) & LF &
				"funct7: 0b" & to_string(funct7) & LF & LF &
				"rs1: 0d" & to_string(to_integer(unsigned(rs1))) & LF &
				"rs2: 0d" & to_string(to_integer(unsigned(rs2))) & LF &
				"rd:  0d" & to_string(to_integer(unsigned(rd))) & LF & LF &
				"imm_i: 0x" & to_hstring(imm_i) & LF &
				"imm_s: 0x" & to_hstring(imm_s) & LF &
				"imm_b: 0x" & to_hstring(imm_b) & LF &
				"imm_u: 0x" & to_hstring(imm_u) & LF &
				"imm_j: 0x" & to_hstring(imm_j)
				severity failure;
	
		end procedure;

end package body;