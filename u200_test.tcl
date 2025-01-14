startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:sender:1.0 sender_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:receiver:1.0 receiver_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:network_throttle:1.0 network_throttle_0
endgroup
connect_bd_intf_net [get_bd_intf_ports out_data] [get_bd_intf_pins network_throttle_0/data_out]
connect_bd_intf_net [get_bd_intf_ports in_data] [get_bd_intf_pins receiver_0/pkt_in]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins receiver_0/ap_clk]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins sender_0/ap_clk]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins network_throttle_0/ap_clk]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins network_throttle_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins sender_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins receiver_0/ap_rst_n]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0
connect_bd_intf_net [get_bd_intf_pins axis_register_slice_0/S_AXIS] [get_bd_intf_pins sender_0/pkt_out]
connect_bd_intf_net [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins network_throttle_0/data_in]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins axis_register_slice_0/aclk]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins axis_register_slice_0/aresetn]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0
endgroup
set_property location {0.5 -16 549} [get_bd_cells vio_0]
set_property -dict [list \
CONFIG.C_NUM_PROBE_OUT {5} \
CONFIG.C_PROBE_IN0_WIDTH {32} \
CONFIG.C_PROBE_OUT0_WIDTH {24} \
CONFIG.C_PROBE_OUT1_WIDTH {24} \
CONFIG.C_PROBE_OUT2_WIDTH {16} \
CONFIG.C_PROBE_OUT4_WIDTH {32} \
] [get_bd_cells vio_0]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins vio_0/clk]
connect_bd_net [get_bd_pins vio_0/probe_in0] [get_bd_pins sender_0/pkt_sent]
connect_bd_net [get_bd_pins vio_0/probe_out0] [get_bd_pins sender_0/dest_prt]
connect_bd_net [get_bd_pins vio_0/probe_out1] [get_bd_pins sender_0/id_prt]
connect_bd_net [get_bd_pins vio_0/probe_out2] [get_bd_pins sender_0/user_prt]

connect_bd_net [get_bd_pins vio_0/probe_out3] [get_bd_pins sender_0/run]
connect_bd_net [get_bd_pins vio_0/probe_out4] [get_bd_pins network_throttle_0/penalty]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0
endgroup
set_property -dict [list \
CONFIG.C_MON_TYPE {MIX} \
CONFIG.C_NUM_MONITOR_SLOTS {1} \
CONFIG.C_NUM_OF_PROBES {2} \
CONFIG.C_PROBE0_WIDTH {32} \
CONFIG.C_PROBE1_WIDTH {32} \
CONFIG.C_PROBE_WIDTH_PROPAGATION {MANUAL} \
CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
] [get_bd_cells system_ila_0]
connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_0_AXIS] [get_bd_intf_pins network_throttle_0/data_out]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins system_ila_0/clk]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins system_ila_0/resetn]
connect_bd_net [get_bd_pins system_ila_0/probe0] [get_bd_pins receiver_0/good_received]
connect_bd_net [get_bd_pins system_ila_0/probe1] [get_bd_pins receiver_0/total_received]
regenerate_bd_layout
validate_bd_design