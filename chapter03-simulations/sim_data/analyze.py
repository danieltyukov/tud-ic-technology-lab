"""
Analyse + plot all Chapter 3 Process Simulation outputs.

Run from the sim_data/ directory. Produces:
  - audit.txt          : parameter audit of every .cmd file
  - summary.txt        : peak depth, peak concentration, junction depth per profile
  - plots/<step>.png   : one plot per assignment step

We use only numpy + matplotlib (no pandas) since the local env has them.
"""
from pathlib import Path
import re
import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = Path(__file__).parent
PLOTS = HERE / "plots"
PLOTS.mkdir(exist_ok=True)


def load(filename):
    """Load Sentaurus .out (TSV: depth_um, concentration). Drops the duplicate
    boundary row that sprocess emits for x=0."""
    arr = np.loadtxt(HERE / filename, delimiter="\t")
    # drop rows with negative/zero concentration that would break log plots
    arr = arr[arr[:, 1] > 0]
    # de-duplicate x — keep the *last* value (the one inside the silicon)
    _, idx = np.unique(arr[:, 0], return_index=True)
    arr = arr[np.sort(idx)]
    return arr[:, 0], arr[:, 1]


def junction_depth(x_um, conc, background=1e16):
    """First crossing of the implant profile with the background doping.
    Returns x_j in micrometers or None if profile never crosses."""
    # only look past the peak
    pk = int(np.argmax(conc))
    sub = conc[pk:]
    sub_x = x_um[pk:]
    below = sub < background
    if not below.any():
        return None
    return float(sub_x[np.argmax(below)])


def peak(x_um, conc):
    i = int(np.argmax(conc))
    return float(x_um[i]), float(conc[i])


# ---------- 1) audit every .cmd file ----------
audit_lines = []
for f in sorted(HERE.glob("*.cmd")):
    txt = f.read_text()
    impl = [
        l.strip()
        for l in txt.splitlines()
        if l.lstrip().startswith("implant ") and not l.lstrip().startswith("##")
    ]
    deps = [
        l.strip()
        for l in txt.splitlines()
        if l.lstrip().startswith("deposit ") and not l.lstrip().startswith("##")
    ]
    diff = [
        l.strip()
        for l in txt.splitlines()
        if l.lstrip().startswith("diffuse ") and not l.lstrip().startswith("##")
    ]
    audit_lines.append(f"=== {f.name} ===")
    for d in deps:
        audit_lines.append(f"  deposit: {d}")
    for i in impl:
        audit_lines.append(f"  implant: {i}")
    for d in diff:
        audit_lines.append(f"  diffuse: {d}")

(HERE / "audit.txt").write_text("\n".join(audit_lines))
print("Wrote audit.txt with", len(audit_lines), "lines")


# ---------- 2) summary stats per output ----------
files = sorted(HERE.glob("*.out"))
summary_lines = ["file                          peak_depth_um   peak_conc_cm-3   x_j_um (bg=1e16)"]
summary_lines.append("-" * 90)
for f in files:
    x, c = load(f.name)
    pd_um, pc = peak(x, c)
    xj = junction_depth(x, c)
    xj_s = f"{xj:.4f}" if xj else "  n/a"
    summary_lines.append(f"{f.name:30s} {pd_um:>12.4f}    {pc:>12.3e}    {xj_s}")
(HERE / "summary.txt").write_text("\n".join(summary_lines))
print("Wrote summary.txt")


# ---------- helper for log-y plots ----------
def log_plot(curves, title, xlabel="Depth [μm]", ylabel="Concentration [cm⁻³]",
             xlim=None, ylim=(1e14, 1e22), out=None, hline=None):
    fig, ax = plt.subplots(figsize=(8, 5))
    for label, x, y, kw in curves:
        ax.plot(x, y, label=label, **kw)
    ax.set_yscale("log")
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.grid(True, which="both", ls="--", alpha=0.4)
    if xlim:
        ax.set_xlim(xlim)
    if ylim:
        ax.set_ylim(ylim)
    if hline is not None:
        ax.axhline(hline, color="grey", ls=":", lw=1, label=f"background {hline:.0e}")
    ax.legend(loc="best", fontsize=9)
    fig.tight_layout()
    fig.savefig(PLOTS / out, dpi=140)
    plt.close(fig)


# ---------- Steps 1-3: four dopant profiles, same dose, similar Rp ----------
species4 = [
    ("Boron (24 keV)", "implantB.out", dict(color="green")),
    ("Phosphorus (63 keV)", "implantP.out", dict(color="blue")),
    ("Arsenic (148 keV)", "implantAs.out", dict(color="black")),
    ("Antimony (200 keV)", "implantSb.out", dict(color="red")),
]
curves = []
for label, f, kw in species4:
    x, c = load(f)
    curves.append((label, x, c, kw))
log_plot(curves, "Step 1–4: Implantation profiles (crystalline Si, default 7° tilt)",
         xlim=(0, 1.0), hline=1e16, out="step01_profiles_four_species.png")


