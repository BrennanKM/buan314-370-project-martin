# Session log

One entry per working session: when it ran, what changed, the commits, the open items, and a plain-English explanation of each phase finished (these double as study notes for the talk).

## Session 1: Mon 2026-11-23, started 13:21 PT

**Goal:** first-session steps from the master prompt: read, set up (Part 0), skeleton (Part 3), interview and framing (Part 1), data gate (Part 2).

### What changed
- 13:21 to 13:23: read the master prompt, kickoff notes, the full instructions and the course notes.
- 13:23: Prompt 0.1 check. renv and janitor missing; everything else present.
- 13:24: `git init`; kickoff folder moved to `reference/` (gitignored); folder layout created.
- 13:24 to 13:29: guardrail file written and tested; CLAUDE.md, README, .gitignore, documentation files, plan and rubric tracker written.
- 13:29: Brennan approved project-only packages, a public repository with a private commit email, and a redacted public copy of the master prompt. renv set up; packages installed in the project library.
- 13:30: first commit; public repository created and pushed.
- Interview (five questions), eight candidate questions, shortlist of three (delegated to the assistant), three read-only web checks by subagents, stress test.
- Brennan chose the Michigan free-play question, a regulator as decision-maker, and both prediction targets. He selected the assistant's draft statements unchanged (rewrite owed).
- Read-only screen of the Michigan files; scorecard filled in: 8 pass, 3 concern, 0 fail. Brennan's decision: go, without outreach.
- The assistant found that the publisher's site terms bar scripted access, after it had already fetched the page and six workbooks by script. Scripted access stopped; the request to download the files through a browser on Brennan's behalf was declined.
- Wrote and tested `scripts/01_verify_raw.R`; drafted the provenance record.
- Session ended 13:58 PT.

### Packages installed this session (project renv library only)
renv 1.3.1, tidyverse 2.0.0, janitor 2.2.1, readxl 1.6.0, digest 0.6.39, plotly 4.12.1 and their dependencies (109 packages). The global R library was checked afterward and is unchanged.

### Commits
ffdf9cc (skeleton), 35edbcc (interview and candidates), 5181741 (proposal and scorecard), plus the end-of-session commit.

### Open items
O-001 rewrite the three statements in his own words · O-002 download the six workbooks by hand into `data/raw` · O-003 create an Overleaf account · O-004 open the five shortlist links himself. Details in `open_questions.md`.

### Plain-English explanations (study notes for the talk)

*Written by the AI assistant as study notes for Brennan, in the first person so he can rehearse from them. They are not his authored text and are not used in any deliverable.*

**Phase 0, setup.** The project lives in one folder that Git tracks and GitHub mirrors, so every step is dated and can be undone. A rules file (CLAUDE.md) tells the AI assistant what it may and may not do, such as never editing raw data and never writing my interpretation for me. R packages are installed inside the project with renv, so someone else can rebuild the same setup and my class scripts are not affected. A tracker lists every graded requirement, 97 rows plus 8 must-not-miss items, and nothing is marked done without a file to point to. Rows changed: none; no data yet.

**Phase 1, framing.** I started from "predatory gambling", which cannot be measured, and turned it into things that can: free bets handed out and tax paid. The assistant interviewed me, proposed eight questions and scored three of them as a skeptical manager would. I chose the Michigan free-play question, and I changed the decision-maker from a bettor to a regulator, because the data are totals per sportsbook and cannot tell one person what to do. I chose two things to predict: free play per $100 wagered, and whether a sportsbook paid no state tax in a month. The three statements in the proposal are still the assistant's drafts and I have to rewrite them myself. Rows changed: none.

**Phase 2, data gate.** The source is the Michigan Gaming Control Board's monthly files: one row is one licensed sportsbook in one month, 923 rows with wagering, 15 operators, January 2021 to October 2026. State law says adjusted receipts are gross receipts minus free play, so the difference between those two columns is the free-play deduction. A first check showed each target is related to something known beforehand (0.59 with the prior month for free play; -0.46 with prior-month size for paying no tax), which clears the course's 0.2 bar. The scorecard has no fails and three concerns: I have not downloaded the files myself yet, the site's terms forbid scripted downloads and reposting, and "Total Handle" has no official definition. I decided to go ahead with hand downloads and keep the State's files out of my public repository. Rows changed: none; the screen was read-only.

## Session 1, continued: Mon 2026-11-23, 14:08 to 14:31 PT

### What changed
- Brennan downloaded the six workbooks himself (14:00 PT) and created an Overleaf account. The files were first put in a different folder; the assistant copied them into `data/raw` from the folder he named. Fingerprints match the earlier screening copies 6 of 6; the screening copies were deleted.
- Provenance record filled in; three fields remain UNVERIFIED for Brennan.
- Audit written by script: 25 checks with counts and examples.
- Cleaning plan of 17 steps; Brennan decided every step. Cleaning script run: 1,956 → 923 rows; accounting closes.
- Codebook (28 variables) and 11 validation tests, all passing. Master script runs everything in about 9 seconds. Package versions locked in `renv.lock`.
- Exploration plan drafted: 12 sub-questions, no analysis run. Brennan handed the choice of sub-questions to the assistant, then answered "up to you" when asked what he expects. The assistant declined to write his expectations; nothing in the exploration has been computed.
- Figure style and palette written and checked for color-vision deficiency.

