onerror {quit -code 1}
source "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm/vunit_out/test_output/vw_lib.uart_tx_tb.test_1_c8c9780f4e704befe85a0fae3a468b60042b959b/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
