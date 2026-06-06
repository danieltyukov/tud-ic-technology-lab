# Chapter 7 — Report

> Extracted from *Manual ET4icp 2025v2*, Chapter 7 (pp. 45–48). Everything needed to know to write and structure the final group report.

## Overview

- To get the **2 credit points** for this course, each group has to write a **group report**.
- The report is graded using the **rubric at the end of this chapter** (see [Grading rubric](#grading-rubric-24-points-total) below).
- Hand in the report on the **Brightspace page** of the course under **Assignments**.
- There is a **hard deadline** — after it passes you can no longer hand in the report and you lose the possibility to get credit points.
- After submission and grading, a **meeting will be scheduled with the group** to discuss the report after the grade has been presented.
- A **plagiarism check** is done during submission. Cases of plagiarism are reported to the exam committee.

## Required content

The content of the report should be:

1. An **introduction** to the lab and the goal of the report
2. The **technology assignments** (Chapter 2)
3. The **process and device simulation assignments** (Chapter 3)
4. The **lab assignments** (Chapter 4)
5. The **measurements assignments** (Chapter 6)
6. **Conclusion**

Key requirements on the content:

- **Explain all results and graphs thoroughly.**
- When possible, **compare results obtained through calculations, simulations, processing and/or measurements** — e.g. the **threshold voltages** and **doping concentrations**.
- Make sure **symbols in equations are explained** and **graphs are readable and contain units on their axes**.
- The report should be **to the point**, but contain all necessary information so that **someone not familiar with the lab manual can understand it**.

## Report structure (guidelines)

Use the information on reporting from course **EE4C01**. The report should consist of:

- **Title page** — names, e-mail addresses, student numbers and course ID.
- **Introduction** — the project context: background (the BICMOS process), boundaries, objectives, background theory, introduction to the rest of the report. Make it understandable for people not familiar with the course.
- **Body** — all the assignments from the various chapters. Do **not** just put the question number and the answer; introduce the reader to the subject and the background a bit. Write it so that someone without the manual could understand it.
- **Conclusions** — compare the theory, simulations, processing and measurement results and comment on the differences and similarities.
- **References** (if used) — consistent formatting, **IEEE style preferred**.
- **Appendices** (if required).

## Formatting tips

- Use a **single-column** lay-out.
- Make sure **figures are readable**, including the axes and the units. Properly label the axes.
- Use **page numbers and section numbers**.
- Properly **format equations, number them and explain all symbols**.
- Do not copy results from others (plagiarism check, see above).

## Grading rubric (24 points total)

| Criteria | Excellent (8–10) | Sufficient (6–7) | Insufficient (5) | Max. points |
|---|---|---|---|---|
| **Preparatory exercises** | The questions are answered flawlessly. | Reasoning is in the right direction, but some calculation errors are made. | Reasoning is incorrect or no answer is given. | 1 per main question |
| **Dopant simulations** | Analysis and discussion are complete and correct. Properties of dopants are correctly assigned and the correct masking layer is chosen. | Analysis and discussion of implantation simulations is (mostly) correct. The properties of the dopants are mostly correctly assigned. The correct masking layer is chosen but without argumentation. | Analysis of implantation simulations is (mostly) incorrect. The properties of the dopants are wrongly assigned and the wrong masking layer is chosen. | 3 |
| **Device simulations** | Analyses are complete and correct. Regions in the doping profiles are correctly identified and all threshold voltages have been identified and discussed. | Analysis is partly complete and correct. Not all doping profiles are correctly identified and few threshold voltages are missing. | Analysis is incomplete. Doping profiles are not identified and threshold voltages are missing. | 2 |
| **Processing: implantations** | All doping concentrations are correctly determined. | Part of the doping concentrations are correctly determined. | None of the doping concentrations are correctly determined. | 1 |
| **Processing: etching & selectivity** | Differences between wet and dry etching are correctly identified and explained. | Differences between wet and dry etching are partly identified and explained. | Differences between wet and dry etching are not correctly identified or missing. | 2 |
| **Processing: oxide** | Etch rate is calculated and a correct argument with respect to differences of the etch rate is given. | Etch rate is calculated. A partly correct argument with respect to differences of the etch rate is given. | Etch rate is missing or no argument is given. | 2 |
| **Measurements: VdP** | Sheet resistance is correctly calculated and the doping concentration is correctly determined. | Sheet resistance is correctly calculated but the doping concentrations are incorrect. | Sheet resistance is incorrectly calculated and the doping concentration is incorrectly or not determined. | 2 |
| **Measurements: ELM** | A correct and complete analysis of the lateral out-diffusion is given. | Results are compared to the VdP measurements, but only a partial analysis of the lateral out-diffusion is given. | No analysis for the lateral out-diffusion is given. | 1 |
| **Measurements: MOSFET** | The threshold voltage and mobility are correctly calculated and discussed. The short-channel effects are identified and discussed. | The threshold voltage and mobility are correctly calculated or the short-channel effects are identified, but not both, or no discussion is given. | Threshold voltage and mobility calculations are missing and the short-channel effects are not identified. | 2 |
| **Lay-out** | Well-structured document. General presentation of the content is effective. | Structure is acceptable. General presentation of the content is satisfactory. | Structure needs considerable improvements. Presentation of content not very effective. | 2 |
| **Language** | Expressed and formulated very well. Document has a smooth flow with sufficient transitions. Document is without spelling and grammatical errors. | Sufficiently expressed argumentation. The document contains little spelling and grammatical errors. | Poorly expressed. Document contains serious spelling and grammatical errors. | 2 |
| **Total points:** | | | | **24** |

## Report-specific instructions from other chapters

Items elsewhere in the manual that explicitly say "put in the report" or affect the report:

### Chapter 3 — Simulations
- Copy the data generated by `implant-As.cmd`, `implant-B.cmd` and `implant-Sb.cmd` — **you will need this for the report**. All results can be merged into a single plot with `python3 implant.py`.

### Chapter 6 — Measurements
- **Do not use plots from ICCAP in the report!** Export data (`*.mdm`/`*.mdl`) and re-plot it yourself (Matlab/Excel/Python).
- **Van der Pauw:** measure the sheet resistance of all implantations of the BICMOS design (NW, SN, SP (= SP-NW)) and the IC layer. **Calculate and report the doping concentration of all three implantations** using the junction depth from the Chapter 3 simulations. Compare: are the calculated doping concentrations the same for the simulations, process measurements (Chapter 4) and these final measurements?
- **PMOS I_D–V_G:** calculate **V_Th and the hole mobility** (used in eq. 3 and 4) from the I_D–V_G characteristics and **put them into the report**. The oxide thickness is **100 nm**. Discuss whether these parameters depend on geometry, how V_Th varies over the wafer (V_T-adjust quadrants), and compare with simulations (Chapter 3) and theory (Chapter 2).
- **PMOS I_D–V_DS:** explain the difference between the 20:1 and 20:5 curves — **two different short-channel effects** should be visible. Compare with simulations.
- **NMOS I_D–V_G:** calculate **V_Th and the electron mobility** and **put them into the report** (t_ox = 100 nm). Compare V_Th variation over the wafer with simulations and theory, and compare all results to the PMOS (same trend and performance? explain differences).
- **NMOS I_D–V_DS:** explain the difference between the curves of the transistors (besides current magnitude).

## Mapping rubric → repo folders

| Rubric criterion | Where the material lives |
|---|---|
| Preparatory exercises | `chapter02-ic-fabrication/` |
| Dopant simulations, Device simulations | `chapter03-simulations/` |
| Processing: implantations, etching & selectivity, oxide | `chapter04-processing/` |
| Measurements: VdP, ELM, MOSFET | `chapter06-measurements/` |
| Lay-out, Language | report writing itself |

## Final notes from the manual

- If you have any problems or questions regarding the report, let the staff know.
- Suggestions for improving the course or the manual are welcome.
