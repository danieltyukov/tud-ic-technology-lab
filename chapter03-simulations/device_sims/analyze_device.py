"""Parse Sentaurus DF-ISE .plt files (IdVg / IdVd sweeps), extract V_T,
generate plots for the device-simulation chapter.

PLT layout (xyplot type):
    Info { datasets = [ time, substrate.*, source.*, gate.*, drain.* ] }
    Data { values... }

Each electrode has 8 fields: OuterVoltage, InnerVoltage, QuasiFermiPotential,
DisplacementCurrent, eCurrent, hCurrent, TotalCurrent, Charge.
"""
import re
import sys
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

DATA = Path(__file__).parent / "data"
PLOTS = Path(__file__).parent / "plots"
PLOTS.mkdir(exist_ok=True)

FIELDS_PER_ELECTRODE = 8
# Within each electrode: 0=OuterV, 1=InnerV, 2=QFP, 3=DispI, 4=eI, 5=hI, 6=TotalI, 7=Charge
OFF_VOUT = 0
OFF_ITOT = 6


def parse_plt(filename):
    """Return (arr, layout) where arr is the full numeric matrix and layout is
    a dict mapping electrode names to starting column. PLT layout is read from
    the Info block so NMOS (4 electrodes, 33 cols) and PMOS (5 electrodes,
    41 cols including psubstrate) both work."""
    text = (DATA / filename).read_text()
    info_match = re.search(r"datasets\s*=\s*\[(.*?)\]", text, re.DOTALL)
    if not info_match:
        raise ValueError(f"No datasets in {filename}")
    tokens = re.findall(r'"([^"]+)"', info_match.group(1))
    # tokens = ["time", "substrate OuterVoltage", ..., "drain Charge"]
    layout = {"time": 0}
    for i, tok in enumerate(tokens):
        if " " not in tok:
            continue
        elec, field = tok.split(" ", 1)
        if elec not in layout and field == "OuterVoltage":
            layout[elec] = i  # 1-based index in tokens equals 0-based column in row
    n_cols = len(tokens)
    data_match = re.search(r"Data\s*\{(.*)\}", text, re.DOTALL)
    if not data_match:
        raise ValueError(f"No Data block in {filename}")
    nums = re.findall(r"[-+]?\d+\.\d+E[+-]?\d+|[-+]?\d+\.\d+|[-+]?\d+", data_match.group(1))
    arr = np.array([float(x) for x in nums])
    assert arr.size % n_cols == 0, f"{filename}: numbers={arr.size} not multiple of {n_cols}"
    return arr.reshape(-1, n_cols), layout


def gate_drain(arr, layout):
    """Return (V_gate, I_drain) from a parsed PLT."""
    return arr[:, layout["gate"] + OFF_VOUT], arr[:, layout["drain"] + OFF_ITOT]


def drain_voltage_current(arr, layout):
    return arr[:, layout["drain"] + OFF_VOUT], arr[:, layout["drain"] + OFF_ITOT]


def vt_extract(vg, id_drain, method="constant", icrit=1e-7, W_um=1.0):
    """Extract threshold voltage.
    - 'constant' : V_G where |I_D| crosses icrit (A per W).
    - 'linear'   : tangent at max gm extrapolated to I_D=0.
    """
    idabs = np.abs(id_drain)
    if method == "constant":
        crossed = np.where(idabs >= icrit)[0]
        if not len(crossed):
            return np.nan
        i = crossed[0]
        if i == 0:
            return float(vg[i])
        # linear interpolate between i-1 and i
        x1, x2 = vg[i - 1], vg[i]
        y1, y2 = idabs[i - 1], idabs[i]
        return float(x1 + (icrit - y1) * (x2 - x1) / (y2 - y1))
    elif method == "linear":
        gm = np.gradient(idabs, vg)
        i = int(np.argmax(gm))
        # tangent: I = gm[i] * (V - V_T)  => V_T = vg[i] - idabs[i]/gm[i]
        return float(vg[i] - idabs[i] / gm[i])
    raise ValueError(method)


# ---------- NMOS IdVg vs substrate bias (Step 6) ----------
nmos_ivg_files = {
    0.0:  "n28_NMOS_9e11_IdVg_subBias_0_current_des.plt",
    -1.0: "n28_NMOS_9e11_IdVg_subBias_-1_current_des.plt",
    -2.0: "n28_NMOS_9e11_IdVg_subBias_-2_current_des.plt",
}

