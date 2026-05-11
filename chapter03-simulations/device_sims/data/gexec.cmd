# project name
name ET4ICP_BICMOS5
# execution graph
job 22   -post { extract_vars "$nodedir" n22_vis.out 22 }  -o n22_vis "svisual -b n22_vis.tcl"
job 15   -post {  extract_vars "$nodedir" n15_fps.out 15; catch {os_cp "n15_mdr.cmd" "n15_msh.cmd"}; catch {os_cp "n15_mdr.bnd" "n15_msh.bnd"} }  -o n15_fps "sprocess -u -b n15_fps.cmd"
job 21   -post {  extract_vars "$nodedir" n21_fps.out 21; catch {os_cp "n21_mdr.cmd" "n21_msh.cmd"}; catch {os_cp "n21_mdr.bnd" "n21_msh.bnd"} }  -o n21_fps "sprocess -u -b n21_fps.cmd"
job 23   -post { extract_vars "$nodedir" n23_vis.out 23 }  -o n23_vis "svisual -b n23_vis.tcl"
job 25   -post {  extract_vars "$nodedir" n25_fps.out 25; catch {os_cp "n25_mdr.cmd" "n25_msh.cmd"}; catch {os_cp "n25_mdr.bnd" "n25_msh.bnd"} }  -o n25_fps "sprocess -u -b n25_fps.cmd"
job 29   -post { extract_vars "$nodedir" n29_des.out 29 }  -o n29_des "sdevice pp29_des.cmd"
job 31   -post { extract_vars "$nodedir" n31_vis.out 31 }  -o n31_vis "svisual -b n31_vis.tcl"
job 33   -post { extract_vars "$nodedir" n33_des.out 33 }  -o n33_des "sdevice pp33_des.cmd"
job 35   -post { extract_vars "$nodedir" n35_vis.out 35 }  -o n35_vis "svisual -b n35_vis.tcl"
job 14   -post {  extract_vars "$nodedir" n14_fps.out 14; catch {os_cp "n14_mdr.cmd" "n14_msh.cmd"}; catch {os_cp "n14_mdr.bnd" "n14_msh.bnd"} }  -o n14_fps "sprocess -u -b n14_fps.cmd"
job 20   -post {  extract_vars "$nodedir" n20_fps.out 20; catch {os_cp "n20_mdr.cmd" "n20_msh.cmd"}; catch {os_cp "n20_mdr.bnd" "n20_msh.bnd"} }  -o n20_fps "sprocess -u -b n20_fps.cmd"
job 24   -post {  extract_vars "$nodedir" n24_fps.out 24; catch {os_cp "n24_mdr.cmd" "n24_msh.cmd"}; catch {os_cp "n24_mdr.bnd" "n24_msh.bnd"} }  -o n24_fps "sprocess -u -b n24_fps.cmd"
job 28   -post { extract_vars "$nodedir" n28_des.out 28 }  -o n28_des "sdevice pp28_des.cmd"
job 30   -post { extract_vars "$nodedir" n30_vis.out 30 }  -o n30_vis "svisual -b n30_vis.tcl"
job 32   -post { extract_vars "$nodedir" n32_des.out 32 }  -o n32_des "sdevice pp32_des.cmd"
job 34   -post { extract_vars "$nodedir" n34_vis.out 34 }  -o n34_vis "svisual -b n34_vis.tcl"
check sprocess_fps.cmd 1778501595
check sprocess_vtadj_fps.cmd 1778501595
check svisual_dopingConc_vis.tcl 1778501595
check sprocess_dev_fps.cmd 1778501595
check sdevice_des.cmd 1778501595
check svisual_IdVg_vis.tcl 1778501595
check sdevice_IdVd_des.cmd 1778501595
check svisual_IdVd_vis.tcl 1778501595
check global_tooldb 1755295694
check gtree.dat 1778511492
# included files
