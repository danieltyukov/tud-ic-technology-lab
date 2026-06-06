# Chapter 6 — Measurement results (Group 9)

> Raw data: [`IC/Group 9/`](IC/Group%209/) · analysis script: [`matlab/analyze_ch6.m`](matlab/analyze_ch6.m)
> (run with `matlab -batch analyze_ch6`) · machine-readable numbers: [`extracted_parameters.txt`](extracted_parameters.txt)
> Assignment statements: [`assignments.md`](assignments.md)

---

## 0. Data validation against the other groups

Before using our data, every Group 9 file was benchmarked against Groups 1, 6, 10, 13, 14 and 15
(same wafer, different dies). Summary of the Van der Pauw comparison (R□ in Ω/□, computed from
each group's raw sweeps with the same least-squares fit):

| Layer | **G9** | G6 | G10 | G13 | G14 | G15 | G1 |
|---|---|---|---|---|---|---|---|
| NW | **1740.5** | 1660.7 | 2109.8 | 1714.3 | ✗ 53166 | 1711.5 | (−)1712.5 |
| SN | **60.2** | 58.0 | 58.7 | 62.0 | ✗ 1366 | 61.5 | (−)61.6 |
| SP | **488.4** | 488.6 | 499.1 | ✗ 68.6 | ✗ 11245 | 482.6 | (−)483.0 |
| IC | **0.160** | 0.160 | 0.143 | 0.151 | 0.156 | ✗ −0.81 | (−)0.157 |

✗ = corrupt/wrong measurement in that group's file; (−) = G1 recorded with swapped sense probes
(sign flip, magnitude fine). **Group 9 sits within a few percent of the consensus on every layer
and has none of the pathologies.** ELM resistances and all transistor transfer curves agree with
the other groups in the same way.

**One flagged outlier:** our PMOS 20:5 measurement in the 3×10¹¹ quadrant gives
V_th = −2.93 V whereas all five other groups cluster at −3.53 … −3.64 V. The sweep itself is
clean (gate leakage < 20 pA, smooth subthreshold slope), and the device also carries *more*
current than our 9×10¹¹ device — both symptoms of a die with a higher effective V_T-adjust dose
(probably a die at the quadrant boundary). The point is kept in the plots but marked as an
outlier; the cross-group mean (−3.59 V) is shown alongside.

Conclusion: **data is correct and used as-is**, with the single PMOS-3×10¹¹ caveat above.

---

## 1. Van der Pauw measurements

### 1.1 Why a ±0.2 V sweep keeps the junction "reverse biased"

The implanted layers (NW, SN, SP) form pn-junctions with the substrate/well underneath. The
substrate is grounded, and the force voltage is swept −0.2 V → +0.2 V. A silicon junction only
conducts appreciably above the ~0.6 V knee of its I–V exponential; within ±0.2 V the junction
current is orders of magnitude below the lateral sheet current, for **either** polarity. So even
the half of the sweep that is nominally forward-biased injects a negligible substrate current —
the carriers stay confined in the implanted layer, which is exactly the VdP requirement. If the
sweep went to e.g. ±1 V, the forward half would open the junction and current would spread
through the whole substrate, collapsing the measured resistance.

### 1.2 Sheet resistances

R_AB,CD is the slope of (V₁ − V₂) vs I_force (least squares over the whole sweep), and
R□ = (π/ln 2)·R_AB,CD (eq. 2):

| Layer | R_AB,CD (Ω) | **R□ (Ω/□)** | fit R² | Ch. 4 in-line probe (Ω/□) |
|---|---|---|---|---|
| NW | 384.02 | **1740.5** | 0.9991 | 1488.8 |
| SN | 13.281 | **60.19** | 0.9991 | 57.4 |
| SP (in NW) | 107.75 | **488.4** | 0.9990 | 510.6 |
| IC (metal) | 0.0352 | **0.160** | 0.9939 | — |

![VdP I/V sweeps and fits](figures/vdp_iv_fits.png)

The agreement with the Chapter 4 in-line four-point-probe values is good: SN +4.9 %, SP −4.4 %,
NW +17 %. The NW difference is the largest because the n-well is the most lightly doped layer:
its conductance is most sensitive to position on the wafer, to surface depletion and to the
slightly different structures being probed (blanket monitor wafer in Ch. 4 vs a drawn VdP cloverleaf
here).

### 1.3 Doping concentrations (Irvin-curve step)

With the Chapter 3 simulated junction depths, ρ = R□·x_j, and inverting
ρ = 1/(q·µ(N)·N) with the Masetti doping-dependent mobility model (the analytic equivalent of
reading the Irvin curve):

| Layer | x_j (µm) | ρ = R□·x_j (Ω·cm) | µ (cm²/V·s) | **N̄ (cm⁻³)** | Ch. 4 result | Ch. 3 sim profile |
|---|---|---|---|---|---|---|
| NW (P, n) | 2.085 | 0.363 | 1120 | **1.5×10¹⁶** | 1.5×10¹⁶ | ~1–2×10¹⁶ background |
| SN (As, n) | 0.537 | 3.23×10⁻³ | 84 | **2.3×10¹⁹** | 2×10¹⁹ | peak 1.8×10²⁰ |
| SP (B, p) | 0.594 | 2.90×10⁻² | 134 | **1.6×10¹⁸** | 1.5×10¹⁸ | peak 1.5×10¹⁸ |

**Are simulation, Chapter-4 and Chapter-6 values the same?** Within their meaning, yes:

- The Ch. 4 and Ch. 6 averages agree to <10 % for all three layers — two independent electrical
  measurements of the same wafer.
- The VdP value is a **depth-averaged** active concentration. For the graded SN profile the
  average (2.3×10¹⁹) sits roughly an order of magnitude below the simulated *peak* (1.8×10²⁰) —
  expected for an As implant clipped by solid solubility with a steep tail. For NW and SP the
  profile is flatter and average ≈ peak.
- Compared with the Ch. 2 *theory* junction depths (no post-implant thermal budget), the measured
  sheet resistances only make sense with the deeper simulated junctions — confirming that the
  analytic x_j underestimates reality because it ignores all later thermal cycles.

### 1.4 Implants vs metal — why 3–4 orders of magnitude difference?

R□(metal) = 0.16 Ω/□ vs 60–1740 Ω/□ for the implants. With the 0.2 µm Al(1 % Si) thickness,
ρ_metal = R□·d = 3.2×10⁻⁶ Ω·cm — the literature value for Al-1%Si, vs 3×10⁻³…0.36 Ω·cm for
the implanted layers. The physics: aluminium has ~1.8×10²³ conduction electrons per cm³ (one+
per atom), while the implants have only 10¹⁶–10¹⁹ activated carriers per cm³ — a factor 10⁴–10⁷
in carrier density, partly offset by the higher carrier mobility in lightly doped silicon. That
is why interconnect is made of metal and resistors of implanted silicon.

---

## 2. Electrical line-width measurements (ELM)

### 2.1 Resistances and apparent sheet resistance (L = 206 µm)

| Layer | W (µm) | R (Ω) | R□,app = R·W/L (Ω/□) |
|---|---|---|---|
| NW | 2 | 58 833 | 571.2 |
| NW | 5 | 38 478 | 933.9 |
| NW | 10 | 19 689 | 955.8 |
| SN | 2 | 5 244.8 | 50.92 |
| SN | 5 | 2 273.5 | 55.18 |
| SN | 10 | 1 171.1 | 56.85 |

![ELM apparent sheet resistance vs width](figures/elm_rsq_vs_width.png)

**Do we notice a difference with the VdP values?** Yes — the apparent R□ computed with the
*drawn* width is always **lower** than the VdP value, and the deficit grows as the line gets
narrower (SN: −15 % at 2 µm, −5.5 % at 10 µm; NW: −67 % at 2 µm, −45 % at 10 µm). The line is
electrically wider than drawn because dopant diffused laterally out of the implantation window:
W_eff = W_drawn + 2ΔW.

### 2.2 Lateral out-diffusion extraction

Plotting conductance against drawn width, 1/R = (W + 2ΔW)/(R□·L), gives a straight line whose
slope yields R□ and whose x-intercept is −2ΔW:

![ELM conductance fit](figures/elm_deltaW_fit.png)

| Layer | R□ from ELM fit (Ω/□) | **ΔW (µm/side)** | fit R² | VdP R□ (Ω/□) |
|---|---|---|---|---|
| SN | 58.6 | **0.15** | 0.999999 | 60.2 |
| NW | 1129 | **0.80** | 0.986 | 1740.5 |

- **SN** behaves textbook-like: perfectly linear conductance, ELM R□ within 2.7 % of VdP, and a
  small out-diffusion of ≈0.15 µm per side.
- **NW** does not: the three points are visibly non-collinear and the unconstrained fit returns an
  R□ far below the VdP value. If instead the VdP R□ (1740 Ω/□) is taken as the true sheet
  resistance, the 2 µm and 5 µm lines consistently give ΔW ≈ 2.1 µm/side — which matches the
  physics (lateral diffusion ≈ 0.8·x_j ≈ 0.8 × 2.1 µm ≈ 1.7 µm for the 4 h/1150 °C drive-in).
  The constant-ΔW model is simply too crude for the n-well: the lateral "wings" are not abrupt but
  graded over ~2 µm, so each width samples a different effective sheet resistance.

**Why is NW out-diffusion ≫ SN out-diffusion?** Two compounding reasons:
1. **Thermal budget** — the NW phosphorus receives a 4-hour drive-in at 1150 °C (that is what
   makes x_j ≈ 2 µm deep); diffusion is isotropic, so it spreads laterally by a comparable
   distance. The SN arsenic only sees short anneals.
2. **Dopant species** — arsenic has a much smaller diffusion coefficient than phosphorus (heavier
   atom, ~10× lower D at the same temperature), so even for equal anneals it stays put.
Lateral out-diffusion scales with vertical junction depth (≈0.8·x_j), and indeed
ΔW_NW/ΔW_SN ≈ x_j,NW/x_j,SN ≈ 4.

---

## 3. Transistor transfer characteristics (I_D–V_G)

Method: V_th by linear extrapolation at maximum transconductance
(V_th = V_G* − I_D*/g_m,max − V_DS/2), mobility from the linear-region transconductance
g_m = µ·C_ox·(W/L)·|V_DS| with C_ox = ε₀·ε_ox/t_ox = 3.45×10⁻⁸ F/cm² (t_ox = 100 nm),
|V_DS| = 0.1 V.

### 3.1 All geometries in the 9×10¹¹ quadrant

![Transfer characteristics, all geometries](figures/idvg_geometries.png)

| Type | W:L | W/L | V_th (V) | g_m,max (µS) | µ (cm²/V·s) |
|---|---|---|---|---|---|
| NMOS | 20:1 | 20 | 0.572 | 68.0 | (985)* |
| NMOS | 20:2 | 10 | 0.740 | 27.5 | 796 |
| NMOS | 20:5 | 4 | 0.819 | 10.1 | **734** |
| NMOS | 20:10 | 2 | 0.811 | 5.18 | 750 |
| NMOS | 60:2 | 30 | 0.779 | 80.6 | 778 |
| PMOS | 20:1 | 20 | (−1.733)* | 39.0 | (565)* |
| PMOS | 20:2 | 10 | −3.262 | 10.4 | 301 |
| PMOS | 20:5 | 4 | −3.300 | 3.25 | **236** |
| PMOS | 20:10 | 2 | −3.305 | 1.59 | 230 |
| PMOS | 60:2 | 30 | −3.213 | 31.5 | 304 |

\* L = 1 µm values are short-channel-contaminated, see below.

**Influence of W/L:** the on-current and transconductance scale ∝ W/L, as eq. 3 predicts —
g_m,max runs 5.2 → 80.6 µS in almost exact proportion to W/L = 2 → 30. The curve *shape*
(threshold, subthreshold slope) is unchanged for L ≥ 2 µm.

**Do V_th and µ depend on geometry?** They should not (they are material/process parameters),
and for L ≥ 2 µm they indeed don't: V_th and µ are flat within a few percent. At **L = 1 µm**
both extractions break away:

![Extracted parameters vs channel length](figures/mu_vth_vs_geometry.png)

- V_th rolls off (NMOS 0.82 → 0.57 V; PMOS −3.30 → −1.73 V) — **short-channel V_th roll-off**:
  the source/drain depletion regions support part of the channel depletion charge, so less gate
  voltage is needed. The PMOS is hit much harder because its junctions are deeper
  (x_j ≈ 0.59 µm vs 0.54 µm) **and** sit in the lower-doped n-well, giving wide depletion regions
  relative to L = 1 µm.
- The apparent mobility inflates (985 vs ≈750 cm²/V·s) — the L=1 µm device conducts more than the
  drawn geometry ratio implies (effective channel shortening ΔL from lateral S/D diffusion, plus
  the onset of DIBL), so attributing its g_m to W/L = 20 over-estimates µ.

Representative long-channel values: **µₙ ≈ 730–800 cm²/V·s, µₚ ≈ 230–300 cm²/V·s**;
µₙ/µₚ ≈ 3, exactly the electron/hole bulk-mobility ratio in silicon. These are low-field surface
mobilities below the bulk values (1417/470), as expected for surface-channel conduction with the
V_T-adjust implant at the surface.

### 3.2 V_th across the wafer (V_T-adjust dose)

![Transfer per quadrant](figures/idvg_quadrants.png)
![Vth vs dose, measured vs simulated](figures/vth_vs_dose.png)

| V_T-adjust dose (cm⁻²) | NMOS V_th (V) | PMOS V_th (V) |
|---|---|---|
| 0 | −0.034 | −3.702 |
| 3×10¹¹ | 0.388 | (−2.934 — outlier, others ≈ −3.59) |
| 6×10¹¹ | 0.432 | −3.413 |
| 9×10¹¹ | 0.819 | −3.300 |

- **NMOS:** V_th rises monotonically with the boron dose, from essentially 0 V (the un-implanted
  device is on the verge of being normally-on) to +0.82 V. The boron adds acceptor charge in the
  p-channel region: more depletion charge must be imaged by the gate → higher V_th. Slope ≈ +0.9 V
  per 9×10¹¹ cm⁻² ≈ q·ΔQ/C_ox ≈ (1.6×10⁻¹⁹ × 9×10¹¹)/3.45×10⁻⁸ ≈ 4.2 V if all dose were sheet
  charge in the depletion layer — the measured 0.85 V shift shows only part of the implant ends up
  as active depletion charge, consistent with theory (Ch. 2 assignment 5).
- **PMOS:** the same boron implant *compensates* the n-well surface, so |V_th| *decreases* with
  dose: −3.70 → −3.30 V. The trend matches all other groups; our 3×10¹¹ point is the flagged
  outlier (§0).
- **vs simulation:** the Sentaurus values (NMOS 0.91/1.16/1.39 V, PMOS −4.37/−4.37/−3.91 V at
  3/6/9×10¹¹) reproduce the *trends* and the *sensitivity to dose* well, but sit ~0.5 V above the
  measurement (NMOS) / ~0.6 V more negative (PMOS). Part of this is methodological — the sims used
  a constant-current criterion, which lands higher than max-g_m extrapolation — and part is the
  usual calibration gap (simulated channel doping, interface charge Q_ox not included).
- **vs theory (Ch. 2):** qualitatively identical: boron V_T-adjust raises NMOS V_th and makes
  PMOS V_th less negative, with NMOS ~4× more sensitive because the implant lands directly in its
  channel depletion region.

**NMOS vs PMOS overall:** same trends, very different absolute performance: |V_th| of the PMOS is
~4× the NMOS value (the n-well doping under the gate is high, and the 9×10¹¹ boron dose is far
from enough to bring it symmetric), and the PMOS drive current/transconductance is ~3× lower at
equal geometry (hole mobility). A designer would have to size PMOS devices ~3× wider — and this
process would need a higher V_T-adjust dose (or dual implants) for a symmetric CMOS pair.

---

## 4. Output characteristics (I_D–V_DS, 9×10¹¹ quadrant)

![NMOS output](figures/nmos_idvds.png)
![PMOS output](figures/pmos_idvds.png)

### 4.1 20:1 vs 20:5 — the two short-channel effects

Channel-length modulation parameter λ (slope/intercept of the linear fit of |I_D| vs |V_DS| in
the saturated part, |V_DS| > V_GS − V_th + 0.3 V):

| Device | λ (1/V) — representative | behaviour |
|---|---|---|
| NMOS 20:5 | **0.022–0.029** | flat, textbook saturation |
| NMOS 20:1 | **0.16–0.42** (V_G = 2…4 V) | strong slope, never truly flat |
| PMOS 20:5 | **0.015–0.018** | flat saturation |
| PMOS 20:1 | not extractable | **never saturates** within −5 V |

Besides the ~3× current-magnitude scaling (W/L = 20 vs 4), the 20:1 curves differ in two
qualitative ways — the two short-channel effects the assignment asks for:

1. **Channel-length modulation (CLM):** the pinch-off region Δl that forms beyond V_DSat is a
   fixed length set by the drain depletion region; it eats a fraction Δl/L of the channel. For
   L = 5 µm that is a ~2 % perturbation (λ ≈ 0.02 V⁻¹); for L = 1 µm it is ~10× larger
   (λ ≈ 0.2 V⁻¹). In the extreme, the drain field reaches through to the source
   (DIBL/punch-through) — visible in the PMOS 20:1, which behaves almost like a resistor and never
   saturates: its deep (0.59 µm) junctions and lightly doped n-well make the depletion regions as
   long as the channel itself.

2. **Velocity saturation:** in the 20:1 device the lateral field reaches ~V_DS/L ≈ 5×10⁴ V/cm,
   where the carrier drift velocity saturates (~10⁷ cm/s). Two signatures in the data:
   the W/L-normalised current of the 20:1 sits **below** the 20:5 at the same V_G (figure below),
   and the spacing between successive V_G curves grows ~linearly instead of quadratically
   (I_Dsat ∝ (V_GS − V_th) instead of (V_GS − V_th)²).

![Normalized output curves](figures/idvds_normalized.png)

### 4.2 Comparison with the simulations

The Chapter 3 device sims showed exactly these signatures: a ~7× saturation-current rise where the
square law predicts 8× (velocity-saturation compression) and a finite saturation slope (λ ≠ 0).
The measured 20:5 λ ≈ 0.02 V⁻¹ corresponds to the "slight slope in saturation" seen in the
simulated output curves; the simulated structure used L = 5 µm-class geometry, so no punch-through
was observed there, consistent with our 20:5 measurements.

### 4.3 NMOS vs PMOS output characteristics

- Current scale: at matched |overdrive| the PMOS delivers ≈3× less current (µₚ vs µₙ) — compare
  1.06 mA (NMOS 20:5, V_G = 7 V) vs 0.124 mA (PMOS 20:5, V_G = −8 V, lower overdrive).
- The PMOS short-channel device degrades far more severely (no saturation at all at L = 1 µm) —
  deeper SP junctions + n-well doping ≈ 10× lower than the NMOS-side effective channel doping.
- Both show the same linear→saturation structure with V_DSat ≈ |V_GS − V_th| for the
  long devices.

---

## 5. Numbers carried into the report (Ch. 7 rubric hooks)

| Rubric item | Where covered |
|---|---|
| *Measurements: VdP — sheet resistance + doping correctly determined* | §1.2, §1.3 |
| *Measurements: ELM — comparison to VdP + lateral out-diffusion analysis* | §2 |
| *Measurements: MOSFET — V_th and mobility calculated and discussed, short-channel effects identified* | §3, §4 |
| *Conclusions — compare theory / simulation / processing / measurement* | §1.3 (doping), §3.2 (V_th), §4.2 (output) |

Headline numbers:

- R□: NW **1740 Ω/□**, SN **60.2 Ω/□**, SP **488 Ω/□**, metal **0.16 Ω/□**
- N̄: NW **1.5×10¹⁶**, SN **2.3×10¹⁹**, SP **1.6×10¹⁸ cm⁻³** (all within 10 % of Ch. 4)
- Out-diffusion: SN **ΔW ≈ 0.15 µm**, NW **ΔW ≈ 0.8 µm (fit) / ≈2 µm (anchored to VdP)**
- Long-channel: **µₙ ≈ 750, µₚ ≈ 240 cm²/V·s**; V_th(9×10¹¹): NMOS **+0.82 V**, PMOS **−3.30 V**
- V_th(dose): NMOS −0.03 → +0.82 V; PMOS −3.70 → −3.30 V (boron V_T-adjust works as designed)
- λ: 20:5 ≈ **0.02 V⁻¹**; 20:1 ≈ **0.2 V⁻¹** (NMOS) / unmeasurable (PMOS punch-through)
