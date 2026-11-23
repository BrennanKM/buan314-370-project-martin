# Decision log

Anything that changes the data, the question, the targets or a figure, and any choice about how the project is run. "Provisional (agent)" marks a reversible call made while Brennan was unavailable; he confirms or reverses it later.

| ID | Date | Decision | Options considered | Evidence | Decided by |
|---|---|---|---|---|---|
| D-001 | 2026-11-23 | The project language is R for all data work, models and figures. | R; Python | Master prompt, section 1.3; R 4.6.1 and tidyverse already installed | Brennan |
| D-002 | 2026-11-23 | Authoring model: the assistant drafts or offers options, Brennan rewrites in his own words, the assistant lists problems only, Brennan revises. The postmortem is written by Brennan alone. | Assistant writes; Brennan writes from scratch; draft then rewrite | Master prompt, section 1.1 | Brennan |
| D-003 | 2026-11-23 | Whole project finished by Tue 2026-12-01. | Later finish | Master prompt, sections 2 and 7 | Brennan |
| D-004 | 2026-11-23 | The master prompt as Brennan sent it (26,832 bytes, with the Isolation section) is the authoritative version, not the older copy in the kickoff folder (24,486 bytes, without it). | Use kickoff copy; use sent copy | File comparison: the two differ only by the added section | agent |
| D-005 | 2026-11-23 | Requirements are read from the professor's HTML file (converted to plain text on this computer), not from the condensed summary or the separate text copy. | Summary; text copy; HTML | Master prompt, section 2: "If the two disagree, the HTML wins" | agent |
| D-006 | 2026-11-23 | Guardrail file `.claude/settings.json` denies file reads and edits under two outside folders and denies force-pushes. It is a backstop, not a sandbox. | No guardrail; deny rules | Master prompt, section 0; rules tested and refused as expected | Brennan (asked for it), agent (wrote it) |
| D-007 | 2026-11-23 | R packages are installed only in this project's renv library, with renv's shared cache turned off so nothing is written outside the project folder. | Global install; renv with shared cache; renv with cache off | Q-001; master prompt section 0 | Brennan (project-only), agent (cache off) |
| D-008 | 2026-11-23 | The repository is public from day one. Commits in this repository use the GitHub no-reply email address. | Public now; private first; not yet. Personal or no-reply email | Q-002 | Brennan |
| D-009 | 2026-11-23 | The master prompt is published with personal details replaced by visible "[redacted: ...]" markers. The full original is kept in `reference/` and is not published. | Redacted copy; word for word; keep private | Q-003 | Brennan |
