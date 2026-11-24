# Alternative explanations for the six findings

Course Prompt 6.3, run on 2026-11-24 by the AI assistant. The prompt is meant to challenge Brennan's own interpretation. Under decision D-024 the six findings are still the assistant's drafts (`process/assistant_drafts.md`, section B), so this list challenges those drafts; it is run again on his wording if he changes it. For each finding: the three strongest other explanations for the pattern and one check on this data that would tell them apart. **No check has been run.** They are run only if Brennan asks.

| Finding (draft) | Another explanation | Kind | A check on this data that would tell them apart |
|---|---|---|---|
| **1.** Half of all months deducted $1.90 to $5.53 per $100; 9% deducted $10 or more | The months at $10 or more are late claims of earlier free play, not heavy promotion in that month (21 months are flagged as lump deductions) | A few extreme values | Recompute the share at $10 or more without the 21 flagged months |
| | Very small months produce extreme ratios in both directions: under $1 million wagered the median is $2.27 but the mean is $7.18 | Small groups, small denominators | Share at $10 or more within each of the four size bands of eda_07b |
| | The measure is the deduction claimed for tax in a month (gross receipts minus adjusted gross receipts), which need not equal the free bets handed to bettors that month | How the variable was measured | Compare each operator's 12-month total deduction per $100 with its monthly values; if the yearly figures are much steadier, timing of claims is at work |
| **3.** Three sportsbooks took 77% of all dollars wagered | Shares are added over the whole period, and four operators have only 37 to 40 months of wagering, so part of their small share is fewer months | How rows came to be in the data | Shares computed only over months in which all 15 operators took wagers, or median monthly dollars wagered (already in eda_03) |
| | The brand named is the latest platform; some licenses changed brand, so "FanDuel" or "Fanatics" stands for a license, not one brand's whole history | How the variable was measured | Shares by `platform_as_listed` instead of `platform_latest` |
| | The publisher does not define "Total Handle". If it counts free-bet stakes, heavy promoters' dollars wagered are overstated | How the variable was measured | Cannot be settled from this data; needs the Board's definition |
| **4.** The most free play per $100 came from two smaller tribal sportsbooks, not FanDuel or DraftKings | A median of monthly ratios treats a $1 million month like a $100 million month; small operators' ratios swing widely (Pokagon Band's middle half is $0.05 to $11.35) | Small denominators | Total deductions divided by total dollars wagered for each operator, next to the median |
| | Lump-deduction months lift some operators: without them Hannahville's median falls from $5.13 to $4.50 (eda_11) | A few extreme values | Order of operators without the 21 flagged months |
| | A third variable, a relaunch under a new brand, may bring a second round of launch promotions for some licenses | Third variable | Median by operator before and after the month `platform_as_listed` changes |
| **9.** Tribal sportsbooks paid no tax in 74% of months in 2021 and 20% in 2026 | Which tribal operators are in the data changes: tribal rows fall from 141 in 2022 to 97 in 2026 as some paused | How rows came to be in the data | The same share for only the operators with wagering in all six years |
| | Size is related to paying no tax (-0.44), and operators grew, so the fall may be growth, not a change in behavior at a given size | Third variable | Share with no tax by year within each size band |
| | 2026 stops in October, and November and December are heavy betting months; a part year is not like a full one | How rows came to be in the data | Shares for January to October only, in every year |
| **10.** Tribal sportsbooks deducted $9.05 per $100 in their first six months and $2.52 after four years; commercial stayed near $4 | Most operators launched in January 2021, so "first six months" is nearly the same thing as "early 2021"; a market-wide launch period would look the same as an age effect | Third variable (calendar time) | The same medians for the operators whose wagering started later (those with 37 to 40 months) |
| | 15 of the 21 lump-deduction months and 14 of the 15 first months fall in 2021, inside the early bands | A few extreme values | The table without the flagged months |
| | The later bands hold only the months of operators that kept taking wagers; the two early commercial bands rest on 18 months each | How rows came to be in the data; small groups | Each operator's own path (one line per operator) instead of pooled medians |
| **12.** Each target is most closely tied to its own value the month before (0.59 and 0.79) | Lasting differences between operators, not month-to-month carry-over: an operator that is always high is high in both months | Third variable (the operator) | The correlation computed within each operator |
| | A few very large values drive a straight-line correlation: the lump-deduction flag alone correlates 0.76 with the target and 0.50 with the prior month | A few extreme values | The correlation without flagged months, and the rank correlation |
| | Both months share the same downward drift over the years | Third variable (calendar time) | The correlation within each year |

## Words in the draft findings that claim more than the tables show

- "took" (figure 3) and "came from" (figure 4) describe shares and medians; they are fine. Neither table says why.
- "swung" (figure 9) is a description of the six yearly values for 30 to 36 commercial months a year, not evidence of a cause.
- "tied to" (figure 12) means correlated. It does not mean last month's free play causes this month's.
- No draft finding uses "because", "causes" or "leads to". The words "launch" and "settled" in the draft for sub-question 10 lean toward an age explanation that the first check under finding 10 could contradict.

## The course's "Think about it" for Part 6 (left for Brennan)

The data describe what happened. One thing the Board would want to conclude that description alone cannot support, and what kind of data or study could: this is Brennan's to answer.
