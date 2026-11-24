# Assistant drafts (not Brennan's words)

Everything in this file was **written by the AI assistant**. On 2026-11-24 Brennan changed how the writing is done (decision D-024): the assistant gives its own answer for each passage that is his to write, the project is built with those drafts, and he keeps or changes each one at the end, once he can see the finished output.

Rules for this file:

- A draft here is never presented as Brennan's. Nothing moves into `authored/` until he has kept or changed it himself.
- Every number comes from a file in `output/tables/`, named beside the draft.
- The "Status" column is filled in by what Brennan does at his final pass: *kept as drafted*, *changed* (his text then lives in `authored/`), or *dropped*.
- Not in this file, ever: the postmortem's ratings and six answers (the course requires them written without the assistant), and a script for the talk.
- His expectations and expected slope directions are his own picks, made before the analysis ran. They are in `authored/eda_expectations.md` and are not drafts.

Where each draft is used while it waits for him: figure titles in `scripts/06_figures.R` and `scripts/07_models.R`, the model section, and later both reports. Every place is marked "assistant draft" in the source.

## A. "What I found" for the 12 sub-questions

| # | Sub-question | Brennan expected | Assistant's draft of "what I found" | Matched? (assistant's reading) | Table | Status |
|---|---|---|---|---|---|---|
| 1 | Spread of free play per $100 wagered | Two clusters | Free play per $100 wagered sits in one main bunch with a long tail. The median is $3.71 across 919 sportsbook-months, half of them fall between $1.90 and $5.53, and 81 months (8.81%) reach $10 or more, up to $121.84. The only sign of a second group is 122 months (13.28%) under $1. | Partly | eda_01, eda_01b | draft |
| 2 | Share of months with no state tax paid | Under 10% | No state tax was paid in 449 of 923 sportsbook-months (48.65%), almost as many as the 474 months (51.35%) in which something was paid. | No. Almost five times my guess | eda_02 | draft |
| 3 | Share of wagering through the three biggest | 50% to 70% | FanDuel, DraftKings and BetMGM took 77.22% of all dollars wagered (33.48%, 27.46% and 16.29%, 70 months each). The nine smallest of the 15 sportsbooks took 5.70% together. | No. More concentrated than I guessed | eda_03 | draft |
| 4 | Who deducted the most per $100 | Big brands more | The highest medians belong to two smaller tribal sportsbooks, Lac Vieux Desert (Fanatics) at $6.34 over 70 months and Hannahville (Hard Rock Bet) at $5.13 over 66. BetMGM is third at $4.39, while FanDuel ($3.83) and DraftKings ($3.54) sit next to the overall median of $3.71 (70 months each). | Mostly no | eda_04 | draft |
| 5 | Trend from 2021 to 2026 | Rose | The median fell from $5.79 per $100 in 2021 (154 months) to $3.39 in 2023 (175) and $3.09 in 2026 (127). Most of the drop came in the first two years. | No. It fell | eda_05 | draft |
| 6 | Commercial against tribal | Commercial higher | The medians are close: $3.88 for commercial sportsbooks (210 months) and $3.65 for tribal ones (709). Tribal months are far more spread out (middle half $1.60 to $6.15, against $2.90 to $4.70), and the tribal mean is the higher one ($5.32 against $4.73). | Barely. Higher by $0.23 at the median, lower at the mean | eda_06 | draft |
| 7 | Bigger months | More in bigger months | There is almost no straight-line link between size and free play per $100: the correlation is -0.07 across 919 months. Months under $1 million wagered have the lowest median ($2.27, 146 months); the three larger bands are nearly level ($3.67, $3.89 and $3.88). | No, apart from the smallest band | eda_07, eda_07b | draft |
| 8 | No-tax months by type | More common for tribal | Tribal sportsbooks paid no state tax in 404 of 713 months (56.66%), commercial ones in 45 of 210 (21.43%). | Yes | eda_08 | draft |
| 9 | No-tax share over time | Rose | For tribal sportsbooks the share of months with no tax fell from 73.95% in 2021 (88 of 119) to 19.59% in 2026 (19 of 97), with a bump back to 69.03% in 2024. For commercial sportsbooks it swung: 0% in 2022 and 2026, 55.56% in 2024 (20 of 36) and 41.67% in 2025 (15 of 36). 2026 covers January to October. | No. It fell for tribal and swung for commercial | eda_09 | draft |
| 10 | As a sportsbook ages | High at launch, then drops fast | For tribal sportsbooks the median fell from $9.05 per $100 in months 1 to 6 (71 months) to $6.14 in months 7 to 12 (72), $3.97 in the second year (142) and $2.52 after four years (166). For commercial sportsbooks it stayed between $3.36 and $4.15 at every age, but the first two bands hold only 18 months each. | Yes for tribal, no for commercial | eda_10 | draft |
| 11 | Effect of unusual months | Not at all | Leaving out the 21 lump-deduction months and the 15 first months moves the overall median only from $3.71 to $3.65 (888 months left). The mean falls from $5.18 to $4.17 and the 2021 median from $5.79 to $4.66, because 15 of the 21 lump months and 14 of the 15 first months are in 2021. | Partly. Medians hold, means and 2021 do not | eda_11, eda_11c | draft |
| 12 | Most related to free play per $100 | Size of the sportsbook | Among things known before the month starts, free play per $100 is most related to its own value the month before (0.59, 900 months), then to months active (-0.26, 919). Size is near zero (-0.07, 919). Paying no tax is most related to paying none the month before (0.79, 906 months) and to prior-month size (-0.46, 906). | No. Last month, not size | eda_12c | draft |

