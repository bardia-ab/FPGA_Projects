onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB /top_tb/clk
add wave -noupdate -group TB /top_tb/rst_async
add wave -noupdate -group TB /top_tb/uart_rx
add wave -noupdate -group TB /top_tb/uart_tx
add wave -noupdate -group TB /top_tb/uart_rx_fifo_full
add wave -noupdate -group TB /top_tb/uart_rx_stop_bit_error
add wave -noupdate -group TB /top_tb/data_out
add wave -noupdate -group TB /top_tb/data_out_valid
add wave -noupdate -group MEM /top_tb/DUT/RISC_V/Memory/i_clk
add wave -noupdate -group MEM /top_tb/DUT/RISC_V/Memory/i_wr_en
add wave -noupdate -group MEM /top_tb/DUT/RISC_V/Memory/i_addr
add wave -noupdate -group MEM /top_tb/DUT/RISC_V/Memory/i_din
add wave -noupdate -group MEM /top_tb/DUT/RISC_V/Memory/r_mem
add wave -noupdate -group MEM /top_tb/DUT/RISC_V/Memory/o_dout
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/i_op
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/i_src_1
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/i_src_2
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/o_res
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/r_src_1
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/r_src_2
add wave -noupdate -group ALU /top_tb/DUT/RISC_V/ALU/r_res
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/i_clk
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/i_rst
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/i_en
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/i_ram_dout
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_op
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_rd
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_rs_1
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_rs_2
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_imm_i
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_imm_s
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_imm_b
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_imm_u
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/o_imm_j
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_instr
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_opcode
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_funct_7
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_funct_3
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_op
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_rd
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_rs_1
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_rs_2
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_imm_i
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_imm_s
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_imm_b
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_imm_u
add wave -noupdate -group Decoder /top_tb/DUT/RISC_V/Decode/r_imm_j
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_clk
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_rst
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_op
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_rd
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_rs_1
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_rs_2
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_imm_i
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_imm_s
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_imm_b
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_imm_u
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_imm_j
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_en_decoder
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_res_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_op_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_src_1_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_src_2_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/i_dout_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_wr_en_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_byte_addr_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_din_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_uart_tx_data
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/o_uart_tx_valid
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_state
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_pc
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_curr_pc
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_regs
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_wr_back
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_en_decoder
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_op_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_src_1_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_src_2_alu
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_wr_en_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_byte_addr_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_din_ram
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_uart_tx_data
add wave -noupdate -expand -group Control /top_tb/DUT/RISC_V/Controller/r_uart_tx_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5109919 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 323
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {5059775 ps} {5194101 ps}
