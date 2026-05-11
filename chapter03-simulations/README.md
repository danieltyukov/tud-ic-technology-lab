# Chapter 3 — Simulations

Sentaurus process + device simulations on the EKL server (`et4icp.ewi.tudelft.nl`, behind TUDelft VPN). See `../manuals/Virtual classroom for ET4icp simulations.pdf` for the login/setup steps.

## What's here

- [`assignments.md`](assignments.md) — write-up of process-simulation steps 1–15 (Implantation, Implantation+Diffusion, Implantation+Masking). All answers, tables, and analysis ready for the final report.
- [`sim_data/`](sim_data/) — every `.cmd` and `.out` file pulled down from the server (`scp` from `et4icp09@et4icp.ewi.tudelft.nl:~/implant/`), plus:
  - `audit.txt` — listing of every active implant / deposit / diffuse line in each `.cmd` (so we know exactly what parameters every output came from, in case partners modified scripts on the shared account).
  - `summary.txt`, `tilt_summary.txt` — peak depth, peak concentration, junction depth per profile.
  - `analyze.py` — re-runs the analysis and regenerates all plots from the raw `.out` files (numpy/matplotlib, no pandas required).
  - `implant_plot.py` — local numpy port of the server's `implant.py` (Step 2 of the manual).
  - `plots/` — 14 PNG plots, one per assignment step.
- Device-simulation block (`sprocess_fps.cmd`, `sprocess_vtadj_fps.cmd` under `~/STDB/ET4ICP_BICMOS5/`) is not yet pulled — that's a separate session.

## Compare back to Chapter 2 theory

When the process simulation finishes, fill in the **`$x_j$ Sentaurus (Ch. 3)`** column of the junction-depth table in
[`../chapter02-ic-fabrication/assignments.md`](../chapter02-ic-fabrication/assignments.md) (Assignment 3).

Theory values to compare against:

| Implant | $x_j$ theory ($\mu\text{m}$) |
|---|---|
| NW (P, after 4 hr / 1150 °C drive-in) | $\approx 2.4$ |
| SN (As) | $\approx 0.087$ |
| SP (B in NW) | $\approx 0.186$ |

Expected differences to investigate when the numbers don't line up:
- **SN**: theory peak ($1.75 \times 10^{21}$ cm⁻³) sits near As solid solubility — Sentaurus will likely clip the active concentration there, giving a different shape.
- **NW**: theory uses limited-source Gaussian; Sentaurus accounts for finite implant tail + segregation during the long anneal.
- **All three**: channelling can stretch the tail beyond the analytical estimate.
