source "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/RISC_V/vunit_out/test_output/vw_lib.top_tb.test_1_6d76266974d2cb6477bc9037949fbad190d3b9ff/modelsim/common.do"
proc vunit_user_init {} {

    set vunit_tb_path "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/RISC_V/top"
    set file_name "C:/Users/t26607bb/Desktop/Interface_Course/FPGA_Projects/RISC_V/top/wave.do"
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
