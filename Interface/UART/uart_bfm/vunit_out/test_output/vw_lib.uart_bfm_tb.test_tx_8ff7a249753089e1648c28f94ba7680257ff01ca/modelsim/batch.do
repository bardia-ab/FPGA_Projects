onerror {quit -code 1}
source "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm/vunit_out/test_output/vw_lib.uart_bfm_tb.test_tx_8ff7a249753089e1648c28f94ba7680257ff01ca/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
