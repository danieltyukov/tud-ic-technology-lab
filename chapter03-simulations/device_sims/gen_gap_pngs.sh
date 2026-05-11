#!/usr/bin/env bash
# Generate the three "mostly done" gap-fix outputs in one shot:
#   Step 8: PMOS @ 9e11 doping cross-section (retry n23)
#   Step 9: NMOS @ 3e11 and 6e11 doping cross-sections (clone n22)
#   Step 5: numerical junction-depth CSV (cutline data export)
#
# Designed to run on the EKL server in parallel with the PMOS@6e11 sweep.

set -u

source /eda/scripts/flexlm.sh >/dev/null 2>&1
source /eda/synopsys/2025-26/scripts/SENTAURUS_2025.09_RHELx86.sh >/dev/null 2>&1
cd ~/STDB/ET4ICP_BICMOS5

echo "===== gap-fix script start $(date) ====="

# ---- Step 9a: NMOS @ 3e11 cross-section ----
cp pp22_vis.cmd n22_3e11_vis.tcl
sed -i 's|"n20_fps.tdr"|"n20_3e11_fps.tdr"|; s|"NMOS"|"NMOS"|; s|"9e11"|"3e11"|' n22_3e11_vis.tcl
echo ">>> NMOS @ 3e11 svisual"
xvfb-run -a -s "-screen 0 1280x1024x24" svisual -mesa -b n22_3e11_vis.tcl > n22_3e11_run.log 2>&1
echo "  exit=$? new png count: $(ls NMOS_3e11_*.png 2>/dev/null | wc -l)"

# ---- Step 9b: NMOS @ 6e11 cross-section ----
cp pp22_vis.cmd n22_6e11_vis.tcl
sed -i 's|"n20_fps.tdr"|"n20_6e11_fps.tdr"|; s|"9e11"|"6e11"|' n22_6e11_vis.tcl
echo ">>> NMOS @ 6e11 svisual"
xvfb-run -a -s "-screen 0 1280x1024x24" svisual -mesa -b n22_6e11_vis.tcl > n22_6e11_run.log 2>&1
echo "  exit=$? new png count: $(ls NMOS_6e11_*.png 2>/dev/null | wc -l)"

# ---- Step 8: PMOS @ 9e11 cross-section (retry n23) ----
echo ">>> PMOS @ 9e11 svisual (retry)"
xvfb-run -a -s "-screen 0 1280x1024x24" svisual -mesa -b n23_vis.tcl > n23_retry_run.log 2>&1
echo "  exit=$? new png count: $(ls PMOS_9e11_*.png 2>/dev/null | wc -l)"

# ---- Step 5: numerical junction depths via export_curve_data ----
# Use n22's working pattern as a template (it creates curves before exporting)
cat > cutline_export.tcl <<'TCL'
cd /home/et4icp09/STDB/ET4ICP_BICMOS5

# NMOS structure
set md [load_file "n20_fps.tdr"]
set p2d [create_plot -dataset $md]
# vertical cut at y=15 (through n+ source)
set c1 [create_cutline -plot $p2d -type x -at 15]
set p1d1 [create_plot -dataset C1($md) -1d]
create_curve -axisX X -axisY NetActive -dataset C1($md) -plot $p1d1
export_curve_data NetActive -plot $p1d1 -filename cutline_NMOS_source.csv -overwrite

# vertical cut at y=50 (through channel)
set c2 [create_cutline -plot $p2d -type x -at 50]
set p1d2 [create_plot -dataset C2($md) -1d]
create_curve -axisX X -axisY NetActive -dataset C2($md) -plot $p1d2
export_curve_data NetActive -plot $p1d2 -filename cutline_NMOS_channel.csv -overwrite

# PMOS structure (for SP junction depth via SP-side cut)
set mdp [load_file "n21_fps.tdr"]
set p2dp [create_plot -dataset $mdp]
set c3 [create_cutline -plot $p2dp -type x -at 15]
set p1d3 [create_plot -dataset C1($mdp) -1d]
create_curve -axisX X -axisY NetActive -dataset C1($mdp) -plot $p1d3
export_curve_data NetActive -plot $p1d3 -filename cutline_PMOS_source.csv -overwrite

set c4 [create_cutline -plot $p2dp -type x -at 50]
set p1d4 [create_plot -dataset C2($mdp) -1d]
create_curve -axisX X -axisY NetActive -dataset C2($mdp) -plot $p1d4
export_curve_data NetActive -plot $p1d4 -filename cutline_PMOS_channel.csv -overwrite
TCL

echo ">>> cutline CSV export"
xvfb-run -a -s "-screen 0 1280x1024x24" svisual -mesa -b cutline_export.tcl > cutline_run.log 2>&1
echo "  exit=$? csv files: $(ls cutline_*.csv 2>/dev/null | wc -l)"

echo "===== gap-fix script done $(date) ====="
echo "===== all PNGs ====="
ls *.png 2>/dev/null
echo "===== all cutline CSVs ====="
ls cutline_*.csv 2>/dev/null
