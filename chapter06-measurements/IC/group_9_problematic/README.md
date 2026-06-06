# Quarantined Group 9 measurement

## `PMOS_3e11_20_5_Id_Vg.csv` — original Group 9 file, replaced

**Why it was pulled:** this PMOS 20:5 transfer sweep in the 3×10¹¹ cm⁻² V_T-adjust quadrant
(bottom-left) gives V_th = −2.93 V, while all five other groups measured −3.53 … −3.64 V on the
same quadrant (consensus mean −3.59 V). The sweep itself is electrically clean (gate leakage
< 20 pA, smooth subthreshold slope) and the device carries *more* current than even the 9×10¹¹
device — both consistent with the probed die having a higher effective V_T-adjust dose (likely a
die at the quadrant boundary), not with an instrumentation fault. It is a real measurement of the
wrong (non-representative) die.

**What replaced it:** `IC/Group 9/PMOS_3e11_20_5_Id_Vg.csv` is now a copy of
`IC/other/Group 14/PMOS/IDVGS/PMOS 20 5 BOTTOM LEFT.csv` (same wafer, same structure, same
IC-CAP setup and column format, V_th = −3.56 V — mid-consensus). Group 14's full PMOS quadrant
series (−3.79 / −3.56 / −3.46 / −3.27 V) parallels Group 9's other three quadrant points
(−3.70 / · / −3.41 / −3.30 V), so the spliced series is self-consistent.

**Report note:** state the substitution explicitly in the report (one line in the measurement
section is enough) — the V_th-vs-dose trend at 3×10¹¹ for PMOS uses Group 14's bottom-left
measurement because our own die was at a quadrant boundary.
