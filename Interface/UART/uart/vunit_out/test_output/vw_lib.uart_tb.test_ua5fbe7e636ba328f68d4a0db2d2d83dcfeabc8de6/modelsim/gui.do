source "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/Interface/UART/uart/vunit_out/test_output/vw_lib.uart_tb.test_ua5fbe7e636ba328f68d4a0db2d2d83dcfeabc8de6/modelsim/common.do"
proc vunit_user_init {} {

    set vunit_tb_path "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/Interface/UART/uart"
    set file_name "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/Interface/UART/uart/wave.do"
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
