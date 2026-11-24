# Free play and tax in Michigan's online sports betting market (working title)

**Interactive report: https://brennankm.github.io/buan314-370-project-martin/**

**Brennan Martin** · BUAN 314-370, Descriptive Analytics & Data Management · Dr. Steven Levkoff · University of San Diego · Fall 2026

> **Status, 2026-11-24:** data collected, audited, cleaned and tested; exploration, nine figures and both models done; both reports are built. **The wording of both reports, the figure titles and the problem statements is still the AI assistant's draft**, marked as such wherever it appears, until Brennan Martin has revised it. The static report has not been compiled yet. The interactive report is live at https://brennankm.github.io/buan314-370-project-martin/ and carries the same draft notice.

## Deliverables

| Deliverable | Link |
|---|---|
| Static report (PDF, LaTeX compiled in Overleaf) | LaTeX source: [report/static](report/static). *PDF not yet compiled* |
| Interactive report (GitHub Pages) | **https://brennankm.github.io/buan314-370-project-martin/** (source: [docs/index.html](docs/index.html)) |
| Recorded presentation | *not yet recorded* |
| Slides (PDF) | *not yet built* |
| Postmortem: the AI assistant as a partner | [documentation/postmortem.md](documentation/postmortem.md) *(not yet written)* |

## The question

How much do Michigan's online sportsbooks rely on promotional free play, and what does that do to the tax they pay? The decision-maker is a regulator protecting bettors (the Michigan Gaming Control Board, or a state lawmaker) deciding whether to cap or limit free-play deductions.

### The three problem statements

*Working drafts in the AI assistant's wording; the content choices are Brennan Martin's. He rewrites them in his own words (`authored/problem_statements.md`).*

- **Descriptive.** The Michigan Gaming Control Board needs to see how much free play the state's online sportsbooks deducted for every $100 wagered, and how often a sportsbook paid no state tax in a month, across the 15 licensed operators, commercial and tribal, month by month from January 2021 to October 2026, to learn which sportsbooks lean hardest on free-bet promotions and whether that reliance is fading.
- **Predictive.** At the start of each month, using only what each sportsbook reported in earlier months, the Board wants two estimates for that sportsbook's month ahead: the free play it will deduct per $100 wagered (a percent), and whether it will pay no state tax that month (yes or no), so that staff can review the free-play claims of the flagged sportsbooks first.
- **Prescriptive.** Given those estimates, what cap on the monthly free-play deduction, as a percent of a sportsbook's gross sports betting receipts, should the Board recommend that the Legislature write into law, to collect the most state and city tax, with one cap for every operator and no cap below the share of gross receipts that the median sportsbook-month actually deducted?

## Data