Rows that differ from what he expected: 2, 3, 4, 5, 7, 9 and 12 clearly; 1, 6, 10 and 11 in part. Only 8 matched outright.

## B. The six findings that become figures (provisional choice, decision D-025)

Each sentence is used as the figure's title. The choice of six and the wording are both the assistant's until Brennan confirms or changes them.

| Figure | Sub-question | Chart form | Draft finding (used as the title) | Status |
|---|---|---|---|---|
| fig01 | 1 | Histogram | Half of all sportsbook-months deducted between $1.90 and $5.53 of free play per $100 wagered; 9% deducted $10 or more | draft |
| fig03 | 3 | Ordered bar chart | Three sportsbooks took 77% of all dollars wagered; the nine smallest took 6% together | draft |
| fig04 | 4 | Box plot per operator | The most free play per $100 came from two smaller tribal sportsbooks, not from FanDuel or DraftKings | draft |
| fig09 | 9 (and 2, 8) | Line chart, one line per type | Tribal sportsbooks paid no state tax in 74% of months in 2021 and 20% in 2026; commercial ones swung between 0% and 56% | draft |
| fig10 | 10 (and 5, 6) | Two panels, one per type | Tribal sportsbooks deducted $9.05 per $100 in their first six months and $2.52 after four years; commercial ones stayed near $4 | draft |
| fig12 | 12 | Heat map | Among things known before the month starts, each target is most closely tied to its own value the month before (0.59 and 0.79) | draft |

## C. Reading of the two models (assistant's draft)

Both models are ordinary linear regressions fitted on every row with the needed values and judged on those same rows. Every sentence below describes association, not cause. Numbers: `output/tables/model1_estimates.csv`, `model2_estimates.csv`, `model_fit.csv`, `model2_classification_table.csv`, `model1_error_summary.csv`, `model_rows_left_out.csv`.

**Model 1: free play per $100 wagered (900 sportsbook-months)**

| Predictor | Brennan expected | Estimate | Assistant's draft sentence | Came out as expected? | Status |
|---|---|---|---|---|---|
| Prior month: free play per $100 | Less this month | 0.4975 | A sportsbook that deducted $1 more of free play per $100 last month tends to deduct about $0.50 more per $100 this month, holding months active and operator type fixed. | No, the other way. Heavy free play carries over from one month to the next; it is not followed by a pullback. | draft |
| Months active | Go up | -0.0323 | Each extra month a sportsbook has been active goes with about 3 cents less free play per $100, or about $0.39 less per year, holding last month's free play and operator type fixed. | No, the other way. This fits the launch pattern in sub-question 10: free play is heaviest early. | draft |
| Commercial operator (against tribal) | Commercial more | 0.1308 | A commercial sportsbook is predicted to deduct $0.13 more per $100 than a tribal one with the same free play last month and the same age. The estimate is small next to its standard error ($0.44, p = 0.76), so the model does not tell the two types apart. | The sign matches, but the gap is too small to count. | draft |

Fit, as drafted: the model accounts for 35.7% of the differences in free play per $100 (R-squared 0.357). Its typical miss is $5.46 per $100, which is large next to a median of $3.71. That figure is driven by a few months: 846 of the 900 predictions (94%) land within $5, while 18 months came in more than $10 above the prediction, the largest by $118.56. 23 rows were left out, 17 because the sportsbook has no prior month in the data and 6 because this month's or last month's free play value is missing.

**Model 2: probability of paying no state tax (906 sportsbook-months, linear probability model)**