### Packages added to the lockfile
ggplot2 and its dependencies (already installed in the project library).

### Commits
3a90499 (raw files verified, audit, cleaning plan), ca195d1 (cleaning, codebook, validation), 0c8f901 (exploration plan), plus the end-of-session commit.

### Open items (details in `open_questions.md`)
O-001 rewrite the three problem statements · O-004 open the five shortlist links · O-005 settle three UNVERIFIED provenance fields · O-006 read the codebook against the data · **O-007 write the 12 expectations (blocks all analysis)**.

### Plain-English explanations (study notes for the talk)

*Written by the AI assistant as study notes for Brennan, in the first person so he can rehearse from them. They are not his authored text and are not used in any deliverable.*

**Phase 3, collecting the data.** I downloaded six Excel workbooks by hand from the Michigan Gaming Control Board's page, one per year from 2021 to 2026, because the State's site terms do not allow scripted downloads. A script takes a fingerprint (checksum) of each file and stops everything if a file ever differs, so anyone who repeats my download can prove they have the same files. The State's files are not in my public repository because the same terms do not allow reposting; the repository carries the click steps and the fingerprints instead. The publisher gives no row count, so I checked the files against themselves: in all 132 sheet-months the operators add up to the publisher's own total. Rows changed: none; the raw files are never edited.

**Phase 4, cleaning.** The workbooks are laid out sideways, four columns per sportsbook, so the first step turns them into one row per sportsbook per month: 1,956 cells. Each year appears in two workbooks and the copies agree, so I kept the newest copy (1,068 rows). I dropped 30 rows for two months not yet reported, 114 rows where a sportsbook took no bets at all, and 1 row with a negative amount wagered, leaving 923. I did not delete any row for being extreme: two tiny months and two months with a negative deduction keep their rows but have the rates blanked, and 21 months with a lump deduction and 15 partial first months are flagged, not removed. Every decision was mine, is logged with its row count, and the accounting closes: 1,956 - 888 - 30 - 114 - 1 = 923.

## Session 1, third stretch: Mon 2026-11-23, 16:00 to 16:14 PT

### What changed
- Brennan asked for the open questions again with recommendations. For the 12 expectations the assistant gave no recommended option (told him his real guess is the only good answer) and he picked all 12. Committed at 16:03, before any table existed.
- Four content decisions for the problem statements (with recommendations): what the estimates are for, who sets the cap, the constraint, the objective. Working drafts updated to version 2; wording still the assistant's.
- Exploration computed: 21 tables for the 12 sub-questions, the correlation matrix and its heat map.
- Predictor evidence table; Brennan chose three predictors per model and picked six expected slope directions (no recommendation). Committed at 16:12, before fitting.
- Both models fitted and reported; three model figures. Master script now runs 9 scripts in about 10 seconds.

### Commits
4832d34 (expectations), cf3476f (exploration and predictor evidence), a7507c7 (predictors and expected directions), plus the end-of-stretch commit.

### Open items (details in `open_questions.md`)
O-001 statements in his own words · O-004 open the five links · O-005 three UNVERIFIED provenance fields · O-006 read the codebook · **O-008 "what I found" and the top five or six findings** · **O-009 model interpretation and three cases**.

### Plain-English explanations (study notes for the talk)

*Written by the AI assistant as study notes for Brennan, in the first person so he can rehearse from them. They are not his authored text and are not used in any deliverable. They describe method only; what the results mean is for Brennan to write.*

**Phase 5 and 6, exploring.** Before anything was computed I wrote down what I expected for each of 12 sub-questions, so the results could surprise me. A script then built one summary table per sub-question, always showing how many rows sit behind each median or percentage, and flagging any group with fewer than 30 rows. It also built a correlation matrix: a grid showing, for every pair of variables, how closely they move together in a straight line, from -1 to 1. A correlation says two things move together; it does not say one causes the other. Rows changed: none; exploring only reads the cleaned data (923 rows).

**Phase 6, the two models.** Both models are ordinary linear regressions fitted on every row that has all the needed values. Model 1 predicts free play per $100 wagered from last month's free play, how long the sportsbook has been active, and whether it is commercial or tribal; it used 900 rows (23 left out, 17 of them because there is no prior month). Model 2 predicts whether a sportsbook pays no state tax, coded 1 for yes, from whether it paid none last month, its size last month, and its type; a regression on a yes-or-no target is called a linear probability model and its prediction is read as a probability. It used 906 rows. I chose only predictors that are known at the start of the month, and I recorded the direction I expected for each slope before fitting. Both models were judged on the same rows they were fitted to, so they will look better here than they would on new months.

