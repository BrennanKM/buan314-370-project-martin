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
