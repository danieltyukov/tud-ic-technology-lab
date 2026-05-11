# ET4icp — IC Technology Practical Course

Working repository for the TU Delft course **ET4icp (IC Technology Practical Course)** at the Else Kooi Laboratory. The lab walks through fabrication of NMOS/PMOS transistors in the BICMOS5 process: theory → simulations → cleanroom processing → measurements → report.

## Layout

```
.
├── manuals/                     Course manual + virtual-classroom guide (PDF)
├── chapter02-ic-fabrication/    Theory + Assignments 1–5 (done)
├── chapter03-simulations/       Sentaurus process/device sims
├── chapter04-processing/        Cleanroom session notes
├── chapter05-wafer-layout/      Mask and layout work
├── chapter06-measurements/      PCM measurements
└── chapter07-report/            Final report drafts
```

## Progress

- [x] Chapter 1 — Introduction (read)
- [x] Chapter 2 — IC Fabrication (read + Assignments 1–5 in `chapter02-ic-fabrication/assignments.md`)
- [ ] Chapter 3 — Simulations
- [ ] Chapter 4 — Processing (cleanroom)
- [ ] Chapter 5 — Wafer Layout
- [ ] Chapter 6 — Measurements
- [ ] Chapter 7 — Final Report

## Working notes

- Equations are written in LaTeX inside the Markdown so they render in GitHub and can be copied straight into the final report.
- The simulation environment is the EKL server `et4icp.ewi.tudelft.nl`, reached over TUDelft VPN. Sentaurus tools: `sprocess -n`, `swb &`. See `manuals/Virtual classroom for ET4icp simulations.pdf` for the connection steps.
