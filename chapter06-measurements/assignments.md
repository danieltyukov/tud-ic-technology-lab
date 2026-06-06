# Chapter 6 — Measurements: context & assignment questions

> Source: *Manual ET4icp 2025v2*, Chapter 6 (pp. 37–44). Group 9 data lives in
> [`IC/Group 9/`](IC/Group%209/). Worked answers + figures: [`results.md`](results.md).

## Why these measurements

In IC fabrication the process is monitored by electrical measurements on test devices
(PCM — process control modules): transistors, sheet-resistance structures, etc. The same
measurements feed the circuit designers their **model parameters**. During the lab we
measure NMOS and PMOS transistors and two kinds of resistance structures on the BICMOS5
wafer, to see the effect of process steps on device performance and to extract mobility
and threshold voltage.

**Setup:** Cascade 31 automatic probe station + Keysight B1500A precision semiconductor
parameter analyzer (six HRSMUs — source/measure units that force voltage & measure
current, or vice versa), driven by the IC-CAP 2022 software (`ICCourse.mdl`). Data is
exported as `*.csv` / `*.mdm`.

**Wafer quadrants** (fig. 5-2 of the manual) — each quarter has a different boron
V_T-adjust dose:

| Quadrant | V_T-adjust dose (ions/cm²) |
|---|---|
| Top-left (TL) | 0 |
| Bottom-left (BL) | 3×10¹¹ |
| Top-right (TR) | 6×10¹¹ |
| Bottom-right (BR) | 9×10¹¹ |

---

## 1. Resistance measurements & doping concentrations

We want the **sheet resistance** R□ = ρ/d of each implanted layer (ρ = resistivity,
d = layer thickness). A designer then gets any resistor value from the aspect ratio:

```
R = ρ·L/(W·d) = R□·L/W                                (eq. 1)
```

Once R□ **and** the junction depth x_j are known, the resistivity follows from
ρ = R□·x_j and the doping concentration is read from the **Irving (Irvin) curves**
(cf. chapter 4).

All resistance structures are measured **four-point**: two probes force the current,
two high-impedance probes sense the voltage, so probe/contact resistance drops out
(fig. 6-3 of the manual).

### 1a. Van der Pauw (VdP)

Van der Pauw (1958): for a uniform, singly-connected film with small contacts at the
edge, one measurement suffices. For a symmetric structure:

```
        π
R□ = ───── · R_AB,CD                                  (eq. 2)
       ln 2
```

where R_AB,CD = (V_C − V_D)/I_AB — current forced through contacts A,B; voltage sensed
across C,D. The factor π/ln 2 ≈ 4.532 corrects for the radial current flow.

**Measurement conditions:** use the VdP IC-CAP model on the **top-left quadrant**
(V_T-adjust = 0). The implanted areas are pn-junctions → the junction must stay
**reverse biased**, otherwise current flows through the whole substrate. Voltage sweep
−0.2 V … +0.2 V. The analyzer outputs R_AB,CD, so eq. 2 must still be applied.

**Questions (VdP):**

1. Explain why a voltage sweep range from −0.2 V to 0.2 V ensures the junction
   remains reverse biased towards the substrate.
2. Using the VdP structures, measure the sheet resistance of all implantations of the
   BICMOS design: **NW, SN, SP (= SP-NW)**, and also the **IC** (interconnect metal)
   layer. Take the correct data for the voltage — it is a 4-point measurement.
3. Calculate and report the **doping concentration** of all three implantations using
   the junction depths from the chapter-3 simulations. Are the calculated doping
   concentrations the same for the simulations, the process measurements (chapter 4)
   and these final measurements?
4. Compare the sheet resistances between the implantations and the metal, and explain
   the difference in magnitude.

### 1b. Electrical line-width measurements (ELM)

During annealing, dopants also diffuse **laterally** out of the implanted window
(lateral out-diffusion, fig. 6-5). Eq. 1 is only valid for L, W ≫ out-diffusion. In the
ELM structures the line width is comparable to the out-diffusion, so by measuring lines
of different drawn width and plotting apparent R□ against width, the (width-independent)
out-diffusion distance can be extracted.

**Questions (ELM):**

1. Using the ELM model, measure the resistance of the **NW and SN** lines with widths
   of **2, 5 and 10 µm**. The device length is **206 µm**; use the W/L ratio and eq. 1
   to get the sheet resistance. Compare with the VdP results — do you notice a
   difference?
2. Determine the lateral out-diffusion by plotting sheet resistance vs. width.
   The out-diffusion is width-independent, so it hits narrow lines harder. Compare the
   out-diffusion of the two implantations (NW vs SN) — can you explain the difference?

---

## 2. Transistor characterisation

Unified MOSFET model used for extraction (oxide thickness t_ox = 100 nm):

