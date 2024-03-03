onerror {quit -code 1}
source "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm/vunit_out/test_output/vw_lib.uart_bfm_tb.test_rx_7a9f8e11f5778a60c713416ad1eebc267b5ee68d/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
