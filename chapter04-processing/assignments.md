# Chapter 4 — Processing (cleanroom) writeup

Notes and answers for the 2½-day cleanroom session at the EKL. Data comes from the lab photos in [`data/`](data/) (four-point-probe and ellipsometer screens, each labelled in red marker with the sample type) and the microscope images in [`ET4G9/`](ET4G9/). Junction depths are pulled from the Chapter 3 simulations.

The red-marker labels map to the three implanted regions of the BICMOS5 process, the same names that appear on the PCM test structures in the etch photos (`NW`, `SN`, `SP`, `SN-SP`, …):

- **NW** = N-Well (P implant, annealed 240 min at 1150 °C)
- **SN** = shallow n⁺ source/drain (As, activated by the gate-oxidation step)
- **SP** = shallow p⁺ source/drain (B inside the well, same activation)

---

## Doping concentration (Q1–Q3)

### Q1 — Sheet resistance (four-point probe)

The CDE ResMap four-point probe gives the average sheet resistance over a 10-point scan plus the spread across the wafer. Values read straight off the screens:

| Sample | Red label | Rₛ avg (Ω/□) | Std dev (Ω/□) | Min–Max (Ω/□) | Non-uniformity |
|--------|-----------|-------------:|--------------:|---------------|---------------:|
| NW | "N well" | 1488.8 | 10.9 (0.73 %) | 1471–1507 | range 35.6 |
| SN | n⁺ (low Rₛ) | 57.4 | 0.99 (1.73 %) | 55.7–58.6 | range 2.9 |
| SP | p⁺ (mid Rₛ) | 510.6 | 2.4 (0.47 %) | 506.6–513.9 | range 7.2 |

(The SP wafer was also read on the plain four-point screen: 511.3 Ω/□, std 6.26, 1.23 %. The two readings agree.)

The ordering is the physics you'd expect. The N-Well is lightly doped and carries the highest sheet resistance even though it is the deepest layer. SN is arsenic at solid-solubility levels, so it has the lowest. SP sits in between: boron gives a lower active concentration and lower mobility than arsenic, so its sheet resistance lands about 9× above SN.

### Q2 — Junction depths (from Chapter 3 simulations)

Taken from the numerical zero-crossing of NetActive in the Sentaurus cutlines (see `../chapter03-simulations/device_sims_assignments.md`):

| Sample | xⱼ (μm) |
|--------|--------:|
| NW | 2.085 |
| SN | 0.537 |
| SP | 0.594 |

### Q3 — Dopant concentration (Irving plot)

The sheet resistance and the junction depth together give the depth-averaged resistivity,

```
        Rₛ = ρ / xⱼ   ⇒   ρ = Rₛ · xⱼ
```

Reading that resistivity against the Irving (Irvin) curve for the right carrier type gives the average active concentration:

| Sample | ρ = Rₛ·xⱼ (Ω·cm) | Type | N (cm⁻³) |
|--------|------------------:|------|---------:|
| NW | 1488.8 × 2.085·10⁻⁴ ≈ 0.31 | n | N_D ≈ 1.5·10¹⁶ |
| SN | 57.4 × 0.537·10⁻⁴ ≈ 3.1·10⁻³ | n | N_D ≈ 2·10¹⁹ |
| SP | 510.6 × 0.594·10⁻⁴ ≈ 3.0·10⁻² | p | N_A ≈ 1.5·10¹⁸ |

These are averages over the whole diffused profile, so they sit below the simulated peaks, which is the expected behaviour. The Chapter 3 sims gave a peak of 1.83·10²⁰ for SN and 1.5·10¹⁸ for SP, and a ~10¹⁶ N-Well background. The averages line up: the SN average is about an order of magnitude under its peak (normal for a graded junction), and SP and NW match almost directly. Keep these three N values for Chapter 6.

---

## Oxide deposition, thickness and etch rate (Q4–Q8)

Two fresh wafers: one grown by wet (thermal) oxidation, one coated with PECVD TEOS oxide at 350–400 °C. Both measured on the J.A. Woollam ellipsometer (CompleteEASE), 5 points per wafer, before and after a 20 s dip in buffered HF (1:7).

### Q4/Q6 — Thickness and uniformity, before and after etch

| Wafer | Before (nm) | range / σ (nm) | After 20 s BHF (nm) | range / σ (nm) | Removed (nm) |
|-------|------------:|---------------:|--------------------:|---------------:|-------------:|
| Thermal (wet) "1 OX" / "WET OXI" | 294.34 | 1.54 / 0.61 | 260.23 | 8.09 / 3.21 | 34.1 |
| PECVD TEOS "PCVD" / "PECVD" | 324.94 | 5.65 / 2.34 | 214.34 | 20.25 / 8.22 | 110.6 |

(PECVD refractive index came out at n = 1.4532 @ 632.8 nm, close to stoichiometric SiO₂.)

**Q4 comment on as-deposited uniformity:** the thermal oxide is extremely flat, 1.5 nm spread over 294 nm, about 0.5 %. The PECVD film is roughly 4× less uniform, 5.6 nm over 325 nm. Thermal growth is rate-limited by oxidant diffusion through the existing oxide, a self-levelling process, while PECVD thickness follows gas-flow and plasma-density patterns in the chamber, which vary across the wafer.

**Q6 did uniformity change after etch:** yes, it got worse for both, and much worse for PECVD. The thermal oxide went from 1.5 to 8 nm range; the PECVD oxide went from 5.6 to 20 nm range (about 9 % of the remaining thickness). The PECVD fit MSE also doubled (7.0 → 15.7), so the film looks rougher to the optical model after etching. A porous film etches at a rate that tracks its local density, so any density variation across the wafer turns into a thickness variation once you etch into it.

