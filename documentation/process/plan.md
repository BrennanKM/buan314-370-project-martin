# Project plan

Target: everything finished and checked by **Tue 2026-12-01**. Dates are targets. If one slips, the fallback in the last column applies and Brennan is told the same day.

Last updated: 2026-11-24, session 2. On 2026-11-24 Brennan changed the order of work (decision D-024): the assistant drafts every passage that is his, labels it, and builds both reports with the drafts; he does all his writing in one pass at the end. Phases 6 and 8 therefore ran ahead of phase 7.

| Phase | Course parts | Target date | Owner | Brennan needed for | Status | Fallback if it slips |
|---|---|---|---|---|---|---|
| 0 Setup | 0, 3 | Mon 11-23 | agent | Approve the GitHub repository; Overleaf, Zoom and YouTube account status; approve package installs | done 11-23, except the Overleaf account (O-003) | Work continues locally with commits; the repository is created the moment he approves. YouTube verification is started first because it can take time; a GitHub release is the backup host for the video. |
| 1 Interview and framing | 1 | Mon 11-23 | Brennan + agent | Interview answers; choose topic and decision-maker; rewrite the three statements; fix what Prompt 1.4 lists | in progress: question, decision-maker and targets chosen 11-23; statements are still the assistant's drafts (O-001) | If the statements are not final by Tue 11-24 noon, the data gate runs on the draft statements and the final wording follows the scorecard (the instructions expect a revision after Part 2 anyway). |
| 2 Data gate | 2 | Mon 11-23 to Tue 11-24 | agent, Brennan decides | Go / rescope / no-go on the scorecard; download one file himself. **Milestone 1** | gate decided 11-23: go (D-016); Brennan's download is owed (O-002) | One fail on the scorecard: loop back using the instructions' Part 2 table, log three lines, and test the pre-screened alternative source the same day. Two failed loops: ask Dr. Levkoff (Brennan sends). |
| 3 Collect and provenance | 4 | Tue 11-24 | agent | Settle anything UNVERIFIED. **Milestone 2** | done 11-23 except 3 UNVERIFIED fields that Brennan has to settle (O-005) | If the scripted download is blocked, record the manual click steps and checksums; this still passes. |
| 4 Clean and codebook | 5 | Tue 11-24 | agent, Brennan decides | "My decision" on every cleaning step; labels marked UNDOCUMENTED. **Milestone 3** | done 11-23: 17 decisions, 923 rows, 11 of 11 tests pass. Brennan's read-through of the codebook is owed (O-006) | Steps without a decision are not carried out. Rows are kept and values marked missing only where he has approved it; the rest wait in `open_questions.md`. |
| 5 Exploration plan | 6 (plan), 8.1 | Tue 11-24 | Brennan + agent | Edit sub-questions; write "what I expect" for each; choose predictors and expected slope directions | done 11-23: 12 expectations and 6 slope directions picked by Brennan and committed before any analysis; predictors chosen (D-023) | No analysis runs on a sub-question or model until its expectation is written. Unanswered rows wait; tables for answered rows proceed. |
| 6 Autonomous build | 6, 7, 8, 9, 11 (build) | Wed 11-25 to Sat 11-28 | agent | Nothing; questions are queued | done 11-24 except the fresh-copy test: 21 exploration tables, nine figures (six exploration, three model), both models with scenario predictions, the plan for the web versions, the LaTeX project, the web page with explorer, the number audit, a 13-script master run, renv lockfile. Still to do here: fresh-copy test with an independent verifier, README links and AI-use statement | Order of protection: exploration tables and correlation matrix, six figure prototypes, both models, master script and renv, then the HTML and LaTeX skeletons. |
| 7 Interpretation | 6, 7, 8 (his words) | Sat 11-28 to Sun 11-29 | Brennan | One writing pass at the end (D-024): keep or change each assistant draft: "what I found", the six findings, the model reading, the three cases, the statements. **Milestone 4** | assistant drafts ready 11-24 (`assistant_drafts.md`); his pass is owed (O-001, O-008, O-009) | If time is short he writes the findings for the six figures first; remaining sub-questions get one sentence each. |
| 8 Reports | 10, 11 | Sun 11-29 to Mon 11-30 | Brennan writes, agent typesets | His pass on the report text; Overleaf upload and compile (O-010); GitHub Pages approval (O-011) | built 11-24 with labeled draft text; number audit clean; not compiled, not published | LaTeX and HTML skeletons are built in phase 6 with placeholders, so only his text and the audits remain. |
| 9 Postmortem and talk | 13, 12 | Mon 11-30 | Brennan | Write the postmortem without the assistant; pick the slides tool; rehearse | todo | Evidence tally (Prompt 13.1) is run the evening before so he can start without waiting. |
| 10 Record and submit | 12, 9 | Tue 12-01 | Brennan | Record in Zoom, upload, paste the link; final approvals; submit on Canvas himself | todo | If YouTube is not verified, attach the video to a GitHub release. |

## If time runs short, protect in this order
1. The student-authored items (statements, expectations, findings, interpretation, postmortem).
2. The six figures and both models.
3. The two reports.
4. Extra polish.

## Final gate (Tue 2026-12-01), all must be true
- An independent verifier subagent, given only the repository and the rubric tracker, passes: the fresh-copy test, both number audits empty, and every tracker row "met".
- The recording link opens for a signed-out viewer.
- The README links every deliverable.

## Milestones (course site lists no due dates as of 2026-11-23)

| Milestone | What is submitted | Parts | Our target |
|---|---|---|---|
| 1 Proposal | Three problem statements; shortlist of candidate sources with opened links | 1, 2 | 11-24 |
| 2 Data confirmed | Scorecard with correlation screen; repository address; raw data; provenance record | 2, 3, 4 | 11-24 |
| 3 Data ready | Processed data, codebook, wrangling log, passing validation | 5 | 11-24 |
| 4 Draft findings | Exploration plan with findings, correlation matrix, figures, HTML plan, both models | 6, 7, 8 | 11-29 |
| 5 Final | Repository link: replication package, both reports, recording, postmortem | 9 to 13 | 12-01 |