fig, ax = plt.subplots(figsize=(8, 5))
vt_table_nmos = []
for vsub, fn in nmos_ivg_files.items():
    if not (DATA / fn).exists():
        print(f"missing: {fn}")
        continue
    arr, layout = parse_plt(fn)
    vg, id_drain = gate_drain(arr, layout)
    vt_c = vt_extract(vg, id_drain, "constant")
    vt_l = vt_extract(vg, id_drain, "linear")
    vt_table_nmos.append((vsub, vt_c, vt_l))
    ax.semilogy(vg, np.abs(id_drain), label=f"V_sub = {vsub:+.0f} V (V_T ≈ {vt_c:.2f} V)")
ax.axhline(1e-7, color="grey", ls=":", alpha=0.6, label="I_D = 100 nA threshold")
ax.set_xlabel("V_G [V]")
ax.set_ylabel("|I_D| [A]")
ax.set_title("Step 6: NMOS I_D–V_G (V_T-adjust dose = 9×10¹¹), 3 substrate biases")
ax.grid(True, which="both", ls="--", alpha=0.3)
ax.legend(loc="best", fontsize=9)
ax.set_ylim(1e-13, 1e-3)
fig.tight_layout()
fig.savefig(PLOTS / "step06_NMOS_IdVg_substrate_sweep.png", dpi=140)
plt.close(fig)
print("Step 6: NMOS V_T (constant-current 1e-7 A, linear extrapolation):")
for vsub, vt_c, vt_l in vt_table_nmos:
    print(f"  V_sub = {vsub:+.0f} V  →  V_T (const I) = {vt_c:.3f} V   V_T (linear) = {vt_l:.3f} V")


# ---------- NMOS IdVd (Step 7) ----------
idvd_files = sorted(DATA.glob("n32_NMOS_9e11_IdVd_gateBias_*_current_des.plt"))
fig, ax = plt.subplots(figsize=(8, 5))
for fn in idvd_files:
    arr, layout = parse_plt(fn.name)
    vd, id_drain = drain_voltage_current(arr, layout)
    # parse V_G from filename
    m = re.search(r"gateBias_(-?\d+(?:\.\d+)?)", fn.name)
    vg_val = float(m.group(1)) if m else 0
    ax.plot(vd, id_drain * 1e6, label=f"V_G = {vg_val:.0f} V")
ax.set_xlabel("V_DS [V]")
ax.set_ylabel("I_D [µA]")
ax.set_title("Step 7: NMOS I_D–V_DS (V_T-adjust = 9×10¹¹, V_sub = 0)")
ax.grid(True, ls="--", alpha=0.4)
ax.legend(loc="best", fontsize=9, ncol=2)
fig.tight_layout()
fig.savefig(PLOTS / "step07_NMOS_IdVd.png", dpi=140)
plt.close(fig)
print("Step 7: IdVd curves plotted")


# ---------- PMOS IdVd (Step 8, family at V_sub=0) ----------
pmos_idvd_files = sorted(DATA.glob("n33_PMOS_9e11_IdVd_gateBias_*_current_des.plt"))
if pmos_idvd_files:
    fig, ax = plt.subplots(figsize=(8, 5))
    for fn in pmos_idvd_files:
        arr, layout = parse_plt(fn.name)
        vd, id_drain = drain_voltage_current(arr, layout)
        m = re.search(r"gateBias_(-?\d+(?:\.\d+)?)", fn.name)
        vg_val = float(m.group(1)) if m else 0
        ax.plot(vd, id_drain * 1e6, label=f"V_G = {vg_val:+.0f} V")
    ax.set_xlabel("V_DS [V]")
    ax.set_ylabel("I_D [µA]")
    ax.set_title("Step 8: PMOS I_D–V_DS (V_T-adjust = 9×10¹¹, V_sub = 0)")
    ax.grid(True, ls="--", alpha=0.4)
    ax.legend(loc="best", fontsize=9, ncol=2)
    fig.tight_layout()
    fig.savefig(PLOTS / "step08_PMOS_IdVd.png", dpi=140)
    plt.close(fig)
    print(f"Step 8: PMOS IdVd plotted ({len(pmos_idvd_files)} curves)")