```
Linear:      I_D = µ·C_ox·(W/L)·[(V_GS − V_th)·V_DS − V_DS²/2]          (eq. 3)

Saturation:  I_D = (µ·C_ox/2)·(W/L)·(V_GS − V_th)²·[1 + λ(V_DS − V_DSsat)]   (eq. 4)
```

µ = electron (µₙ) or hole (µₚ) mobility, C_ox = gate-oxide capacitance per unit area,
W/L = channel width/length, V_th = threshold voltage, λ = channel-length-modulation
parameter, V_DSsat = velocity-saturation voltage. (Background: EE2C11 device lectures
or Rabaey ch. 3.)

### 2.1 PMOS I_D–V_G (transfer)

V_G swept −5 V → +5 V (extend if off/linear/saturation not all visible), V_D = −0.1 V,
V_sub = 0 V. Start in the **bottom-right quadrant (9×10¹¹)**; measure W:L = 20:1, 20:2,
20:5, 20:10 and 60:2.

- What is the influence of W/L on the obtained characteristics?
- Calculate **V_th and the hole mobility** from the I_D–V_G characteristics
  (t_ox = 100 nm). Do these parameters depend on geometry?
- Measure **only the 20:5** transistor in each other quadrant and determine V_th.
  How does it vary over the wafer? Compare with simulations (ch. 3) and theory (ch. 2).

### 2.2 PMOS I_D–V_DS (output)

V_DS swept 0 → −5 V, V_G stepped −1 → −8 V, V_sub = 0 V. Quadrant 9×10¹¹ only,
transistors 20:1 and 20:5.

- Do you see a difference in the curves of the two transistors (besides current
  magnitude)? Explain the cause — **two different short-channel effects** should be
  visible.
- Compare the results with the simulations.

### 2.3 NMOS I_D–V_G (transfer)

V_G swept −5 V → +5 V (or further), V_D = +0.1 V, V_sub = 0 V. Bottom-right quadrant
(9×10¹¹); dimensions 20:1, 20:2, 20:5, 20:10, 60:2.

- What is the influence of W/L on the obtained characteristics?
- Calculate **V_th and the electron mobility**; do they depend on geometry?
- Measure the **20:5** transistor in each quadrant → V_th vs. position/dose. Compare
  with simulations and theory.
- Compare all results to the PMOS — same trend and performance? Explain differences.

### 2.4 NMOS I_D–V_DS (output)

V_DS swept 0 → 5 V, V_G stepped 1 → 7 V, V_sub = 0 V. Quadrant 9×10¹¹, transistors
20:1 and 20:5.

- Difference between the curves of the two transistors (besides magnitude)? Explain.
- Compare with the simulations.
- Notable differences between PMOS and NMOS I_D–V_DS characteristics?

---

## Reference numbers carried over from earlier chapters

| Quantity | Value | Source |
|---|---|---|
| x_j NW | 2.085 µm | Ch. 3 Sentaurus (`device_sims/junction_depths.txt`) |
| x_j SN | 0.537 µm | Ch. 3 Sentaurus |
| x_j SP | 0.594 µm | Ch. 3 Sentaurus |
| R□ NW / SN / SP (in-line 4-pt probe) | 1488.8 / 57.4 / 510.6 Ω/□ | Ch. 4 Q1 |
| N (Irvin) NW / SN / SP | ≈1.5×10¹⁶ / ≈2×10¹⁹ / ≈1.5×10¹⁸ cm⁻³ | Ch. 4 Q3 |
| Simulated V_th NMOS (0.9/6/9 ×10¹¹) | 0.905 / 1.162 / 1.385 V | Ch. 3 device sims (3e11→0.905) |
| Simulated V_th PMOS (3/6/9 ×10¹¹) | −4.372 / −4.372 / −3.907 V | Ch. 3 device sims |
| C_ox (t_ox = 100 nm) | 3.45×10⁻⁸ F/cm² | ε₀·ε_SiO₂/t_ox |

## Group 9 data file map (`IC/Group 9/`)

| File(s) | Measurement |
|---|---|
| `NW_VDP.csv`, `SN_VDP.csv`, `SP_NW_VDP.csv`, `IC_VDP.csv` | VdP sweeps (V_force −0.2→0.2 V; columns V1, V2 sense; Iforce) |
| `ELM_NW_{2,5,10}um.csv`, `ELM_SN_{2,5,10}um.csv` | ELM 4-pt sweeps (VH, VL sense; Iforce), L = 206 µm |
| `NMOS_20_{1,2,10}_Id_Vg.csv`, `NMOS_60_2_Id_Vg.csv` | NMOS transfer @ BR quadrant (9×10¹¹), V_D = 0.1 V |
| `NMOS_{0e11,3e11,6e11,9e11}_20_5_Id_Vg.csv` | NMOS 20:5 transfer per quadrant |
| `NMOS_9e11_20_{1,5}_Id_Vds.csv` | NMOS output @ 9×10¹¹ |
| `PMOS_…` (same pattern) | PMOS equivalents, V_D = −0.1 V |