| Predictor | Brennan expected | Estimate | Assistant's draft sentence | Came out as expected? | Status |
|---|---|---|---|---|---|
| Prior month: paid no state tax | More likely no tax again | 0.7353 | A sportsbook that paid no state tax last month has a predicted probability of paying none this month that is about 73.5 percentage points higher than one that paid, holding last month's size and operator type fixed. | Yes | draft |
| Prior month: size (log10 of dollars wagered) | Less likely to pay no tax | -0.0771 | Each tenfold increase in the dollars wagered last month goes with a predicted probability about 7.7 percentage points lower, holding last month's tax status and operator type fixed. | Yes | draft |
| Commercial operator (against tribal) | Tribal more likely | -0.0084 | A commercial sportsbook's predicted probability is 0.8 percentage points lower than a tribal one's with the same tax status and size last month. The standard error is 2.9 points (p = 0.77), so the model shows no difference between the types once those two are held fixed. | The sign matches, but the gap is close to zero. The raw gap in sub-question 8 (56.66% against 21.43%) goes with size and with last month's status, not with type itself in this model. | draft |

Fit, as drafted: R-squared is 0.645. Calling 0.5 or more a yes, the model is right for 813 of 906 months (89.7%): 394 no-tax months and 419 tax-paying months. Always guessing the more common outcome, "paid tax", would be right 51.8% of the time. It misses in both directions: 50 months it called no-tax paid tax, and 43 it called tax-paying paid none. Five predictions (0.55%) fall outside 0 to 1, three below 0 and two above 1 (from -0.0023 to 1.171); they are reported as they are. 17 rows were left out because the sportsbook has no prior month in the data.

For both, as drafted: fit was measured on the same rows the models were fitted to, so these numbers are a best case. On new months the models would probably do somewhat worse, and finding out would mean testing them on months they have not seen, which this course leaves to a later one.

## D. Three cases for the scenario predictions (provisional, decision D-026)

Chosen by the assistant so the table could be built; which cases the decision-maker would ask about is Brennan's call. Predictions: `output/tables/model_scenarios.csv`; arithmetic for case 1: `model_scenario_arithmetic.csv`.

| Case | Last month: free play per $100 | Months active | Type | Last month: paid no tax | Last month: dollars wagered | Model 1 predicts | Model 2 predicts | Beyond the data? | Status |
|---|---|---|---|---|---|---|---|---|---|
| 1. Large commercial sportsbook, four years in | $4 | 48 | commercial | no | $100,000,000 | $3.81 per $100 | 0.0278 (pays tax) | No | draft |
| 2. Small tribal sportsbook, five years in | $5 | 60 | tribal | yes | $1,500,000 | $3.78 per $100 | 0.9122 (no tax) | No | draft |
| 3. Tribal sportsbook in its fourth month, heavy free play | $9 | 4 | tribal | yes | $3,000,000 | $7.58 per $100 | 0.8889 (no tax) | No | draft |

## E. Report text (assistant's draft)

Both reports were built on 2026-11-24 with text drafted by the assistant. Each carries a visible notice saying so, which comes off only after Brennan's pass.

| Where | What is drafted | Where Brennan changes it | Status |
|---|---|---|---|
| `report/static/sections/01_summary.tex` | Executive summary (244 words) | That file, or in Overleaf | draft |
| `report/static/sections/02_problem.tex` | The setting, the decision-maker, the three statements (version 2 of `statement_drafts.md`) | That file | draft |
| `report/static/sections/03_data.tex`, `04_preparing.tex` | Data and cleaning, described from the provenance record and wrangling log | Those files | draft |
| `report/static/sections/05_exploration.tex` | What each figure and table shows, with "I expected" taken from his recorded picks | That file | draft |
| `report/static/sections/06_models.tex` | What each slope means, fit, the three cases (sections C and D above) | That file | draft |
| `report/static/sections/07_findings.tex` | Findings and five recommendations | That file | draft |
| `report/static/sections/08_limitations.tex`, `09_next_steps.tex` | Limitations; next steps and the prescriptive statement | Those files | draft |
| `report/static/sections/10_appendices.tex`, Appendix C | AI-use statement: a factual draft from the logs; the last paragraph must say truthfully what he wrote | That file | draft |
| `docs/index.html` | The same content, shorter | The text between the tags; numbers and titles are filled in by script and must not be typed | draft |
| `documentation/figure_titles.csv` | The nine figure titles (sections B and C above). One edit here changes the title in the PDF figures, the report and the page | That file | draft |

How to change wording without breaking a number: in the LaTeX, leave each `\V{...}` where the number belongs; on the page, leave each `<span data-n="..."></span>`. Then run `Rscript scripts/run_all.R`. The audit at the end lists any number that was typed by hand.

Claims the assistant removed from its own draft because no file in the project supports them: that free bets are the main bait in sportsbook advertising; that November and December are busier months; that other states cap the deduction; that tribal compacts set what tribal operators pay; that the Board advises the Legislature.

The three problem statements are in `statement_drafts.md` (version 2).