# ---------- PMOS IdVg (Step 8 — PMOS only V_sub = 0) ----------
pmos_ivg = DATA / "n29_PMOS_9e11_IdVg_subBias_0_current_des.plt"
vt_table_pmos = []
if pmos_ivg.exists():
    arr, layout = parse_plt(pmos_ivg.name)
    vg, id_drain = gate_drain(arr, layout)
    # for PMOS the gate ramps negative, so |I_D| crossing at -ve V_G
    vt_c = vt_extract(vg, id_drain, "constant")
    vt_l = vt_extract(vg, id_drain, "linear")
    vt_table_pmos.append((0.0, vt_c, vt_l))
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.semilogy(vg, np.abs(id_drain), label=f"PMOS V_sub=0 V (V_T ≈ {vt_c:.2f} V)", color="C3")
    ax.axhline(1e-7, color="grey", ls=":", alpha=0.6, label="I_D = 100 nA threshold")
    ax.set_xlabel("V_G [V]")
    ax.set_ylabel("|I_D| [A]")
    ax.set_title("Step 8: PMOS I_D–V_G (V_T-adjust = 9×10¹¹, V_sub = 0)")
    ax.grid(True, which="both", ls="--", alpha=0.3)
    ax.legend(loc="best", fontsize=9)
    ax.set_ylim(1e-13, 1e-3)
    fig.tight_layout()
    fig.savefig(PLOTS / "step08_PMOS_IdVg.png", dpi=140)
    plt.close(fig)
    print(f"Step 8: PMOS V_T (V_sub=0) = {vt_c:.3f} V (const I), {vt_l:.3f} V (linear)")
else:
    print("PMOS IdVg .plt not yet available — re-run after PMOS finishes")


# ---------- V_T-adjust dose sweep (Steps 9–11) ----------
# Look for any *_3e11_*subBias_0*.plt and *_6e11_*subBias_0*.plt in data/.
# Build a V_T-vs-dose plot if at least one variant exists.
sweep_rows = []
# Baselines (already extracted above) — pin them in
sweep_rows.append(("NMOS", 9e11, 0.0, vt_table_nmos[0][1] if vt_table_nmos else None))
sweep_rows.append(("NMOS", 9e11, -1.0, vt_table_nmos[1][1] if len(vt_table_nmos) > 1 else None))
sweep_rows.append(("NMOS", 9e11, -2.0, vt_table_nmos[2][1] if len(vt_table_nmos) > 2 else None))
sweep_rows.append(("PMOS", 9e11, 0.0, vt_table_pmos[0][1] if vt_table_pmos else None))
# Variant PLTs
for dose_str, dose_val in [("3e11", 3e11), ("6e11", 6e11)]:
    for dev in ["NMOS", "PMOS"]:
        for f in DATA.glob(f"*_{dev}_{dose_str}_*subBias_0*.plt"):
            arr, layout = parse_plt(f.name)
            vg, id_drain = gate_drain(arr, layout)
            vt_c = vt_extract(vg, id_drain, "constant")
            sweep_rows.append((dev, dose_val, 0.0, vt_c))
            print(f"Sweep: {dev} @ {dose_str} V_sub=0  →  V_T = {vt_c:.3f} V")

# Plot V_T vs dose (V_sub=0 only)
if any(r[1] != 9e11 for r in sweep_rows):
    fig, ax = plt.subplots(figsize=(7, 5))
    for dev, marker, color in [("NMOS", "o", "C0"), ("PMOS", "s", "C3")]:
        pts = sorted([(r[1], r[3]) for r in sweep_rows if r[0] == dev and r[2] == 0.0 and r[3] is not None])
        if pts:
            doses, vts = zip(*pts)
            ax.plot(doses, vts, marker=marker, color=color, ls="-", label=dev)
    ax.set_xscale("log")
    ax.set_xlabel("V_T-adjust dose [cm⁻²]")
    ax.set_ylabel("V_T [V]")
    ax.set_title("Steps 9–11: V_T vs V_T-adjust dose (V_sub = 0)")
    ax.axhline(0, color="grey", ls=":", alpha=0.5)
    ax.grid(True, ls="--", alpha=0.4)
    ax.legend()
    fig.tight_layout()
    fig.savefig(PLOTS / "step11_VT_vs_dose.png", dpi=140)
    plt.close(fig)
    print("Step 11: V_T vs dose plotted")


# ---------- Save V_T table ----------
with open(PLOTS.parent / "vt_summary.txt", "w") as fp:
    fp.write("Device   V_T-adjust dose [cm-2]   V_sub [V]   V_T (const I) [V]   V_T (linear) [V]\n")
    fp.write("-" * 85 + "\n")
    for vsub, vt_c, vt_l in vt_table_nmos:
        fp.write(f"NMOS     9e11                     {vsub:+.1f}        {vt_c:>6.3f}             {vt_l:>6.3f}\n")
    for vsub, vt_c, vt_l in vt_table_pmos:
        fp.write(f"PMOS     9e11                     {vsub:+.1f}        {vt_c:>6.3f}             {vt_l:>6.3f}\n")
    # sweep variants
    for dev, dose, vsub, vt in sweep_rows:
        if dose == 9e11:
            continue
        if vt is None:
            continue
        fp.write(f"{dev}     {dose:<10.0e}              {vsub:+.1f}        {vt:>6.3f}             ---\n")
print("vt_summary.txt written")
