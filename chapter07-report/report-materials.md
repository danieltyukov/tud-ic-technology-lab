# Report materials — status & cross-comparison numbers

Companion to [`README.md`](README.md) (which holds the manual's requirements + rubric).
This file tracks what is **ready** for the report and collects the headline numbers for the
Conclusion's theory ↔ simulation ↔ processing ↔ measurement comparison.

## Rubric checklist → status

| Criterion | Pts | Material ready? |
|---|---|---|
| Preparatory exercises | 1/question | ✅ `../chapter02-ic-fabrication/assignments.md` |
| Dopant simulations | 3 | ✅ `../chapter03-simulations/assignments.md` |
| Device simulations | 2 | ✅ `../chapter03-simulations/device_sims_assignments.md` |
| Processing: implantations | 1 | ✅ `../chapter04-processing/assignments.md` Q1–Q3 |
| Processing: etching & selectivity | 2 | ✅ `../chapter04-processing/assignments.md` |
| Processing: oxide | 2 | ✅ `../chapter04-processing/assignments.md` Q4–Q8 |
| Measurements: VdP | 2 | ✅ `../chapter06-measurements/assignments.md` §1 |
| Measurements: ELM | 1 | ✅ `../chapter06-measurements/assignments.md` §2 |
| Measurements: MOSFET | 2 | ✅ `../chapter06-measurements/assignments.md` §3 |
| Lay-out / Language | 2+2 | at writing time |

Report-ready figures (no IC-CAP screenshots, all replotted in MATLAB):
`../chapter06-measurements/figures/*.png` — VdP fits, ELM ΔW extraction, transfer
characteristics (all geometries + per quadrant), V_th vs dose vs simulation, output
characteristics, W/L-normalised short-channel comparison.

## Cross-comparison table for the Conclusion

| Quantity | Theory (Ch. 2) | Simulation (Ch. 3) | Processing (Ch. 4) | Measurement (Ch. 6) |
|---|---|---|---|---|
| x_j NW / SN / SP (µm) | 2.4 / 0.087 / 0.186 | 2.085 / 0.537 / 0.594 | — | (sim values used in Irvin step) |
| R□ NW / SN / SP (Ω/□) | — | — | 1488.8 / 57.4 / 510.6 | 1740.5 / 60.2 / 488.4 |
| N̄ NW / SN / SP (cm⁻³) | — | 1–2×10¹⁶ / 1.8×10²⁰ pk / 1.5×10¹⁸ pk | 1.5×10¹⁶ / 2×10¹⁹ / 1.5×10¹⁸ | 1.5×10¹⁶ / 2.3×10¹⁹ / 1.6×10¹⁸ |
| V_th NMOS @ 3/6/9×10¹¹ (V) | ↑ with dose (qualitative) | 0.905 / 1.162 / 1.385 | — | 0.388 / 0.432 / 0.819 |
| V_th PMOS @ 3/6/9×10¹¹ (V) | \|V_th\| ↓ with dose | −4.372 / −4.372 / −3.907 | — | −3.511 / −3.413 / −3.300 |
| µₙ / µₚ (cm²/V·s) | bulk 1417 / 470 | — | — | surface ≈750 / ≈240 |
| λ 20:5 / 20:1 (V⁻¹) | ∝ 1/L | "slight slope" seen | — | ≈0.02 / ≈0.2 (PMOS 20:1 punch-through) |
| Metal R□ (Ω/□) | ρ_Al/d ≈ 0.145 | — | — | 0.160 (ρ = 3.2×10⁻⁶ Ω·cm ✓) |

Discussion threads to carry into the Conclusion:

1. **Junction depths**: analytic theory ≪ simulation because theory neglects the post-implant
   thermal budget; the measured sheet resistances are only consistent with the *simulated* depths.
2. **Doping**: three independent routes (sim, in-line probe, VdP) agree within ~10 % for all
   layers once depth-averaging is accounted for.
3. **V_th vs dose**: measurement and simulation show the same trend and dose sensitivity; the
   ~0.5 V absolute offset is extraction-method (const-current vs max-g_m) + calibration (Q_ox).
4. **Short-channel effects**: CLM (λ ∝ 1/L, ~10× larger at L = 1 µm) and velocity saturation
   (sub-quadratic I_Dsat, lower normalised current) both measured and seen in the device sims;
   PMOS L = 1 µm even punches through (deep SP junction in a lightly doped well).
