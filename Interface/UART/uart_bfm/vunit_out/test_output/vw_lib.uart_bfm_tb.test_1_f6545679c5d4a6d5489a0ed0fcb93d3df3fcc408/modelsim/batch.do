onerror {quit -code 1}
source "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm/vunit_out/test_output/vw_lib.uart_bfm_tb.test_1_f6545679c5d4a6d5489a0ed0fcb93d3df3fcc408/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
