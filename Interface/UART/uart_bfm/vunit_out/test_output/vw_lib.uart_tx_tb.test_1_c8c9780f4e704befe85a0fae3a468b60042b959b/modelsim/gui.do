source "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm/vunit_out/test_output/vw_lib.uart_tx_tb.test_1_c8c9780f4e704befe85a0fae3a468b60042b959b/modelsim/common.do"
proc vunit_user_init {} {

    set vunit_tb_path "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm"
    set file_name "C:/Users/t26607bb/Desktop/Practice/BFM/uart_bfm/wave.do"
    puts "Sourcing file ${file_name} from modelsim.init_file.gui"
    if {[catch {source ${file_name}} error_msg]} {
        puts "Sourcing ${file_name} failed"
        puts ${error_msg}
        return true
    }
    return 0
}
if {![vunit_load]} {
  vunit_user_init
  vunit_help
}