# ---------- Step 5: amorphous vs crystalline ----------
for sp, file_c, file_a, col in [
    ("Boron", "implantB.out", "amorfB.out", "green"),
    ("Phosphorus", "implantP.out", "amorfP.out", "blue"),
    ("Arsenic", "implantAs.out", "amorfAs.out", "black"),
    ("Antimony", "implantSb.out", "amorfSb.out", "red"),
]:
    xc, cc = load(file_c)
    xa, ca = load(file_a)
    log_plot(
        [
            (f"{sp} — crystalline", xc, cc, dict(color=col, ls="-")),
            (f"{sp} — amorphous MC", xa, ca, dict(color=col, ls="--")),
        ],
        f"Step 5: {sp} — crystalline (analytic) vs amorphous (Monte Carlo)",
        xlim=(0, 0.5),
        out=f"step05_amorph_vs_crystal_{sp}.png",
    )


# ---------- Steps 6-7: tilt sweep on Phosphorus 40 keV ----------
tilts = [0, 3, 7, 11, 15]
curves = []
tilt_stats = []
for t, col in zip(tilts, plt.cm.viridis(np.linspace(0, 0.9, len(tilts)))):
    x, c = load(f"channelP_T{t}.out")
    pd_um, pc = peak(x, c)
    xj = junction_depth(x, c) or float("nan")
    tilt_stats.append((t, pd_um, pc, xj))
    curves.append((f"tilt={t}°", x, c, dict(color=col)))
log_plot(curves, "Steps 6–7: Phosphorus 40 keV — channeling vs tilt angle",
         xlim=(0, 1.0), hline=1e16, out="step07_tilt_sweep.png")

# tilt summary file
with open(HERE / "tilt_summary.txt", "w") as fp:
    fp.write("tilt[deg]  Rp[um]   Npeak[cm-3]   x_j[um] (1e16)\n")
    for t, pd_um, pc, xj in tilt_stats:
        fp.write(f"{t:>5d}   {pd_um:.4f}   {pc:.3e}   {xj:.4f}\n")


# ---------- Step 8: amorphous implants before & after 5 hr @ 1000 °C ----------
for sp, fimp, fdif, col in [
    ("Boron", "amorfB.out", "diffamorfB.out", "green"),
    ("Phosphorus", "amorfP.out", "diffamorfP.out", "blue"),
    ("Arsenic", "amorfAs.out", "diffamorfAs.out", "black"),
    ("Antimony", "amorfSb.out", "diffamorfSb.out", "red"),
]:
    xi, ci = load(fimp)
    xd, cd = load(fdif)
    log_plot(
        [
            (f"{sp} — as-implanted", xi, ci, dict(color=col, ls=":")),
            (f"{sp} — after 5 hr / 1000°C", xd, cd, dict(color=col, ls="-")),
        ],
        f"Step 8: {sp} — implant vs diffusion (amorphous Si, 5 hr @ 1000 °C)",
        xlim=(0, 1.0),
        out=f"step08_diffamorf_{sp}.png",
    )

# all four after diffusion in one plot
curves = []
for sp, fdif, col in [
    ("Boron", "diffamorfB.out", "green"),
    ("Phosphorus", "diffamorfP.out", "blue"),
    ("Arsenic", "diffamorfAs.out", "black"),
    ("Antimony", "diffamorfSb.out", "red"),
]:
    x, c = load(fdif)
    curves.append((sp, x, c, dict(color=col)))
log_plot(curves, "Step 8: All four dopants after 5 hr / 1000 °C in amorphous Si",
         xlim=(0, 1.0), out="step08_diffamorf_all.png")


# ---------- Step 9: Sb solid solubility — 1e15 vs 1e14 dose ----------
x1, c1 = load("imp-sb1.out")
x2, c2 = load("imp-sb2.out")
log_plot(
    [
        ("Sb dose = 1e15, 60 min/1000°C", x1, c1, dict(color="red")),
        ("Sb dose = 1e14, 60 min/1000°C", x2, c2, dict(color="orange")),
    ],
    "Step 9: Sb solid solubility — flat top at high dose, smooth at low dose",
    xlim=(0, 1.0),
    out="step09_imp_sb_solubility.png",
)


# ---------- Steps 12-15: masking efficacy (resist 0.4 µm, resist 1 µm, oxide, nitride) ----------
curves = []
for label, f, col in [
    ("resist 0.4 µm", "resist-P-400nm.out", "magenta"),
    ("resist 1.0 µm", "resist-P-1um.out", "purple"),
    ("oxide 0.4 µm", "oxide-P.out", "steelblue"),
    ("nitride 0.4 µm", "nitride-P.out", "darkgreen"),
]:
    x, c = load(f)
    curves.append((label, x, c, dict(color=col)))
log_plot(curves,
         "Steps 12–15: Phosphorus 160 keV through different masking layers",
         xlabel="Depth (μm; <0 = mask, >0 = silicon)",
         xlim=(-1.0, 1.0), out="step15_masking_comparison.png")


print("All plots in:", PLOTS)
for p in sorted(PLOTS.glob("*.png")):
    print(" -", p.name)
