onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {BFM TX} /uart_tb/rx
add wave -noupdate -expand -group {BFM TX} /uart_tb/busy_bfm_tx
add wave -noupdate -expand -group {BFM TX} /uart_tb/send_bfm
add wave -noupdate -expand -group {BFM TX} /uart_tb/data_bfm_tx
add wave -noupdate -group {BFM RX} /uart_tb/tx
add wave -noupdate -group {BFM RX} /uart_tb/busy_bfm_rx
add wave -noupdate -group {BFM RX} /uart_tb/valid_bfm
add wave -noupdate -group {BFM RX} /uart_tb/data_bfm_rx
add wave -noupdate -expand -group {UART RX} /uart_tb/valid_rx
add wave -noupdate -expand -group {UART RX} /uart_tb/busy_rx
add wave -noupdate -expand -group {UART RX} /uart_tb/data_rx
add wave -noupdate -expand -group {UART RX} /uart_tb/rx
add wave -noupdate -group {UART TX} /uart_tb/busy_tx
add wave -noupdate -group {UART TX} /uart_tb/tx
add wave -noupdate -group {UART TX} /uart_tb/send
add wave -noupdate -group {UART TX} /uart_tb/data_tx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {189 ps}
