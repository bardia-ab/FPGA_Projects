onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /traffic_lights_tb/clk
add wave -noupdate /traffic_lights_tb/rst
add wave -noupdate -radix unsigned /traffic_lights_tb/DUT/counter
add wave -noupdate /traffic_lights_tb/DUT/state
add wave -noupdate -divider {North / South}
add wave -noupdate /traffic_lights_tb/north_red
add wave -noupdate /traffic_lights_tb/north_yellow
add wave -noupdate /traffic_lights_tb/north_green
add wave -noupdate -divider {West / East}
add wave -noupdate /traffic_lights_tb/west_red
add wave -noupdate /traffic_lights_tb/west_yellow
add wave -noupdate /traffic_lights_tb/west_green
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20892651757188 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits sec
update
WaveRestoreZoom {0 ns} {315 sec}
