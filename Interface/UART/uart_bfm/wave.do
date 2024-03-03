onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Tx /uart_bfm_tb/DUT/i_data_tx
add wave -noupdate -expand -group Tx /uart_bfm_tb/DUT/i_send
add wave -noupdate -expand -group Tx /uart_bfm_tb/DUT/o_busy_tx
add wave -noupdate -expand -group Tx /uart_bfm_tb/DUT/o_tx
add wave -noupdate -expand -group Rx /uart_bfm_tb/DUT/i_rx
add wave -noupdate -expand -group Rx /uart_bfm_tb/DUT/o_busy_rx
add wave -noupdate -expand -group Rx /uart_bfm_tb/DUT/o_valid
add wave -noupdate -expand -group Rx /uart_bfm_tb/DUT/o_data_rx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 222
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
WaveRestoreZoom {9999991507 ps} {10000001283 ps}