- **Source:** Michigan Gaming Control Board, "Internet Sports Betting Revenues and Taxes", six yearly Excel workbooks, 2021 to 2026. Page: https://www.michigan.gov/mgcb/detroit-casinos/resources/revenues-and-wagering-tax-information
- **What one row is:** one licensed internet sports betting operator in one month. 923 rows after cleaning; 15 operators; January 2021 to October 2026.
- **License:** none is stated for the data. The State's site terms do not allow scripted downloads or republishing its files without written permission, so **the raw workbooks are not in this repository and there is no download script**. Details and the quoted terms: [documentation/data_provenance.md](documentation/data_provenance.md).
- **How to obtain the raw data:** by hand, in a web browser. Open the page above, scroll to "Internet Sports Betting Revenues and Taxes Downloads", click "Excel" next to each year from 2026 down to 2021, and move the six files into `data/raw` without opening or renaming them. `scripts/01_verify_raw.R` then compares each file with the checksum recorded in [documentation/raw_file_checksums.csv](documentation/raw_file_checksums.csv) and stops if any differs. (The publisher revises the current year's workbook as new months are reported, so a later download of the 2026 file will not match; the earlier years should.)
- **Cleaned data:** [data/processed/mgcb_operator_months.csv](data/processed/mgcb_operator_months.csv), described variable by variable in the [codebook](documentation/codebook.md).

## How to run everything

Software: R 4.6.1 (with RStudio if you like). Package versions are locked in `renv.lock`.

1. Download or clone this repository and open the folder as the working directory.
2. Download the six raw workbooks by hand into `data/raw` (steps above).
3. In R, run `renv::restore()` to install the package versions this project used. (Opening R in the folder installs `renv` itself the first time.)
4. Run `Rscript scripts/run_all.R` from the project folder, or `source("scripts/run_all.R")` in R.
5. Outputs appear in `data/processed`, `documentation`, `output`, `report/static` and `docs/index.html`. Expected run time: about 15 seconds for the 13 scripts. The last script is a number audit; it should report 0 mismatches and 0 numbers with no source.

## Scripts

Run in this order by `scripts/run_all.R`.

| Order | Script | What it does | Reads | Writes | Packages |
|---|---|---|---|---|---|
| (helper) | `scripts/00_functions.R` | Shared helpers: reads the raw workbooks as published into long form, with no cleaning; writes Markdown tables | `data/raw/*.xlsx` | nothing | readxl, dplyr, purrr, stringr, tibble |
| (helper) | `scripts/00_style.R` | The figure style and fixed colors used by every figure | nothing | nothing | ggplot2 |
| 1 | `scripts/01_verify_raw.R` | Checks that the six hand-downloaded workbooks are present and match their recorded checksums | `data/raw/*.xlsx`, `documentation/raw_file_checksums.csv` | `output/tables/raw_file_facts.csv` (and the checksum record on the very first run) | digest, readxl |
| 2 | `scripts/02_audit.R` | Audits the raw data: column profile and 25 checks with counts and examples. Changes nothing | `data/raw/*.xlsx` | `documentation/data_audit.md` | readxl, dplyr, purrr, stringr, tibble, tidyr |
| 3 | `scripts/03_clean.R` | Carries out the approved cleaning plan step by step and stops if any step differs from the plan | `data/raw/*.xlsx` | `data/processed/mgcb_operator_months.csv`, `documentation/wrangling_log.md`, `output/tables/wrangling_steps.csv` | readxl, dplyr, purrr, stringr, tibble |
| 4 | `scripts/03b_codebook.R` | Writes the codebook; computes ranges and missing shares from the processed file | `data/processed/mgcb_operator_months.csv` | `documentation/codebook.md`, `documentation/codebook_rules.csv` | readxl, dplyr, purrr, stringr, tibble |
| 5 | `scripts/04_validate.R` | Eleven tests that guard the processed data; stops if any fails | processed data, `documentation/codebook_rules.csv`, `documentation/codebook.md`, `output/tables/wrangling_steps.csv` | `output/tables/validation_results.csv` | dplyr, stringr |
| 6 | `scripts/05_eda.R` | One summary table for each of the 12 exploration sub-questions, the correlation matrix and its heat map | processed data | `output/tables/eda_*.csv` (21 tables), `output/figures/fig12_correlation_heatmap` | dplyr, tidyr, stringr, ggplot2 |
| 7 | `scripts/06a_style_check.R` | Draws the palette sample, writes the palette for the web page, checks the colors under simulated color-vision deficiency | `scripts/00_style.R` | `output/figures/fig00_palette_sample.png` and `.pdf`, `output/palette.json`, `output/tables/palette_cvd_check.csv` | ggplot2 |
| 8 | `scripts/06_figures.R` | Draws the five other exploration figures and checks every number in them against the exploration tables | processed data, `output/tables/eda_*.csv` | `output/figures/fig01`, `fig03`, `fig04`, `fig09`, `fig10` (PNG and PDF), `output/tables/figure_checks.csv` | dplyr, tidyr, ggplot2 |
| 9 | `scripts/07a_model_plan.R` | Evidence for choosing predictors: correlations and group averages with counts. Fits nothing | processed data | `output/tables/model_candidates.csv` | dplyr |
| 10 | `scripts/07_models.R` | Fits the two linear regressions (the second is a linear probability model); saves estimates, equations, fit, the two-by-two table, hand-worked predictions, three scenario predictions and three figures | processed data | `output/tables/model*.csv`, `output/figures/fig_m1_*`, `fig_m2_*` | dplyr, tidyr, ggplot2 |
| 11 | `scripts/08_report_numbers.R` | Collects every number the two reports use, each with the file and cell it comes from; writes the LaTeX tables, copies the figures and zips the LaTeX project for Overleaf | `output/tables/*.csv`, `documentation/codebook.md`, `output/figures/*.pdf` | `output/tables/report_numbers.csv`, `report/static/numbers.tex`, `report/static/tables/`, `report/static/figures/`, `report/overleaf_upload.zip` | dplyr |
| 12 | `scripts/09_export_html_data.R` | Builds the data each view of the web page needs and writes it, the numbers and the figure titles into the page | processed data, `output/tables/*.csv`, `documentation/figure_titles.csv`, `output/palette.json`, `docs/index.html` | `docs/index.html` (data block, numbers, titles), `output/page_data.json`, `output/tables/html_data_checks.csv`, `explorer_checks.csv` | dplyr, jsonlite |
| 13 | `scripts/10_number_audit.R` | Audits every number in both reports and the figure titles against its source; changes nothing | `report/static/sections/*.tex`, `docs/index.html`, `documentation/figure_titles.csv`, `output/tables/report_numbers.csv` | `output/tables/number_audit.csv`, `documentation/number_audit.md` | none |

The static report is compiled separately: upload `report/overleaf_upload.zip` (written by script 11) to Overleaf and press Recompile.

## Folder map

| Folder | What it holds |
|---|---|
| `data/raw` | The six workbooks exactly as downloaded. Never edited. Not published (see Data). |
| `data/processed` | The analysis-ready file written by the scripts. |
| `documentation/` | Proposal and viability scorecard, provenance record, data audit, cleaning plan, wrangling log, codebook, exploration plan, prompt log, interactive plan, postmortem. |
| `documentation/process/` | How the project was run: plan, rubric tracker, decision log, questions log, session log, the interview record, and every prompt given to an AI subagent. |
| `authored/` | Text written by Brennan Martin, kept verbatim. |
| `scripts/` | Numbered R scripts, run in order by `run_all.R`. |
| `output/tables`, `output/figures` | Summary tables and figures made by the scripts. |
| `report/static` | LaTeX source for the static report, and the compiled PDF in `report/`. |
| `presentation/` | Slides (PDF) and the link to the recording. |
| `docs/index.html` | The interactive report: one hand-written HTML file, served by GitHub Pages. |

## AI-use statement

*The final statement is added with the reports. In short: the code in this repository is written and run by an AI coding assistant (Claude Code) under my direction. Every prompt and every question the assistant put to me, with my answer word for word, is recorded in [documentation/prompt_log.md](documentation/prompt_log.md) and [documentation/process/questions_log.md](documentation/process/questions_log.md).*
