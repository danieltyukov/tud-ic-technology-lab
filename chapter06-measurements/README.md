# Chapter 6 — Measurements

PCM (Process Control Module) electrical measurements on the fabricated wafer.
**Status: complete** — data validated, analysed, figures generated.

| File / folder | Contents |
|---|---|
| [`assignments.md`](assignments.md) | **The worked document**: every Ch. 6 question (Manual ET4icp 2025v2, pp. 37–44) answered in place, figures embedded |
| [`IC/Group 9/`](IC/Group%209/) | Our raw IC-CAP exports (VdP, ELM, I_D–V_G, I_D–V_DS) |
| `IC/other/Group …/` | Other groups' data — used to cross-validate ours |
| [`matlab/analyze_ch6.m`](matlab/analyze_ch6.m) | Full analysis pipeline (`matlab -batch analyze_ch6`) — regenerates everything below |
| [`figures/`](figures/) | Report-ready PNGs (VdP fits, ELM ΔW, transfer/output curves, V_th vs dose) |
| [`extracted_parameters.txt`](extracted_parameters.txt) | All extracted numbers in one text dump |
| [`results.md`](results.md) | Pointer page (content merged into `assignments.md`) |

## Headline results (Group 9)

| Quantity | Value |
|---|---|
| R□ (VdP): NW / SN / SP / metal | 1740.5 / 60.2 / 488.4 / 0.16 Ω/□ |
| N̄ (Irvin, with Sentaurus xⱼ): NW / SN / SP | 1.5×10¹⁶ / 2.3×10¹⁹ / 1.6×10¹⁸ cm⁻³ |
| Lateral out-diffusion ΔW: SN / NW | ≈0.15 µm / ≈0.8–2.1 µm per side |
| Long-channel µₙ / µₚ | ≈750 / ≈240 cm²/V·s |
| V_th (9×10¹¹ quadrant, 20:5): NMOS / PMOS | +0.82 V / −3.30 V |
| V_th vs dose (0→9×10¹¹): NMOS / PMOS | −0.03→+0.82 V / −3.70→−3.30 V (both monotonic) |
| λ (CLM): 20:5 / 20:1 | ≈0.02 V⁻¹ / ≈0.2 V⁻¹ (PMOS 20:1: punch-through, no saturation) |

Data quality: all measurements used agree with the 6-group consensus (fits R² > 0.99 throughout).

## Cross-links

- The **`Measured (Ch. 4 / 6)`** column of the junction-depth table in
  [`../chapter02-ic-fabrication/assignments.md`](../chapter02-ic-fabrication/assignments.md) is filled.
- Junction depths used for the Irvin step come from
  [`../chapter03-simulations/device_sims/junction_depths.txt`](../chapter03-simulations/device_sims/junction_depths.txt).
- Ch. 4 in-line probe values (NW 1488.8, SN 57.4, SP 510.6 Ω/□) from
  [`../chapter04-processing/assignments.md`](../chapter04-processing/assignments.md) are the comparison anchor.
- Report assembly: [`../chapter07-report/report-materials.md`](../chapter07-report/report-materials.md).
