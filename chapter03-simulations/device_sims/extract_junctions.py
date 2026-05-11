"""Parse svisual-exported cutline CSVs to extract numerical junction depths
and plot dose-comparison doping profiles.

For each (device, dose) tuple, we have:
  {device}_{dose}_cutline_source.csv      vertical cut at y=37.5 (through source)
  {device}_{dose}_cutline_channel.csv     vertical cut at y=50   (through channel)
  {device}_{dose}_cutline_horizontal.csv  horizontal cut at x=0.3 (along surface)

CSV header: "NetActive(...) X, NetActive(...) Y"
"""
import csv
import re
from pathlib import Path
import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = Path(__file__).parent / "data"
PLOTS = Path(__file__).parent / "plots"
PLOTS.mkdir(exist_ok=True)


def load_cutline(filename):
    """Return (depth_um, net_active_cm-3) from a svisual export_curves CSV."""
    with open(HERE / filename, newline="") as fp:
        rows = list(csv.reader(fp))
    data = []
    for row in rows[1:]:  # skip header
        if len(row) != 2:
            continue
        try:
            x, y = float(row[0]), float(row[1])
        except ValueError:
            continue
        data.append((x, y))
    arr = np.array(data)
    return arr[:, 0], arr[:, 1]


def junction_depth(x, net, min_depth=0.05):
    """Find first zero-crossing of NetActive past x=min_depth.
    Returns x_j in μm or None if no crossing."""
    # filter to silicon region (positive depth, non-zero values)
    mask = (x >= min_depth) & (np.abs(net) > 0)
    xs, ys = x[mask], net[mask]
    if len(ys) < 2:
        return None
    # find sign changes
    signs = np.sign(ys)
    changes = np.where(np.diff(signs) != 0)[0]
    if not len(changes):
        return None
    i = changes[0]
    # linear interpolation between point i and i+1
    x1, x2 = xs[i], xs[i + 1]
    y1, y2 = ys[i], ys[i + 1]
    return float(x1 + (0 - y1) * (x2 - x1) / (y2 - y1))


def peak_concentration(x, net, min_depth=0.05):
    """Peak |NetActive| in silicon region — for source/drain plots this is
    the heavily-doped surface region."""
    mask = (x >= min_depth) & (np.abs(net) > 0)
    if not mask.any():
        return None, None
    xs, ys = x[mask], net[mask]
    i = int(np.argmax(np.abs(ys)))
    return float(xs[i]), float(ys[i])


# =========================================================================
# Extract junction depths for all 6 (device, dose) variants
# =========================================================================
print("=" * 70)
print("Numerical junction depth extraction from svisual cutlines")
print("=" * 70)
results = {}
for dev in ["NMOS", "PMOS"]:
    for dose in ["3e11", "6e11", "9e11"]:
        src_x, src_net = load_cutline(f"{dev}_{dose}_cutline_source.csv")
        xj_src = junction_depth(src_x, src_net)
        peak_d, peak_n = peak_concentration(src_x, src_net)
        results[(dev, dose, "source")] = (xj_src, peak_d, peak_n)
        print(
            f"{dev} @ {dose} source(y=37.5): "
            f"x_j = {xj_src:.3f} μm  |  peak |N| = {abs(peak_n):.2e} @ x={peak_d:.3f} μm"
        )

print()
for dev in ["NMOS", "PMOS"]:
    for dose in ["3e11", "6e11", "9e11"]:
        ch_x, ch_net = load_cutline(f"{dev}_{dose}_cutline_channel.csv")
        xj_ch = junction_depth(ch_x, ch_net)
        results[(dev, dose, "channel")] = (xj_ch, None, None)
        depth_str = f"{xj_ch:.3f}" if xj_ch else "none"
        print(f"{dev} @ {dose} channel(y=50): junction at x = {depth_str} μm")


# =========================================================================
# Plot 1: NMOS source cutline at 3 doses — Step 9 dose comparison
# =========================================================================
fig, ax = plt.subplots(figsize=(9, 6))
for dose, color in [("3e11", "C0"), ("6e11", "C1"), ("9e11", "C2")]:
    x, net = load_cutline(f"NMOS_{dose}_cutline_source.csv")
    mask = np.abs(net) > 0
    ax.semilogy(x[mask], np.abs(net[mask]), label=f"NMOS @ V_T-adj = {dose}", color=color, lw=2)
    xj, _, _ = results[("NMOS", dose, "source")]
    if xj:
        ax.axvline(xj, color=color, ls=":", lw=1, alpha=0.5)
        ax.text(xj + 0.02, 1e17, f"x_j = {xj:.2f} μm", color=color, fontsize=8)
