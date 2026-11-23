# [Working title: to be set once the question and data source are confirmed]

**Brennan Martin** · BUAN 314-370, Descriptive Analytics & Data Management · Dr. Steven Levkoff · University of San Diego · Fall 2026

> Status (2026-11-23): project set up. The research question and data source are being chosen (Parts 1 and 2 of the course instructions). Nothing below is final.

## Deliverables

| Deliverable | Link |
|---|---|
| Static report (PDF, LaTeX compiled in Overleaf) | *not yet built* |
| Interactive report (GitHub Pages) | *not yet published* |
| Recorded presentation | *not yet recorded* |
| Slides (PDF) | *not yet built* |
| Postmortem: the AI assistant as a partner | [documentation/postmortem.md](documentation/postmortem.md) *(not yet written)* |

## The three problem statements

*To be written by Brennan Martin, in his own words (Part 1).*

## Data

*Source, license and how to obtain the data: to be filled in once the source passes the viability scorecard (Parts 2 and 4).*

## How to run everything

*Run instructions, software versions, the script table and the expected run time are added in Part 9.*

## Folder map

| Folder | What it holds |
|---|---|
| `data/raw` | Files exactly as downloaded. Never edited. |
| `data/processed` | Analysis-ready files written by the scripts. |
| `documentation/` | Proposal, provenance record, data audit, codebook, wrangling log, prompt log, exploration plan, interactive plan, postmortem. |
| `documentation/process/` | How the project was run: plan, rubric tracker, decision log, questions log, session log, and every prompt given to an AI subagent. |
| `authored/` | Text written by Brennan Martin, kept verbatim. |
| `scripts/` | Numbered R scripts, run in order by one master script. |
| `output/tables`, `output/figures` | Summary tables and figures made by the scripts. |
| `report/static` | LaTeX source for the static report, and the compiled PDF in `report/`. |
| `presentation/` | Slides (PDF) and the link to the recording. |
| `docs/index.html` | The interactive report: one hand-written HTML file, served by GitHub Pages. |

## AI-use statement

*The final statement is added with the reports (Parts 9 to 11). In short: the code in this repository is written and run by an AI coding assistant (Claude Code) under my direction. The question, every data decision and all interpretation are mine. Every prompt is recorded in [documentation/prompt_log.md](documentation/prompt_log.md).*
