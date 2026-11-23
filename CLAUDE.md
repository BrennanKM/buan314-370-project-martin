# Project rules

This is Brennan Martin's BUAN 314-370 course project (Dr. Levkoff, University of San Diego, Fall 2026): an exploratory data analysis that must be fully reproducible. Brennan is the analyst and decision-maker. You write and run the code. He is not a programmer, so explain what you did in plain English.

Read these at the start of every session, in this order:
1. This file.
2. `documentation/process/plan.md` (where the project is) and `documentation/process/session_log.md` (last session's open items).
3. `documentation/process/rubric_tracker.md` (what is graded and what is still open).
4. `documentation/process/master_prompt.md` (the full standing brief, if you need detail).
5. `reference/BUAN_314_370_PROJECT_INSTRUCTIONS.html` is the professor's file and the source of truth for requirements. It is gitignored; never publish it.

Target: everything finished by Tue 2026-12-01, at A level.

## Tools
- Language: R for all data work, analysis, models and figures. Do not switch languages.
- Visualizations are prototyped with any plotting library in R. The finished versions are saved by the numbered scripts, and those files are the ones used in the LaTeX report and in the slides. Quick trials go in `scratch/`.
- The HTML report shows the same visualizations, rebuilt in its own CSS and JavaScript. Do not paste image files into it.
- The static report is LaTeX, compiled in Overleaf. It contains no code.
- The interactive report is one hand-written HTML file (`docs/index.html`) with its CSS and JavaScript inside it. No page generators, no notebooks exported to HTML, no libraries, fonts or images loaded from the web. Its data are written in by a script.
- Use paths relative to the project folder. Set a seed wherever anything is random.
- R packages go into this project's `renv` library only. Never install into or update the global R library.

## Data
- Never change, rename or delete anything in `data/raw`.
- Every change to the data happens in a numbered script in `scripts/`, never by hand and never in a one-off command.
- Never drop rows, drop columns, fill in missing values or recode categories unless Brennan has approved that specific step.
- Never fabricate. No invented data, addresses, row counts, licenses, quotes, citations or results. Every number in a deliverable must trace to a file in `output/` or to the wrangling log. If something cannot be verified, write `UNVERIFIED` (provenance) or `UNDOCUMENTED` (codebook) and raise it.

## Documentation (do this without being asked)
- After any step that changes rows or columns, add a row to `documentation/wrangling_log.md`: step number, what changed, why, rows before, rows after, script name.
- Whenever a variable is created, renamed or recoded, update `documentation/codebook.md`.
- After each prompt, add an entry to `documentation/prompt_log.md`: date and time, source (Brennan / Lead agent / Course card), the prompt as written (or a link to it), a one-line summary of what you did, the files you changed, and the first-try result (checkpoint passed or failed, what was caught and by whom). Never backfill or reconstruct entries.
- Each loop back from the Part 2 data gate is logged as three lines: what was tried, why it failed, what changed.
- Take variable definitions from the source's data dictionary. If something is undocumented, write UNDOCUMENTED. Do not guess.
- Anything that changes the data, the question, the targets or a figure goes in `documentation/process/decision_log.md` with who decided.
- Every question put to Brennan and his answer, verbatim, goes in `documentation/process/questions_log.md`.
- Every subagent prompt is saved verbatim in `documentation/process/agent_prompts/NNN_<phase>_<task>.md` before launch, in the course format (Context / Ask / Constraints / Verify), with a one-line result added after.
- Keep `documentation/process/rubric_tracker.md` current. Nothing counts as done without evidence in that table.

## Models
- Models are ordinary linear regressions only, fitted on all rows of the processed data. That includes the classification problem, which uses a linear probability model. Do not use any other kind of model. Do not split the data or choose variables automatically.
- Predictors must be known at the moment of prediction named in the predictive statement. No variable that is another version of the target.
- Do not trim, round or cap predicted probabilities. Keep the cutoff at 0.5.

## Results
- Report numbers and where you saved them. Give the count behind every average and percentage. Flag any group with fewer than 30 rows.
- Do not interpret findings or write conclusions for Brennan unless he asks.
- Checkpoints are acceptance tests: write the expected number first, then run, then compare. Never explain a failed checkpoint away.

## Brennan's own words stay his
The rubric grades these as the student's work. You may offer drafts, options, outlines and evidence. The final text must be Brennan's, collected through a question or a file he writes, saved in `authored/`, and used verbatim. Never polish his wording. Mark anything unclear with a comment and let him fix it. Critique by listing problems only (course Prompts 1.4, 6.3, 8.5, 13.2); never rewrite.
- The three final problem statements.
- "What I expect" in the EDA plan (written before any analysis runs) and "what I found".
- The expected direction of each model slope (written before fitting) and the model interpretation.
- Findings, recommendations and limitations in both reports.
- The postmortem: ratings and six answers. The six answers are written without the assistant open. You tally evidence (Prompt 13.1) and list problems (Prompt 13.2). You never draft postmortem text.
- The presentation. You make slides and cue cards (at most four words per cue). You never write a script.

## When to ask Brennan
Ask only for: decisions that are his (topic, decision-maker, targets, cleaning choices, predictors, which findings matter, the slides tool); his own words; approvals listed under Git and safety; manual steps only he can do (Overleaf, Zoom, YouTube, the manual download check). Everything else: decide, log it, move on.
- Batch up to four questions. Each stands on its own. Put the recommended option first.
- If he does not answer, queue the question in `documentation/process/open_questions.md`, keep doing every unblocked task, and for anything reversible take the most reasonable reading and log it as "provisional (agent)". Never make a provisional call on his own words, on cleaning steps that drop data, or on anything public.

## Git and safety
- Ask before installing software system-wide, deleting any file outside `scratch/`, or creating or publishing anything on GitHub.
- No passwords, keys or personal information in any file. This repository is public.
- When a step is finished and checked, commit with a message that says what changed and why, in a sentence a classmate would understand. Push at least at the end of every session. Never rewrite history. Never force-push.
- Never email or message anyone (draft only). Never submit anything to Canvas. Brennan sends and submits.

## Stay inside this project
- Work only in this folder, its own git worktrees, and one temporary folder for the fresh-copy test.
- Never read, write, search or run anything in other folders on this computer. `.claude/settings.json` denies file reads and edits in the two folders that hold Brennan's other projects, and denies force-pushes. That file is a backstop, not a sandbox.
- The only remote is `github.com/BrennanKM/buan314-370-project-martin`.
- No changes to global git config, global R packages, shell profiles or other dotfiles.
- A local preview server, if needed, uses port 8314 only. Stop it before the session ends. Never touch a process you did not start.
- Subagents that edit files work in their own worktree and branch. Merge to `main` only after the checkpoint passes and the diff is reviewed.

## End of every session (course Prompt 3.3)
List every file changed since the last commit. Check that the wrangling log, codebook and prompt log reflect the session's work. Commit and push. Update the session log, rubric tracker and plan. Give Brennan a short status: what is done, what he owes, the first step next time, and a five-sentence plain-English explanation of each phase finished (with rows before and after where data changed).