ax.axhline(1e16, color="grey", ls="--", alpha=0.4, label="background ~1e16")
ax.set_xlabel("Depth into device, X (μm)")
ax.set_ylabel("|NetActive| (cm⁻³)")
ax.set_title("Step 9: NMOS source-cut doping profile at 3 V_T-adjust doses")
ax.grid(True, which="both", ls="--", alpha=0.3)
ax.legend(fontsize=10)
ax.set_xlim(0, 2)
ax.set_ylim(1e14, 5e20)
fig.tight_layout()
fig.savefig(PLOTS / "step09_NMOS_source_dose_comparison.png", dpi=140)
plt.close(fig)
print("\nstep09_NMOS_source_dose_comparison.png saved")


# =========================================================================
# Plot 2: PMOS source cutline at 3 doses
# =========================================================================
fig, ax = plt.subplots(figsize=(9, 6))
for dose, color in [("3e11", "C0"), ("6e11", "C1"), ("9e11", "C2")]:
    x, net = load_cutline(f"PMOS_{dose}_cutline_source.csv")
    mask = np.abs(net) > 0
    ax.semilogy(x[mask], np.abs(net[mask]), label=f"PMOS @ V_T-adj = {dose}", color=color, lw=2)
    xj, _, _ = results[("PMOS", dose, "source")]
    if xj:
        ax.axvline(xj, color=color, ls=":", lw=1, alpha=0.5)
        ax.text(xj + 0.02, 1e17, f"x_j = {xj:.2f} μm", color=color, fontsize=8)
ax.set_xlabel("Depth into device, X (μm)")
ax.set_ylabel("|NetActive| (cm⁻³)")
ax.set_title("Step 9: PMOS source-cut doping profile at 3 V_T-adjust doses")
ax.grid(True, which="both", ls="--", alpha=0.3)
ax.legend(fontsize=10)
ax.set_xlim(0, 3)
ax.set_ylim(1e14, 5e20)
fig.tight_layout()
fig.savefig(PLOTS / "step09_PMOS_source_dose_comparison.png", dpi=140)
plt.close(fig)
print("step09_PMOS_source_dose_comparison.png saved")


# =========================================================================
# Plot 3: PMOS source cutline @ 9e11 — equivalent of Step 5 figure for PMOS
# =========================================================================
fig, ax = plt.subplots(figsize=(9, 6))
x, net = load_cutline("PMOS_9e11_cutline_source.csv")
mask = np.abs(net) > 0
ax.semilogy(x[mask], np.abs(net[mask]), color="C3", lw=2,
            label="PMOS source-cut (y=37.5 μm)")
# annotate regions
ax.axhline(1e16, color="grey", ls="--", alpha=0.4)
xj_sp, _, _ = results[("PMOS", "9e11", "source")]
if xj_sp:
    ax.axvline(xj_sp, color="C3", ls=":", alpha=0.6)
    ax.text(xj_sp + 0.05, 1e18, f"SP junction\nx_j = {xj_sp:.2f} μm", color="C3")
ax.set_xlabel("Depth into device, X (μm)")
ax.set_ylabel("|NetActive| (cm⁻³)")
ax.set_title("Step 8: PMOS source doping profile (vertical cut at y=37.5)")
ax.grid(True, which="both", ls="--", alpha=0.3)
ax.legend(fontsize=10)
ax.set_xlim(0, 3)
ax.set_ylim(1e14, 5e20)
fig.tight_layout()
fig.savefig(PLOTS / "step08_PMOS_doping_source_cut.png", dpi=140)
plt.close(fig)
print("step08_PMOS_doping_source_cut.png saved")


# =========================================================================
# Save junction depth summary
# =========================================================================
with open(HERE.parent / "junction_depths.txt", "w") as fp:
    fp.write("Junction depths extracted from svisual cutline CSV exports\n")
    fp.write("(zero-crossing of NetActive in silicon region, post first oxide pixel)\n")
    fp.write("=" * 70 + "\n")
    fp.write(f"{'Device':<8}{'Dose':<8}{'Cut':<12}{'x_j (μm)':<12}{'peak (cm-3)':<14}\n")
    fp.write("-" * 70 + "\n")
    for (dev, dose, cut), (xj, peak_d, peak_n) in sorted(results.items()):
        xj_s = f"{xj:.3f}" if xj else "n/a"
        peak_s = f"{peak_n:.2e}" if peak_n is not None else ""
        fp.write(f"{dev:<8}{dose:<8}{cut:<12}{xj_s:<12}{peak_s:<14}\n")
print("\njunction_depths.txt written")
