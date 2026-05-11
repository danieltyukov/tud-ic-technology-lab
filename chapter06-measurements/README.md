# Chapter 6 — Measurements

PCM (Process Control Module) electrical measurements on the fabricated wafer.

## Use the Chapter 2 junction depths

The Chapter 2 / Assignment 3 results are needed to interpret these measurements (per manual p. 15). When measurement results come in, fill the **`Measured (Ch. 4 / 6)`** column of the table in
[`../chapter02-ic-fabrication/assignments.md`](../chapter02-ic-fabrication/assignments.md).

Theory values for reference:

| Implant | $x_j$ theory ($\mu\text{m}$) |
|---|---|
| NW (P, after drive-in) | $\approx 2.4$ |
| SN (As) | $\approx 0.087$ |
| SP (B in NW) | $\approx 0.186$ |

Things to watch:
- Sheet resistance of the SN/SP layers depends directly on $x_j$ and active dopant — a much shallower measured junction means solid solubility clipped the active dose.
- Capacitance-derived junction depth is sensitive to the lateral profile too, not just the vertical one we computed analytically.
