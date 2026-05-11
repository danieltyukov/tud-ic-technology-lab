# Chapter 3 — Simulations

Sentaurus process + device simulations on the EKL server (`et4icp.ewi.tudelft.nl`, behind TUDelft VPN). See `../manuals/Virtual classroom for ET4icp simulations.pdf` for the login/setup steps.

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
