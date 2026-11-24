# Problem statements: assistant drafts (course Prompt 1.3)

**These are drafts written by the AI assistant, not Brennan's statements.** The final wording is Brennan's and lives in `authored/problem_statements.md`. The drafts are kept so the record shows what he started from and what he changed.

Research question: how much do Michigan's online sportsbooks rely on promotional free play, and what does that do to the tax they pay?
Decision-maker: a regulator protecting bettors (the Michigan Gaming Control Board, or a state lawmaker), deciding whether to cap or limit free-play deductions.
Data: Michigan Gaming Control Board monthly internet sports betting files; one row is one licensed sportsbook operator in one month.

## Drafts, 2026-11-23

**Descriptive, draft A.** The Michigan Gaming Control Board needs to see how much free play the state's online sportsbooks deducted for every $100 wagered, and how often a sportsbook paid no state tax in a month, across the 15 licensed operators, commercial and tribal, month by month from January 2021 to October 2026, to learn which sportsbooks lean hardest on free-bet promotions and whether that reliance is fading.

**Descriptive, draft B.** For each licensed online sportsbook in Michigan and each month from January 2021 to October 2026, the Michigan Gaming Control Board needs to know what percent of the dollars wagered came back out as free-play deductions, compared across operators, operator type and years, so it can tell whether free-bet promotions are a launch-period cost or a permanent feature of the market.

**Predictive, draft A.** At the start of each month, using only what each sportsbook reported in earlier months, the Board wants two estimates for that sportsbook's month ahead: the free play it will deduct per $100 wagered (a percent), and whether it will pay no state tax that month (yes or no).

**Predictive, draft B.** Before a month begins, the Board wants to forecast two things for every licensed sportsbook from its prior monthly reports and its operator type: its free-play deductions as a percent of dollars wagered (the regression problem), and whether its state tax payment for the month will be zero (the classification problem).

**Prescriptive, draft A.** Given those estimates, at what percent of a sportsbook's gross sports betting receipts should Michigan cap the monthly free-play deduction, to collect the most tax, with one cap for every operator and a cap no lower than 10 percent?

**Prescriptive, draft B.** Given those forecasts, what limit on the free-play deduction, as a percent of each sportsbook's gross receipts, should the Board recommend to lawmakers to minimize the number of sportsbook-months in which no tax is paid, while keeping every currently active operator's deduction at or above a set floor so promotions are limited rather than banned?

## Variables each version needs

| Version | Outcome | Likely drivers | Decision variable |
|---|---|---|---|
| Descriptive | Free play per $100 wagered (percent); whether no state tax was paid (yes or no) | Operator; operator type (commercial or tribal); platform brand; month and year; months since launch; dollars wagered | none |
| Predictive | Regression: free play per $100 wagered in the month ahead. Classification: no state tax paid in the month ahead | Prior-month free play per $100; prior-month share of wagers kept; prior-month dollars wagered; whether no tax was paid the month before; operator type; months since launch; month of the year | none |
| Prescriptive | State tax collected (dollars); sportsbook-months with no tax paid | The predictions above | The cap on the free-play deduction, as a percent of gross receipts |

## Five-part table (draft A wording)

| Part | Descriptive | Predictive | Prescriptive |
|---|---|---|---|
| Decision-maker | "The Michigan Gaming Control Board" | "the Board" | "Michigan" (the Board, recommending to lawmakers) |
| Decision or need | "needs to see how much free play [...] and how often a sportsbook paid no state tax" | "wants two estimates for that sportsbook's month ahead" | "at what percent [...] should Michigan cap the monthly free-play deduction" |
| Outcome measure, with units | "free play [...] deducted for every $100 wagered"; "paid no state tax in a month" (yes or no) | "free play it will deduct per $100 wagered (a percent)"; "whether it will pay no state tax that month (yes or no)" | "collect the most tax" (dollars) |
| Scope: one row, population, place, period | one sportsbook in one month; "the 15 licensed operators, commercial and tribal"; Michigan; "January 2021 to October 2026" | one sportsbook in one month ahead; licensed Michigan sportsbooks | every licensed operator; monthly |
| Value | "to learn which sportsbooks lean hardest on free-bet promotions and whether that reliance is fading" | **EMPTY: the draft does not say what the Board does with the estimates** | **EMPTY: the draft does not say what changes once the cap is known** |

Notes for Brennan before he rewrites:
- Two cells are empty in draft A. A complete statement says what the estimates or the cap are *for*.
- A cap on the deduction is set in state law, so the Board would recommend it and the Legislature would decide. Say who controls the decision.
- The "10 percent" floor in prescriptive draft A comes from a Board news release about internet casino gaming, reported by a research subagent and not yet re-opened. Treat it as unverified until checked, or choose a different constraint.
- "Free play" here means the deduction as reported in the month it was claimed. A sportsbook can claim it late, so a month's figure is not exactly that month's promotions.

## Drafts, version 2 (2026-11-23), after Brennan's content decisions Q-057 to Q-060

Still the assistant's wording. The content choices are Brennan's: what the estimates are for, who decides the cap, the objective and the constraints.

**Descriptive (unchanged from draft A).** The Michigan Gaming Control Board needs to see how much free play the state's online sportsbooks deducted for every $100 wagered, and how often a sportsbook paid no state tax in a month, across the 15 licensed operators, commercial and tribal, month by month from January 2021 to October 2026, to learn which sportsbooks lean hardest on free-bet promotions and whether that reliance is fading.

**Predictive, version 2.** At the start of each month, using only what each sportsbook reported in earlier months, the Board wants two estimates for that sportsbook's month ahead: the free play it will deduct per $100 wagered (a percent), and whether it will pay no state tax that month (yes or no), so that staff can review the free-play claims of the flagged sportsbooks first.

**Prescriptive, version 2.** Given those estimates, what cap on the monthly free-play deduction, as a percent of a sportsbook's gross sports betting receipts, should the Board recommend that the Legislature write into law, to collect the most state and city tax, with one cap for every operator and no cap below the share of gross receipts that the median sportsbook-month actually deducted?

Five-part check of version 2: no empty cells. Decision-maker: the Board in all three (recommending to the Legislature in the third). Value: which sportsbooks lean hardest and whether it is fading; which claims to review first; how much more tax a cap would collect.

Still open (O-001): Brennan rewrites all three in his own words in `authored/problem_statements.md`. Until then every copy of these statements is labeled a working draft.
