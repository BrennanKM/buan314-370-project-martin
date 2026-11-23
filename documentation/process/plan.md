# Project plan

Target: everything finished and checked by **Tue 2026-12-01**. Dates are targets. If one slips, the fallback in the last column applies and Brennan is told the same day.

Last updated: 2026-11-23 (session 1).

| Phase | Course parts | Target date | Owner | Brennan needed for | Status | Fallback if it slips |
|---|---|---|---|---|---|---|
| 0 Setup | 0, 3 | Mon 11-23 | agent | Approve the GitHub repository; Overleaf, Zoom and YouTube account status; approve package installs | in progress | Work continues locally with commits; the repository is created the moment he approves. YouTube verification is started first because it can take time; a GitHub release is the backup host for the video. |
| 1 Interview and framing | 1 | Mon 11-23 | Brennan + agent | Interview answers; choose topic and decision-maker; rewrite the three statements; fix what Prompt 1.4 lists | todo | If the statements are not final by Tue 11-24 noon, the data gate runs on the draft statements and the final wording follows the scorecard (the instructions expect a revision after Part 2 anyway). |
| 2 Data gate | 2 | Mon 11-23 to Tue 11-24 | agent, Brennan decides | Go / rescope / no-go on the scorecard; download one file himself. **Milestone 1** | todo | One fail on the scorecard: loop back using the instructions' Part 2 table, log three lines, and test the pre-screened alternative source the same day. Two failed loops: ask Dr. Levkoff (Brennan sends). |
| 3 Collect and provenance | 4 | Tue 11-24 | agent | Settle anything UNVERIFIED. **Milestone 2** | todo | If the scripted download is blocked, record the manual click steps and checksums; this still passes. |
| 4 Clean and codebook | 5 | Tue 11-24 | agent, Brennan decides | "My decision" on every cleaning step; labels marked UNDOCUMENTED. **Milestone 3** | todo | Steps without a decision are not carried out. Rows are kept and values marked missing only where he has approved it; the rest wait in `open_questions.md`. |
| 5 Exploration plan | 6 (plan), 8.1 | Tue 11-24 | Brennan + agent | Edit sub-questions; write "what I expect" for each; choose predictors and expected slope directions | todo | No analysis runs on a sub-question or model until its expectation is written. Unanswered rows wait; tables for answered rows proceed. |
| 6 Autonomous build | 6, 7, 8, 9, 11 (build) | Wed 11-25 to Sat 11-28 | agent | Nothing; questions are queued | todo | Order of protection: exploration tables and correlation matrix, six figure prototypes, both models, master script and renv, then the HTML and LaTeX skeletons. |
| 7 Interpretation | 6, 7, 8 (his words) | Sat 11-28 to Sun 11-29 | Brennan | "What I found"; top five or six findings; model interpretation; three scenario cases. **Milestone 4** | todo | If time is short he writes the findings for the six figures first; remaining sub-questions get one sentence each. |
| 8 Reports | 10, 11 | Sun 11-29 to Mon 11-30 | Brennan writes, agent typesets | Report text; Overleaf upload and compile; GitHub Pages approval | todo | LaTeX and HTML skeletons are built in phase 6 with placeholders, so only his text and the audits remain. |
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
