# clock
set_property -dict {PACKAGE_PIN AH18 IOSTANDARD DIFF_SSTL12} [get_ports i_clk_p];
set_property -dict {PACKAGE_PIN AH17 IOSTANDARD DIFF_SSTL12} [get_ports i_clk_n];

# reset
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports i_rst];

# uart
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS18} [get_ports i_Rx];
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS18} [get_ports o_Tx];