## Session 2: Tue 2026-11-24, about 11:30 to 12:10 PT

### What changed
- Brennan asked to be walked through "what I found". After the first four questions he changed the process (D-024): he does all his writing at the end; until then the assistant writes its own answer for each passage, labels it, and keeps building.
- All assistant drafts are in one list, `documentation/process/assistant_drafts.md`: "what I found" for the 12 sub-questions, the six findings, the reading of both models, three scenario cases, and the report text. Nothing was put in `authored/`.
- Six exploration figures and three model figures are final in form, each checked against its table by the script. Titles are in one file, `documentation/figure_titles.csv`.
- Scenario predictions for three provisional cases. Alternative explanations listed for the six findings (no check run). Plan for the web versions written.
- The LaTeX report (`report/static`, zip in `report/overleaf_upload.zip`) and the web page (`docs/index.html`) are built with the draft text and a visible draft notice. Every number in both is read from `output/tables/report_numbers.csv`. The number audit is clean.
- Master script: 13 scripts, about 14 seconds.

- Fresh-copy test run twice (`documentation/fresh_copy_test.md`). First run: all 10 PNG figures differed, because the lockfile did not list the drawing package in use. Fixed. Second run: 92 files compared, none different (19 PDF figures differ only in the date stored inside them).

### Not done, and why
- The static report has never been compiled: there is no LaTeX on this computer. Brennan compiles in Overleaf (O-010).
- (Later the same session) Brennan approved publishing. The page is live at https://brennankm.github.io/buan314-370-project-martin/ and is byte for byte the file in the repository. Still to try: a private window and a real phone.
- No alternative-explanation check has been run (the course says to run them only when he asks).
- The slides, the evidence tally for the postmortem and the final repeat of the fresh-copy test are still to come.
- The temporary folder from the fresh-copy test was deleted at 12:12 on his say-so.

### Open items (details in `open_questions.md`)
O-001 statements · O-004 five links · O-005 three UNVERIFIED fields · O-006 codebook read-through · O-008 and O-009 final writing pass on findings and models · **O-010 compile in Overleaf** · **O-012 final writing pass on both reports**. (O-011, GitHub Pages, was answered: yes.)

### First step next time
Brennan uploads the zip to Overleaf and reports the first error. Otherwise the agent starts the slides and the evidence tally.

### Plain-English explanations (study notes for the talk)

*Written by the AI assistant as study notes for Brennan, in the first person so he can rehearse from them. They are not his authored text. They describe method only.*

**Phase 6, figures.** Each figure answers one sub-question and its title states the finding, not the variable names. I used five chart forms: a histogram for the spread of one number, ordered bars for shares, box plots to compare a number across 15 operators, a line chart for change over time, and a heat map for the correlation matrix; a two-panel chart shows free play by age separately for each operator type. Commercial is always blue and tribal always orange, in colors chosen to stay distinct for people with color-vision deficiency. The script that draws each figure recomputes every number it shows and stops if any differs from the saved table, so a picture cannot drift from its numbers. Rows changed: none (919 or 923 rows shown, as each caption says).

**Phase 6, scenario predictions.** A scenario prediction puts made-up but realistic values into the fitted equation: last month's free play, months active, operator type, last month's tax status and size. For each of three cases the script gives the predicted free play per $100 and the predicted probability of paying no tax, and it flags any case whose values lie outside what the data contain, because a prediction there reaches beyond the evidence. None of the three does. I checked one case by hand: 3.2356 + 0.4975 x 4 - 0.0323 x 48 + 0.1308 x 1 = 3.8055. Rows changed: none.

**Phase 8, the two reports.** The PDF report is written in LaTeX and the web report is one hand-written HTML file with its own styling, JavaScript and data, so it opens offline. Neither report has a number typed into it: a script collects every number with the file and cell it comes from, and both reports read from that one list, so they cannot disagree. The web page redraws all nine figures itself; four respond to the reader (the box plot, the no-tax line chart, the heat map and the predicted-against-actual scatter), and an explorer lets the reader pick sportsbooks and years and see the histogram and a summary table change. An audit script then checks every number in both reports and returns two lists, mismatches and numbers with no source; both are empty. Rows changed: none; the page holds all 923 rows, rounded for display only.

**Phase 9, the fresh-copy test.** The test asks whether a stranger could rebuild everything from the public repository alone. I downloaded a clean copy from GitHub into a temporary folder, put the six raw workbooks in place, installed the exact package versions from the lockfile, ran the one master script, and compared every output file with mine byte for byte. The first try failed: the ten PNG figures came out as different files, because my computer had a drawing package that the lockfile never listed, so the copy drew the same pictures a different way. After naming that package in the code and recording it, the second try matched on all 92 files, apart from the creation time that every PDF stores inside itself. Rows changed: none; the copy's processed data are identical, 923 rows.
