onerror {quit -code 1}
source "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/Interface/UART/uart/vunit_out/test_output/vw_lib.uart_tb.test_uabbb029e99e279e3ef09a56140952d698d033ed72/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
