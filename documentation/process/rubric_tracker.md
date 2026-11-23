# Rubric tracker

One row per rubric line, per item in the instructions' "Deliverables and submission checklist", and per Checkpoint bullet in Parts 0 to 13. Requirements are quoted from the professor's instructions (`reference/BUAN_314_370_PROJECT_INSTRUCTIONS.html`, not published). **Nothing counts as done without evidence in this table.**

Status values: `todo` · `in progress` · `met` · `at risk`. Owner is who has to make it true.

Last updated: 2026-11-23, end of session 1.


## A. Rubric (project = 100%)

| # | Component | Weight | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|---|---|
| R1 | Problem framing | 10% | "Three statements with all five parts each; the descriptive one is answerable from the data; the predictive one names a numeric and a yes-or-no target; the prescriptive one names a decision. The wording is specific and the student's own." | at risk | documentation/proposal.md section 2 | Brennan (agent drafts and critiques) | Structure nearly there; wording is not Brennan's yet (O-001) |
| R2 | Data source and provenance | 10% | "A primary, documented source that fits the question and meets the size, variable and correlation requirements; a scorecard backed by evidence; a provenance record from which a stranger could obtain the identical file." | in progress | documentation/proposal.md sections 3 to 5; documentation/data_provenance.md | agent (Brennan decides go / no-go) | Gate decided: go (D-016). Raw files not yet downloaded by Brennan |
| R3 | Preparation and codebook | 10% | "Every cleaning step is a recorded decision with a reason and a row count; the accounting closes; the codebook is complete and checked against the data; tests pass." | todo | | agent (Brennan decides each step) | |
| R4 | Exploratory analysis and prototyped visualizations | 15% | "Sub-questions trace to the problem statement; each has an answer with a number and its count; the correlation matrix is built and read correctly; interpretations weigh alternative explanations; six prototyped visualizations meet the standards, map each variable to a plot element that suits its type, and make their intended comparisons easy." | todo | | agent builds; Brennan interprets | |
| R5 | Predictive models | 10% | "Linear regression applied to both sub-specifications, the regression problem and the classification problem (linear probability model), and no other method; predictors justified from the exploration; slopes interpreted in the right units; fit and classification reported plainly, including predictions outside 0 to 1; the limits of judging a model on its own data stated." | todo | | agent fits; Brennan chooses and interprets | |
| R6 | Replication and version control | 10% | "A fresh copy reproduces every output from the README alone; the commit history shows the project being built over time; logs are complete." | todo | | agent | |
| R7 | Static report | 10% | "Written for the decision-maker; organized by question; every number sourced; limitations stated plainly; no code; typeset in LaTeX and compiled in Overleaf." | todo | | Brennan writes; agent typesets; Brennan compiles | |
| R8 | Interactive report | 10% | "One hand-written HTML file with its own CSS and JavaScript that works offline and at a public address; the report's visualizations rebuilt in the page, at least three of them interactive, and an explorer, each interaction used for a reason; numbers and colors consistent with the static report; data written into the page by a script." | todo | | agent (Brennan's wording) | |
| R9 | Presentation | 10% | "Twenty minutes, plus or minus two; a clear line from decision to recommendation; closes with limitations, next steps and a candid discussion of the postmortem; delivered to the camera without reading; the student can explain every choice; slides handed in as a PDF with the prototyped visualizations." | todo | | Brennan (agent makes slides and cue cards) | |
| R10 | Postmortem | 5% | "Every task rated, with a specific moment from the prompt log behind each rating; separates what the assistant did from what the student had to supply or catch; candid about strengths and shortfalls alike; written by the student." | todo | | Brennan only | |

## B. Deliverables and submission checklist

| # | Group | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|---|
| C1 | Framing and data | "Three problem statements (descriptive, predictive, prescriptive) in my own words, in the README and both reports." | todo | | Brennan | |
| C2 | Framing and data | "Viability scorecard with no fails, in documentation/proposal.md." | met | documentation/proposal.md section 5 | agent | 0 fails; 3 concerns |
| C3 | Framing and data | "Data meet the requirements: about 500 observations or more (or the instructor's approval), at least three numeric and two categorical variables." | todo | | agent | |
| C4 | Framing and data | "Provenance record complete, with nothing marked UNVERIFIED." | todo | | agent + Brennan | |
| C5 | Framing and data | "Raw data in data/raw untouched, or a script that downloads them." | todo | | agent | |
| C6 | Framing and data | "Codebook with one row per variable and nothing marked UNDOCUMENTED." | todo | | agent + Brennan | |
| C7 | Framing and data | "Wrangling log whose row accounting adds up; validation script passes." | todo | | agent | |
| C8 | Analysis, figures and models | "Exploration plan with 'what I expect' and 'what I found' filled in for every sub-question." | todo | | Brennan | |
| C9 | Analysis, figures and models | "Correlation matrix as a table and a heat map, showing at least weak to moderate correlation with each target." | todo | | agent | |
| C10 | Analysis, figures and models | "At least six prototyped visualizations in four or more chart forms, made by scripts, meeting the figure standards, and used in both the LaTeX report and the slides." | todo | | agent | |
| C11 | Analysis, figures and models | "The HTML report shows the same visualizations as the static report, rebuilt in CSS and JavaScript, with at least three interactive." | todo | | agent | |
| C12 | Analysis, figures and models | "One explorer in the HTML report: two or more controls that change a chart and a summary." | todo | | agent | |
| C13 | Analysis, figures and models | "Two linear regression models, one for the regression problem (numeric target) and one for the classification problem (yes-or-no target, linear probability model), each with its equation, interpretation, fit, figures and scenario predictions." | todo | | agent + Brennan | |
| C14 | Reproducibility | "Public GitHub repository with commits spread across the project." | todo | | agent | |
| C15 | Reproducibility | "README with links to every deliverable, run instructions, script table and AI-use statement." | todo | | agent | |
| C16 | Reproducibility | "Fresh-copy test passed: the master script regenerates every output." | todo | | agent | |
| C17 | Reproducibility | "Prompt log covering every part, including each loop back from Part 2." | todo | | agent | |
| C18 | Reproducibility | "Postmortem in documentation/postmortem.md: all fifteen tasks rated with evidence, six answers in my own words, linked from the README." | todo | | Brennan | |
| C19 | The three deliverables | "Static report: PDF compiled from LaTeX in Overleaf, saved in report/, no code, number audit clean." | todo | | agent + Brennan | |
| C20 | The three deliverables | "Interactive report: one hand-written HTML file with its own CSS and JavaScript, works offline, live on GitHub Pages." | todo | | agent | |
| C21 | The three deliverables | "Presentation: 20 minutes, plus or minus two (18 to 22), slides and camera both visible, ends with the postmortem discussion, link works when signed out." | todo | | Brennan | |
| C22 | The three deliverables | "Slides saved as PDF in presentation/, including the prototyped visualizations." | todo | | agent + Brennan | |

## C. Checkpoints, Parts 0 to 13


### Part 0. Tools and accounts

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P0.1 | "The table from Prompt 0.1 shows every item installed." | met | Re-check 2026-11-23: git 2.54.0, R 4.6.1, RStudio 2026.09.0; in the project library: renv 1.3.1, tidyverse 2.0.0, janitor 2.2.1, plotly 4.12.1 (scratch install log; prompt log 2 and 4) | agent | Packages live in the project's renv library, not the global library (D-007) |
| P0.2 | "You can sign in to GitHub and to Overleaf in a browser, and both email addresses are confirmed." | in progress | GitHub: signed in as BrennanKM, repository created. Overleaf: account created, per Brennan 2026-11-23 | Brennan | Still to confirm: the Overleaf email address is confirmed |
| P0.3 | "You have opened Claude Code on an empty test folder, asked it to create a text file, and found that file on your computer." | in progress | Claude Code created this repository's files on 2026-11-23 | Brennan | Brennan to confirm he can find README.md on his computer |

### Part 1. Frame the problem: one question, three problem statements

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P1.1 | "Each statement names all five parts. The outcome measure has units." | in progress | documentation/proposal.md section 2, five-part check | agent | Working drafts: two Value cells are empty |
| P1.2 | "The descriptive statement can be answered with summaries and charts alone." | in progress | documentation/proposal.md section 2 | agent | Working draft only |
| P1.3 | "The predictive statement has both sub-specifications, a regression problem (numeric target) and a classification problem (yes-or-no target), and names the moment of prediction. The prescriptive statement names a decision, an objective and a constraint." | in progress | documentation/proposal.md section 2; targets D-014, D-015 | agent | Working draft only; the prescriptive draft does not say who controls the cap |
| P1.4 | "All three are about the same decision-maker and could use the same data." | in progress | documentation/proposal.md section 2 | agent | Same decision-maker and data in all three drafts |
| P1.5 | "You can say the descriptive statement aloud in 20 seconds, and a classmate can tell you what one row of the ideal data set is." | todo |  | Brennan |  |
| P1.6 | "The final wording is yours." | at risk | questions_log Q-018 to Q-020 | Brennan | The three statements are the assistant's draft A, selected unchanged. Brennan's rewrite is owed (O-001) |

### Part 2. Find a viable data source

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P2.1 | "The scorecard has no fails, and each concern has a stated resolution." | met | documentation/proposal.md section 5: 8 pass, 3 concern, 0 fail; each concern has a resolution | agent | License stays a concern with nothing in writing (D-016) |
| P2.2 | "You downloaded the file yourself and can state from memory: what one row is, the period covered, and the number of rows and columns." | at risk |  | Brennan | Brennan has not downloaded a file yet (O-002) |
| P2.3 | "The data have about 500 observations or more, or you have the instructor's approval, with at least three numeric and at least two categorical variables." | in progress | documentation/proposal.md section 4: 923 active rows, 4 numeric, 5 categorical | agent | From screening copies; to be confirmed on the hand-downloaded files |
| P2.4 | "The correlation matrix shows at least weak to moderate correlation with each of your two targets." | in progress | documentation/proposal.md section 4: r = 0.59 and r = -0.46 with the two targets | agent | From screening copies; to be confirmed on the hand-downloaded files |
| P2.5 | "Your three problem statements have been revised to match what the data contain." | in progress | documentation/proposal.md sections 1, 2 and 6 | agent | Drafts match the data; wording not yet Brennan's |
| P2.6 | "The statements and the scorecard are saved as your proposal (Milestone 1)." | in progress | documentation/proposal.md | agent | Milestone 1 not final until O-001, O-002 and O-004 are closed |

### Part 3. Set up the workspace and GitHub

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P3.1 | "Your repository opens in a browser and shows the README and the folder layout." | met | https://github.com/BrennanKM/buan314-370-project-martin (public; commit ffdf9cc pushed 2026-11-23) | agent |  |
| P3.2 | "CLAUDE.md is in the project folder, and after your next prompt the prompt log gained an entry without your asking." | met | CLAUDE.md; documentation/prompt_log.md entries 1 to 20 written as the work happened | agent |  |
| P3.3 | "Your proposal from Parts 1 and 2 is in documentation/proposal.md." | in progress | documentation/proposal.md | agent | In place, not final |
| P3.4 | "From now on the commit history shows work arriving session by session. One upload at the end is not version control." | in progress | git log: commits on 2026-11-23 | agent | Must continue every working session to 12-01 |

### Part 4. Collect the data and record its provenance

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P4.1 | "A person with only your repository can obtain the same raw file you have, and the checksum proves it is the same." | todo |  | agent |  |
| P4.2 | "The provenance record has no field marked UNVERIFIED. You resolved each one yourself." | todo |  | Brennan |  |
| P4.3 | "Row and column counts match the publisher's, or the record explains the difference." | todo |  | agent |  |
| P4.4 | "If you joined tables, the row count after the join equals the count you predicted." | todo |  | agent |  |

### Part 5. Clean the data and build the codebook

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P5.1 | "The row accounting closes: raw rows, less rows removed step by step, equals processed rows." | todo |  | agent |  |
| P5.2 | "Every variable in the processed file has a codebook row, and no label reads UNDOCUMENTED." | todo |  | agent |  |
| P5.3 | "The validation script passes." | todo |  | agent |  |
| P5.4 | "You can give the reason for each row of the wrangling log without looking at it." | todo |  | Brennan |  |

### Part 6. Explore

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P6.1 | "Every sub-question in the plan has an answer with a number and the count behind it." | todo |  | agent |  |
| P6.2 | "The 'what I found' column is in your words, and at least one row differs from 'what I expect,' or you can say why none does." | todo |  | Brennan |  |
| P6.3 | "The correlation matrix is saved as a table and a heat map, and you can name the two or three variables most strongly related to each target." | todo |  | Brennan |  |
| P6.4 | "You have picked the five or six findings that matter most to the decision-maker. These become your figures." | todo |  | Brennan |  |

### Part 7. Visualize: prototype the figures, plan the HTML versions

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P7.1 | "Six prototyped visualizations are saved by a script, each tied to a sub-question in your plan." | todo |  | agent |  |
| P7.2 | "Every figure meets the standards, and you have checked each one against its summary table." | todo |  | agent |  |
| P7.3 | "For every figure you can answer the four mapping questions and defend each choice." | todo |  | Brennan |  |
| P7.4 | "The plan lists every report figure with its HTML version, marks at least three as interactive with a reason for each, and describes the explorer." | todo |  | agent |  |
| P7.5 | "For each figure you can say in one sentence what the reader should take from it." | todo |  | Brennan |  |

### Part 8. Predict: linear regression and the linear probability model

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P8.1 | "Both models are fitted by the modeling script, and their estimates, equations, fit measures and figures are saved." | todo |  | agent |  |
| P8.2 | "Before fitting, you wrote the direction you expected for each slope, and you can explain any that came out the other way." | todo |  | Brennan |  |
| P8.3 | "The predictions worked out from the equations match the script's." | todo |  | agent |  |
| P8.4 | "For the yes-or-no model you have reported the share of predictions outside 0 to 1, and the share classified correctly next to the always-guess-the-majority share." | todo |  | agent |  |
| P8.5 | "Three scenario predictions are saved, with any that reach beyond the data flagged." | todo |  | agent |  |
| P8.6 | "The interpretation is in your words, speaks of association, and says that fit was measured on the rows used to fit." | todo |  | Brennan |  |

### Part 9. Build the replication package

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P9.1 | "The fresh copy runs from start to finish with no edits, and every output matches." | todo |  | agent |  |
| P9.2 | "A classmate can follow your README without asking you a question. Try it with one." | todo |  | Brennan |  |
| P9.3 | "The repository contains no passwords, keys or personal data, and no file GitHub will reject." | todo |  | agent |  |

### Part 10. Static report in Overleaf

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P10.1 | "The report compiles in Overleaf with no errors, and the PDF is in your repository." | todo |  | agent |  |
| P10.2 | "Every figure and table is numbered, captioned and discussed in the text." | todo |  | agent |  |
| P10.3 | "The number audit returns two empty lists." | todo |  | agent |  |
| P10.4 | "There is no code in the report, and the interpretation is in your words." | todo |  | Brennan |  |

### Part 11. Interactive HTML report

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P11.1 | "The report is one HTML file. Copied alone to another folder, with the internet off, it opens and every figure works." | todo |  | agent |  |
| P11.2 | "Every figure in the static report appears in the page, drawn by its own CSS and JavaScript, and matches its prototype." | todo |  | agent |  |
| P11.3 | "At least three figures are interactive, the explorer responds, and the values you read off match the processed data." | todo |  | agent |  |
| P11.4 | "The findings match the static report, number for number, and the page shows no analysis code." | todo |  | agent |  |
| P11.5 | "The page opens from its public address in a private browser window and on a phone." | todo |  | agent |  |
| P11.6 | "Rerunning the master script rebuilds the data inside the page." | todo |  | agent |  |

### Part 12. Recorded presentation

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P12.1 | "The recording runs between 18 and 22 minutes, with slides and your camera image visible for the whole of it." | todo |  | Brennan |  |
| P12.2 | "The closing segment covers your recommendation, the limitations, the next steps and your postmortem." | todo |  | Brennan |  |
| P12.3 | "The link opens for someone who is not signed in to your account." | todo |  | Brennan |  |
| P12.4 | "Every number you say aloud matches the report." | todo |  | Brennan |  |

### Part 13. Postmortem: the AI assistant as a partner

| # | Requirement (quoted) | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| P13.1 | "All fifteen tasks are rated, and every rating points to a specific moment in the prompt log." | todo |  | Brennan |  |
| P13.2 | "The ratings are not all the same. At least one task is rated a strong partner and at least one left more to be desired, or you explain why not." | todo |  | Brennan |  |
| P13.3 | "Every row says what you supplied or caught." | todo |  | Brennan |  |
| P13.4 | "The six answers are in your words, written without the assistant." | todo |  | Brennan |  |
| P13.5 | "documentation/postmortem.md is committed, pushed and linked from the top of your README." | todo |  | agent |  |
| P13.6 | "Your presentation ends with a discussion of it." | todo |  | Brennan |  |

## D. Non-negotiables that cost points if missed late

| # | Requirement | Status | Evidence | Owner | Notes |
|---|---|---|---|---|---|
| N1 | Commits pushed in every working session, from 2026-11-23 to 2026-12-01 | in progress | 4 commits pushed 2026-11-23 | agent |  |
| N2 | Prompt log covers every part, including each loop back from Part 2 | in progress | documentation/prompt_log.md entries 1 to 20, including three loops (16 to 18) | agent |  |
| N3 | Fresh-copy test passed | todo | | agent | |
| N4 | Both number audits (static report, HTML page) return empty lists | todo | | agent | |
| N5 | Recording length between 18 and 22 minutes | todo | | Brennan | |
| N6 | Recording link opens for a signed-out viewer | todo | | Brennan | |
| N7 | README links every deliverable | todo | | agent | |
| N8 | AI-use statement in both reports and the README | todo | | agent + Brennan | |
