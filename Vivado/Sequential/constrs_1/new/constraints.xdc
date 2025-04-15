create_clock -period 7.000 -name clk -waveform {0.000 3.500} -add clk


set_property IOSTANDARD LVCMOS33 [get_ports trap]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property PACKAGE_PIN F22 [get_ports resetn]
set_property PACKAGE_PIN T22 [get_ports trap]
