#!/usr/bin/env bash
# Runs the V_T-adjust dose sweep at 3e11 and 6e11 for both NMOS and PMOS.
# This script is meant to be uploaded to ~/STDB/ET4ICP_BICMOS5/ on the EKL server
# and run there. It reuses the existing pp{20,21,24,25,28,29}.cmd from the
# default 9e11 run, substitutes the vtadj dose, renames output files, and runs
# sprocess + sdevice. Each variant takes ~10 min for NMOS and ~15 min for PMOS.
#
# Variants created:
#   NMOS  3e11, 6e11   (PMOS substrate stays n-well so V_sub sweep skipped)
#   PMOS  3e11, 6e11
# Default 9e11 results are kept untouched.

set -euo pipefail

source /eda/scripts/flexlm.sh >/dev/null 2>&1
source /eda/synopsys/2025-26/scripts/SENTAURUS_2025.09_RHELx86.sh >/dev/null 2>&1
cd ~/STDB/ET4ICP_BICMOS5

run_variant() {
    local DEVICE=$1   # NMOS or PMOS
    local DOSE=$2     # 3e11 / 6e11
    # NMOS uses pp20/pp24/pp28, PMOS uses pp21/pp25/pp29
    local SP_VTADJ_SRC SP_DEV_SRC SD_SRC TDR_PRE TDR_VTADJ TDR_DEV
    if [[ "$DEVICE" == "NMOS" ]]; then
        SP_VTADJ_SRC=pp20_fps.cmd
        SP_DEV_SRC=pp24_fps.cmd
        SD_SRC=pp28_des.cmd
        TDR_PRE=n14
        TDR_VTADJ="n20_${DOSE}"
        TDR_DEV="n24_${DOSE}_dev"
    else
        SP_VTADJ_SRC=pp21_fps.cmd
        SP_DEV_SRC=pp25_fps.cmd
        SD_SRC=pp29_des.cmd
        TDR_PRE=n15
        TDR_VTADJ="n21_${DOSE}"
        TDR_DEV="n25_${DOSE}_dev"
    fi

    local VTADJ_CMD="${DEVICE}_${DOSE}_vtadj.cmd"
    local DEV_CMD="${DEVICE}_${DOSE}_dev.cmd"
    local DES_CMD="${DEVICE}_${DOSE}_des.cmd"

    echo ">>> [$DEVICE @ $DOSE] preparing files"
    # 1. sprocess_vtadj
    sed -e "s/^set vtadj 9e11/set vtadj ${DOSE}/" \
        -e "s/struct tdr=n2[01]/struct tdr=${TDR_VTADJ}/" \
        "$SP_VTADJ_SRC" > "$VTADJ_CMD"
    # 2. sprocess_dev — load from new vtadj TDR, save to new dev TDR
    sed -e "s|init tdr= n2[01]|init tdr= ${TDR_VTADJ}|" \
        -e "s/struct tdr=n2[45]_dev/struct tdr=${TDR_DEV}/" \
        "$SP_DEV_SRC" > "$DEV_CMD"
    # 3. sdevice — point Grid to new dev TDR; force V_sub=0 only by swapping 9e11→DOSE in conditional
    sed -e "s|Grid= \"n2[45]_dev_fps.tdr\"|Grid= \"${TDR_DEV}_fps.tdr\"|" \
        -e "s/\"@vtAdj@\"==\"9e11\"/\"@vtAdj@\"==\"${DOSE}\"/" \
        -e "s/9e11/${DOSE}/g" \
        "$SD_SRC" > "$DES_CMD"

    echo ">>> [$DEVICE @ $DOSE] running sprocess vtadj"
    sprocess --max_threads 4 -u -b "$VTADJ_CMD" > "${DEVICE}_${DOSE}_vtadj.log" 2>&1
    echo "    vtadj done"

    echo ">>> [$DEVICE @ $DOSE] running sprocess dev"
    sprocess --max_threads 4 -u -b "$DEV_CMD" > "${DEVICE}_${DOSE}_dev.log" 2>&1
    echo "    dev done"

    echo ">>> [$DEVICE @ $DOSE] running sdevice IdVg"
    sdevice "$DES_CMD" > "${DEVICE}_${DOSE}_des.log" 2>&1
    echo "    sdevice done"

    echo ">>> [$DEVICE @ $DOSE] complete"
    ls -la *${DOSE}*subBias_0_current_des.plt 2>/dev/null || echo "(no PLT yet)"
}

for DOSE in 3e11 6e11; do
    run_variant NMOS "$DOSE"
done
for DOSE in 3e11 6e11; do
    run_variant PMOS "$DOSE"
done

echo "ALL DONE"
ls -la *3e11* *6e11* | head -30
