# Chapter 2 — Technology Assignments

Working notes for the five theory assignments in Chapter 2 of the ET4icp manual (BICMOS5 process). Numbers and equations are the working set we'll pull from when writing the final report.

---

## Assignment 1: Marker oxidation

The wafer stepper aligns to features etched into the silicon. To create those features, EKL grows oxide twice with a window etch in between. After stripping all the oxide, a step remains in the silicon. Below is the calculation of that step.

Deal–Grove oxidation rate:

$$\frac{dx}{dt} = \frac{B}{2x + A}$$

### a) Solve for $t$ with $x = x_0$ at $t = 0$

Separating variables and integrating:

$$\int_{x_0}^{x} (2x' + A)\,dx' = \int_{0}^{t} B\,dt'$$

$$\left[x'^2 + A x'\right]_{x_0}^{x} = B t$$

$$\boxed{\,t = \frac{(x^2 - x_0^2) + A(x - x_0)}{B}\,}$$

### b) Oxide thickness after the first oxidation (38.5 min, 1100 °C)

Constants at 1100 °C: $B = 0.553~\mu\text{m}^2/\text{hr}$, $B/A = 3.1695~\mu\text{m/hr}$, so $A = 0.17449~\mu\text{m}$.

Start from bare silicon, $x_0 = 0$, $t = 38.5/60 = 0.6417~\text{hr}$. The equation becomes $x^2 + Ax - Bt = 0$:

$$x = \frac{-A + \sqrt{A^2 + 4Bt}}{2} = \frac{-0.17449 + \sqrt{0.03045 + 1.4192}}{2}$$

$$\boxed{\,x_1 \approx 0.515~\mu\text{m}\,}$$

### c) Oxide thickness after the second oxidation (38.5 min)

**In the etched window** the silicon is bare again, so it's the same calculation as part (b):

$$x_{\text{window}} \approx 0.515~\mu\text{m}$$

**Outside the window** the existing oxide already slows things down. With $x_0 = 0.515~\mu\text{m}$:

$$x^2 + A x = x_0^2 + A x_0 + B t = 0.2653 + 0.0899 + 0.3549 = 0.7101~\mu\text{m}^2$$

$$x_{\text{non-etched}} = \frac{-A + \sqrt{A^2 + 4 \cdot 0.7101}}{2} \approx 0.760~\mu\text{m}$$

### d) Step height after all oxide is removed

For every $d_{ox}$ of oxide grown, $0.455\, d_{ox}$ of silicon is consumed.

In the window, two separate oxidations each consumed silicon starting from bare:

$$\Delta_{\text{window}} = 0.455 \cdot 0.515 + 0.455 \cdot 0.515 = 0.469~\mu\text{m}$$

Outside the window, silicon was consumed only up to the final oxide thickness:

$$\Delta_{\text{non-etched}} = 0.455 \cdot 0.760 = 0.346~\mu\text{m}$$

After stripping all oxide, the window sits lower than the surroundings:

$$\boxed{\,h = \Delta_{\text{window}} - \Delta_{\text{non-etched}} \approx 0.123~\mu\text{m} \approx 123~\text{nm}\,}$$

Note: the marker is a recess, not a bump. The window region ate up silicon twice (once per oxidation), the surrounding region only once.

---

## Assignment 2: Gate oxidation — wet or dry?

**Dry oxidation.**

Two reasons:

1. Quality. Dry $\text{SiO}_2$ has fewer defects and a cleaner Si/$\text{SiO}_2$ interface. Wet oxide pulls in OH groups that show up as interface traps and oxide charge. Both push $V_T$ around and hurt channel mobility, which is exactly what the gate oxide is supposed to be precise about.
2. Control. Wet oxidation is roughly an order of magnitude faster. For a 100 nm target film, dry growth lands more reliably on thickness without overshoot.

Dopant diffusion happens in both cases, but the gate-oxide anneal stays at 1000 °C and the timescale is short enough that the SN/SP profiles don't smear out much.

---

## Assignment 3: Implantation and diffusion — junction depths

> **Forward reference (per manual, p. 15):** the junction depths calculated here will be used to:
> - **compare against the Sentaurus simulations in Chapter 3** (process simulation will give a real doping profile; check whether the analytical Gaussian/limited-source estimate agrees), and
> - **interpret the electrical measurements in Chapters 4 and 6** (PCM measurements like sheet resistance and capacitance only make sense if you know roughly where the junction is).
>
> Keep the summary table at the end of this assignment handy — those three $x_j$ numbers are the ones we'll cite when comparing theory ↔ simulation ↔ measurement in the final report.

Three implants form the n/p regions. The junction sits where the implant concentration crosses the background doping.

### a) N-Well (P implant + 4 hr drive-in at 1150 °C)

$Q = 6.0 \times 10^{12}~\text{cm}^{-2}$, $D = 8.86 \times 10^{-13}~\text{cm}^2/\text{s}$, $t = 14400~\text{s}$, substrate $N_A = 10^{16}~\text{cm}^{-3}$.

**Why limited source?** The implanter delivers a fixed dose $Q$ and then the source is gone — there's no oxide reservoir feeding atoms in during the anneal. The Gaussian solution applies:

$$C(x,t) = \frac{Q}{\sqrt{\pi D t}} \exp\!\left(-\frac{x^2}{4 D t}\right)$$

With $Dt = 1.276 \times 10^{-8}~\text{cm}^2$ and $\sqrt{\pi D t} = 2.002 \times 10^{-4}~\text{cm}$:

**Peak concentration** (at $x = 0$):

$$N_p = \frac{Q}{\sqrt{\pi D t}} = \frac{6.0 \times 10^{12}}{2.002 \times 10^{-4}} \approx 3.0 \times 10^{16}~\text{cm}^{-3}$$

**Junction depth** where $C(x_j) = N_A$:

$$x_j = 2\sqrt{D t \cdot \ln(N_p/N_A)} = 2\sqrt{1.276 \times 10^{-8} \cdot \ln 3.0}$$

$$\boxed{\,x_j \approx 2.4~\mu\text{m}\,}$$

### b) Shallow-N (As implant, no drive-in)

$R_p = 0.0314~\mu\text{m}$, $\Delta R_p = 0.0114~\mu\text{m}$, $Q = 5.0 \times 10^{15}~\text{cm}^{-2}$, substrate $N_A = 10^{16}~\text{cm}^{-3}$.

Gaussian implantation profile:

$$N(x) = \frac{Q}{\sqrt{2\pi}\, \Delta R_p} \exp\!\left(-\frac{(x - R_p)^2}{2\, \Delta R_p^2}\right)$$

Peak:

$$N_p = \frac{5.0 \times 10^{15}}{\sqrt{2\pi} \cdot 1.14 \times 10^{-6}} \approx 1.75 \times 10^{21}~\text{cm}^{-3}$$

(This is above the solid solubility of As at the anneal temperature; the excess won't be electrically active.)

Junction depth from $N(x_j) = N_A$:

$$x_j - R_p = \Delta R_p \sqrt{2 \ln(N_p / N_A)} = 0.0114 \cdot \sqrt{2 \ln(1.75 \times 10^5)} = 0.0114 \cdot 4.91 \approx 0.056~\mu\text{m}$$

$$\boxed{\,x_j \approx 0.087~\mu\text{m}\,}$$

### c) Shallow-P (B implant inside the N-Well)

$R_p = 0.0685~\mu\text{m}$, $\Delta R_p = 0.0296~\mu\text{m}$, $Q = 4.0 \times 10^{14}~\text{cm}^{-2}$, n-well doping near the junction $N_D = 2 \times 10^{16}~\text{cm}^{-3}$.

Peak:

$$N_p = \frac{4.0 \times 10^{14}}{\sqrt{2\pi} \cdot 2.96 \times 10^{-6}} \approx 5.39 \times 10^{19}~\text{cm}^{-3}$$

Junction depth:

$$x_j - R_p = \Delta R_p \sqrt{2 \ln(N_p / N_D)} = 0.0296 \cdot \sqrt{2 \ln(2697)} = 0.0296 \cdot 3.97 \approx 0.118~\mu\text{m}$$

$$\boxed{\,x_j \approx 0.186~\mu\text{m}\,}$$

### Quick summary — reference table for later chapters

| Implant | $N_p$ ($\text{cm}^{-3}$) | $x_j$ theory ($\mu\text{m}$) | $x_j$ Sentaurus (Ch. 3) | Measured (Ch. 4 / 6) |
|---|---|---|---|---|
| NW (P + drive-in) | $3.0 \times 10^{16}$ | $\approx 2.4$ | **2.085** | _to fill_ |
| SN (As) | $1.75 \times 10^{21}$ | $\approx 0.087$ | **0.537** | _to fill_ |
| SP (B in NW) | $5.39 \times 10^{19}$ | $\approx 0.186$ | **0.594** | _to fill_ |

The empty cells are deliberate — they get filled in as the simulation work in Chapter 3 and the PCM measurements in Chapters 4 and 6 come back. Any large discrepancy is the thing the final report should explain (solid-solubility clipping, channelling, lateral diffusion, sheet-resistance assumptions, etc.).

---

## Assignment 4: BICMOS process flow — ordering the masks

The five core BICMOS5 masks, in process order: **NW → SN → SP → CO → IC.**

Matching the five PMOS top-views in the figure to that order:

| Process step | Mask | Figure |
|---|---|---|
| 1 | NW — N-well (large pink fill) | 3 |
| 2 | SN — $N^+$ source/drain (open outline on PMOS, not really applied here) | 5 |
| 3 | SP — $P^+$ source/drain stripes inside the well | 4 |
| 4 | CO — contact openings (small marks on source/drain) | 2 |
| 5 | IC — interconnect / metal (SU, G, S, D wired up) | 1 |

Reading order of the figures: **3 → 5 → 4 → 2 → 1.**

---

## Assignment 5: Vₜ-adjust

### Vₜ equations

For an NMOS (p-type body, channel acceptor concentration $N_A$):

$$V_{T,n} = V_{FB} + 2 \phi_F + \frac{\sqrt{2 \varepsilon_{Si} q N_A (2 \phi_F)}}{C_{ox}}, \quad \phi_F = \frac{kT}{q} \ln\!\frac{N_A}{n_i}$$

For a PMOS (n-type body in the N-well, donor concentration $N_D$):

$$V_{T,p} = V_{FB} - 2 |\phi_F| - \frac{\sqrt{2 \varepsilon_{Si} q N_D (2 |\phi_F|)}}{C_{ox}}, \quad \phi_F = -\frac{kT}{q} \ln\!\frac{N_D}{n_i}$$

### Why a single boron implant works for both devices

The $V_T$-adjust step puts a shallow boron sheet near the surface in *every* channel — both NMOS and PMOS, because no mask is used. Boron is an acceptor, so the dose $N_I$ ($\text{atoms/cm}^2$) shows up as a fixed extra negative charge inside the depletion region. To first order it shifts $V_T$ by:

$$\Delta V_T = + \frac{q N_I}{C_{ox}}$$

The shift is **positive for both devices**, regardless of what's already in the channel:

- NMOS channel is p-type. Adding more acceptors makes the channel even more p-type and pushes $V_T$ higher. Good — without this, the NMOS $V_T$ in BICMOS5 sits too low.
- PMOS channel is n-type (the well). Boron partially compensates the donors, reducing $|N_D - N_I|$ in the surface region, which pulls $V_T$ towards zero (less negative). Also good — without this, the PMOS $V_T$ would be too negative.

So the same implant fixes both at once. That's why the four-quadrant test wafer (Figure 2-15) sweeps boron dose: 0, $3 \times 10^{11}$, $6 \times 10^{11}$, $9 \times 10^{11}$ $\text{ions/cm}^2$ — to find the dose that lands both $V_T$ values where the spec wants them.

### Effect of increasing the Vₜ-adjust dose

| Device | $V_T$-shift | What it means |
|---|---|---|
| NMOS | more positive | threshold magnitude increases — harder to turn on |
| PMOS | less negative (closer to zero) | threshold magnitude decreases — easier to turn on |

Both $V_T$ values move in the same direction (positive on the number line). The magnitudes move in opposite directions, which is the trick that makes a single implant useful for a CMOS process.
