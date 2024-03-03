onerror {quit -code 1}
source "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/RISC_V/vunit_out/test_output/vw_lib.top_tb.test_1_6d76266974d2cb6477bc9037949fbad190d3b9ff/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