### Q7 — Etch rate

```
   thermal:  34.1 nm / 20 s = 1.71 nm/s   (≈ 102 nm/min)
   PECVD:   110.6 nm / 20 s = 5.53 nm/s   (≈ 332 nm/min)
```

PECVD etches about 3.2× faster. The thermal number matches the textbook BHF (1:7) rate for thermal SiO₂ of ~1.5–2 nm/s almost exactly.

**Why they differ:** the thermal oxide is grown at >1000 °C by consuming the silicon itself, so it is dense, stoichiometric and close to fully bonded. The PECVD oxide is deposited cold (350–400 °C) from TEOS, so it is less dense, more porous and carries leftover Si–OH and water in the film. BHF works its way through that open network quickly and attacks the weaker bonds, so the etch runs faster and less evenly. A post-deposition densification anneal would shrink the PECVD film and bring its etch rate down toward the thermal value, which is the usual industrial fix.

### Q8 — Advantages, disadvantages, gate-oxide choice

Thermal (wet) oxidation: dense, low defect density, excellent uniformity, low interface-trap density and high breakdown field. The cost is a high thermal budget (it adds to every junction's diffusion), it consumes silicon, and it only grows on exposed Si, so it can't go over metal.

PECVD: low temperature, so it deposits on top of aluminium and other finished layers, it is fast, and it coats any surface. The cost is lower film quality, more pinholes and trapped charge, worse uniformity and a higher etch rate.

For a **gate oxide** you want thermal oxidation. The gate dielectric sits directly under the channel, so interface-trap density, leakage and breakdown all matter, and only a grown thermal oxide gives a clean Si–SiO₂ interface. PECVD is the right tool for the layers where temperature is the constraint (inter-metal dielectric, passivation over aluminium), not for the gate. (For the gate specifically, dry thermal oxidation beats wet because it is even denser and more controllable, but between the two methods done here, thermal wins.)

---

## CMOS wafer metal etching and selectivity (Q6–Q10, second group)

A BICMOS wafer finished up to aluminium, then the IC-mask pattern was etched: one wafer wet (phosphoric acid, 35 °C) and one dry (Cl/HBr plasma). Microscope images in [`ET4G9/wetetching/`](ET4G9/wetetching/) and [`ET4G9/Dryetch/`](ET4G9/Dryetch/).

### Q6 — Pattern after lithography

Contact openings and metal lines line up with the underlying devices on the microscope check, so the litho was good enough to etch.

### Q7 — Wet etch, before the poly-Si dip

After the aluminium clears (colour change from shiny to grey marks the endpoint) but before the HNO₃–HF dip, the metal surface looks rough and grainy and the cleared field is covered in tiny specks. Those are the 1 % silicon in the Al alloy: phosphoric acid etches the aluminium but leaves the silicon behind as grains. That is exactly what the poly-dip is there to remove.

### Q9 — Isotropic or anisotropic

**Wet = isotropic.** In `wetetch_metal_lines_100x` and `wetetch_comb_structure_100x` the line edges are rounded and ragged and the lines are visibly narrower than drawn, because the acid undercuts sideways under the resist at the same rate it etches down.

**Dry = anisotropic.** In `dryetch_comb_lines_50x` and `dryetch_finger_structure_100x` the edges are straight and vertical, corners stay sharp, and the narrow lines hold their full mask width. The directional ion bombardment etches down but barely sideways, so there is almost no undercut.

### Q10 — Oxide loss and selectivity

The field oxide started near 100 nm. The cleanest evidence for how much each process ate into it is the interference colour of the field oxide in the two image sets:

- **Wet:** the field is blue/violet, the colour of ~100 nm SiO₂. Phosphoric acid essentially does not touch oxide, so the 100 nm is still there. With ~1 μm of aluminium removed and a few nm of oxide at most, the Al:SiO₂ selectivity is very high, effectively >100:1.
- **Dry:** the field is brown/grey, the colour of a thinner oxide (~50 nm or below). The plasma's physical bombardment plus chemistry erodes SiO₂ as well, so a good fraction of the 100 nm is gone. Selectivity is far lower, order 10–20:1.

So **wet etching is the more selective process** (it etches oxide the least). The trade-off is the one from Q9: wet buys you selectivity but loses dimensional control (undercut, no fine pitch), while dry buys you vertical, accurate lines but eats the underlying oxide and needs careful endpoint control, and it also hardens the resist (which is why the dry wafer's resist comes off in an O₂ plasma instead of acetone).

> An exact selectivity number would need the reflectometer reading on the BICMOS field oxide after each metal etch, which wasn't captured here. The colour evidence is unambiguous on the direction: wet ≫ dry in oxide selectivity.

---

## Numbers to carry into Chapter 6

| Quantity | NW | SN | SP |
|----------|---:|---:|---:|
| Rₛ (Ω/□) | 1488.8 | 57.4 | 510.6 |
| xⱼ (μm) | 2.085 | 0.537 | 0.594 |
| ρ (Ω·cm) | 0.31 | 3.1·10⁻³ | 3.0·10⁻² |
| N (cm⁻³) | 1.5·10¹⁶ (n) | 2·10¹⁹ (n) | 1.5·10¹⁸ (p) |

Etch rates (BHF 1:7): thermal SiO₂ 1.71 nm/s, PECVD SiO₂ 5.53 nm/s.
