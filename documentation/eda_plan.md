# Exploration plan

Sub-questions that together answer the descriptive problem statement (course Prompt 6.1). The assistant proposed them; Brennan edits the list. **"What I expect" is Brennan's and is written before any analysis runs. "What I found" is Brennan's and is written after the tables exist.** No analysis has been run for this plan.

Descriptive statement the plan serves (still the assistant's working draft, see `proposal.md` section 2): "The Michigan Gaming Control Board needs to see how much free play the state's online sportsbooks deducted for every $100 wagered, and how often a sportsbook paid no state tax in a month, across the 15 licensed operators, commercial and tribal, month by month from January 2021 to October 2026, to learn which sportsbooks lean hardest on free-bet promotions and whether that reliance is fading."

Data: `data/processed/mgcb_operator_months.csv`, 923 rows; one row is one licensed operator in one month. Variable names are those in `codebook.md`.

Honest note on timing: before this plan existed, the Part 2 data gate required a correlation screen, and a few screening numbers on the uncleaned data were shown to Brennan (`process/interview.md`, section 4): the correlations with the two targets, the median free play per $100 and share kept by year, and the median share kept by operator type. His expectations below were written after seeing those and before any table in this plan was computed.

| # | Sub-question | Part of the problem statement it serves | Variables involved | Summary or comparison that answers it | Chart form | What I expect (Brennan, before) | What I found (Brennan, after) | Table |
|---|---|---|---|---|---|---|---|---|
| 1 | How is free play per $100 wagered spread across all sportsbook-months? | "how much free play [...] deducted for every $100 wagered" | `free_play_per_100` | Count, median, quartiles, minimum, maximum; share of months above $5 and above $10 per $100; count of missing | Histogram | | | |
| 2 | In what share of sportsbook-months was no state tax paid? | "how often a sportsbook paid no state tax in a month" | `paid_no_tax` | Count and share of yes and no | Bar chart of counts | | | |
| 3 | How large are the sportsbooks, and how much of all wagering goes through the biggest ones? | "across the 15 licensed operators" | `handle`, `operator_short` | Median monthly handle per operator with its count of months; each operator's share of all dollars wagered | Ordered bar chart | | | |
| 4 | Which operators deducted the most free play per $100 wagered, and which the least? | "which sportsbooks lean hardest on free-bet promotions" | `free_play_per_100`, `operator_short` | Median and quartiles per operator, with the count of months behind each | Box plot per operator, ordered by median | | | |
| 5 | Did free play per $100 wagered fall, hold or rise from 2021 to 2026? | "month by month from January 2021 to October 2026"; "whether that reliance is fading" | `free_play_per_100`, `year`, `month_date` | Median per year with counts; median per month across operators | Line chart over time | | | |
| 6 | Is free play per $100 wagered different for commercial and tribal operators? | "commercial and tribal" | `free_play_per_100`, `operator_type` | Median and quartiles per operator type, with counts | Box plot, two groups | | | |
| 7 | Do bigger months of wagering go with more or less free play per $100? | "how much free play [...] for every $100 wagered" (a possible driver) | `free_play_per_100`, `log10_handle` | Correlation with the count of rows; median free play per $100 within four size bands | Scatter plot with a smoother | | | |
| 8 | Is paying no state tax more common among tribal or commercial operators? | "how often a sportsbook paid no state tax"; "commercial and tribal" | `paid_no_tax`, `operator_type` | Two-by-two table of counts with the share of no-tax months in each type | Stacked bar chart, one bar per type | | | |
| 9 | Did the share of sportsbooks paying no tax change from year to year, and did it change the same way for both operator types? | "how often [...] paid no state tax"; "whether that reliance is fading"; "commercial and tribal" | `paid_no_tax`, `year`, `operator_type` | Share of no-tax months per year within each operator type, with counts; groups under 30 flagged | Line chart, one line per type | | | |
| 10 | Does a sportsbook's free play per $100 change as it gets older, and is that true for both operator types? | "whether that reliance is fading" (is it a launch-period cost?) | `free_play_per_100`, `months_active`, `operator_type` | Median free play per $100 by band of months active (1 to 6, 7 to 12, 13 to 24, 25 to 48, 49 or more) within each type, with counts | Line or point chart in two panels, one per type | | | |
| 11 | How much do the unusual months move the answers? | All of it (can the answers be trusted) | `lump_deduction`, `first_active_month`, missing values of `free_play_per_100` | The summaries for sub-questions 1, 4 and 5 recomputed without the 21 lump-deduction months and without the 15 first months, side by side with the originals; where the missing values sit | Table (dot plot of with against without if it helps) | | | |
| 12 | Which variables move together, and which are most related to the two targets? | Starting point for the predictive statement | Every numeric variable, `paid_no_tax` and the other 0 and 1 variables | Correlation matrix with the number of rows used; pairs at 0.2 or more in absolute value, strongest first | Heat map with the value in each cell | | | |

## Coverage check

| Required by the course | Sub-questions |
|---|---|
| One variable at a time | 1, 2, 3 |
| Two at a time: number by number | 7 |
| Two at a time: number by category | 4, 6 |
| Two at a time: category by category | 8 |
| Three at a time (within groups) | 9, 10 |
| Time | 5, 9 |
| Missing and unusual values | 11 |
| Correlation matrix, table and heat map | 12 |

Chart forms planned: histogram, bar, box plot, line, scatter, stacked bar, paneled chart, heat map (the course asks for six figures in at least four forms, two of them showing three or more variables: 9, 10 and 12 qualify).
