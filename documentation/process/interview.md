# Part 1 record: interview, candidates, stress test

The working record of course Prompts 1.1 to 1.3. Brennan's answers are copied word for word from `questions_log.md`. The candidate list and the stress test are the assistant's; the choice is Brennan's.

## 1. Interview (Prompt 1.1), 2026-11-23

| Question | Brennan's answer (verbatim) |
|---|---|
| Is gambling still the area you want this project in? (Q-005) | "Gambling, but open" |
| When you call a gambling company predatory, which measurable thing do you mean? (Q-006) | "Free-bet bait,How much bettors lose,Ad and app pressure" |
| 1. Major: which kind of analysis do you most want this project to show you can do? (Q-007) | "Consumer behavior" |
| 2. Jobs: where have you worked, and what decision did you see go wrong there? (Q-008) | "My own apps or startup" |
| 3. Interests: where does gambling touch your life or the people around you? (Q-009) | "Friends bet on sports,I follow sports,Prediction markets,Tech and product design" |
| 4. After graduation: what kind of work do you want? (Q-010) | "AI / tech product roles" |
| 5. Whose decision in gambling goes wrong most often and matters most? (Q-011) | "The bettor" |

What the assistant took from it: the decision-maker he cares about is the person placing bets, not the regulator the kickoff notes assumed. "Predatory" means three measurable things to him: promotional free bets, how much bettors lose, and ad and app pressure. He did not pick harm outcomes (helplines, debt).

## 2. Eight candidate research questions (Prompt 1.1)

Each must be answerable with public data in table form. "Likely publisher" is a lead to check in Part 2, not a verified fact. Nothing here has passed the data gate.

| # | Candidate question | Who would use the answer | Outcome measured | One row of the ideal data set | Likely publisher (to check) | Most likely reason it fails |
|---|---|---|---|---|---|---|
| 1 | **Free-bet bait in Michigan.** How much promotional credit do Michigan's online sportsbooks deduct per $100 wagered, and how does it compare with what bettors lose, by sportsbook and month? | A bettor choosing a sportsbook (or the state regulator weighing a cap) | Promotional deductions as a percent of dollars wagered; bettor losses as a percent of dollars wagered | One licensed sportsbook in one month | Michigan Gaming Control Board (pre-checked 2026-11-18: 923 active rows) | The outcome is not cleanly in the data: deductions are not pure free play and can be claimed months late. Rows are sportsbook totals, not people. |
| 2 | **Parlays against single bets.** How much more do bettors lose per $100 on parlays than on single bets, by sport and sportsbook? | A bettor deciding what kind of bet to place | Share of dollars wagered that the sportsbook keeps, in percent | One sportsbook, one month, one sport or bet type | A state regulator that reports by sport and bet type (Illinois and Colorado are leads) | Too aggregated or not in table form: the regulator may publish statewide totals or PDFs only. |
| 3 | **Which sportsbook keeps the most.** What share of each dollar wagered does each New York mobile sportsbook keep, week by week, and does it move with the sports calendar? | A bettor choosing among apps | Weekly share of wagers kept, in percent | One sportsbook in one week | New York State Gaming Commission (lead) | Too few variables: wagers and revenue only, so the three-numeric, two-categorical rule and the "drivers" are thin. |
| 4 | **Do prediction-market prices tell the truth?** Do event contracts priced as near-sure things pay off as often as their prices say, and where do buyers overpay? | A trader deciding whether to buy favorites or long shots | Return per $1 contract, in cents; whether the contract resolved yes | One settled market, with its price at a fixed time before close | Kalshi's public market-data interface (lead) | Terms of use may not allow reuse, and the price and the outcome can be the same thing recorded twice if the price is taken too close to settlement. |
| 5 | **The house edge in posted odds.** How large is the margin built into sportsbook odds, and do bets on favorites or underdogs lose more? | A bettor deciding which side and which book | Return on a $1 bet, in cents; the bookmaker's built-in margin, in percent | One game with closing odds and the result | Odds archives (European soccer files are the best-documented lead) | Provenance: US odds archives are mostly third-party re-uploads, and the well-documented files are not the US apps this project is about. |
| 6 | **Legalization and losses across states.** After a state allows mobile betting, how fast do dollars wagered and dollars lost per adult grow? | A resident or lawmaker in a state that has not legalized (California) | Dollars wagered and lost per adult per month | One state in one month | Each state's gaming regulator, stitched together | Too aggregated for a bettor's decision, and it needs many sources joined by hand. |
| 7 | **Ad and app pressure.** Does heavier sportsbook advertising go with more betting? | A regulator weighing ad limits | Ad spending or impressions; dollars wagered | One brand in one market in one month | None public (ad trackers are paid products) | The data are not public. Free stand-ins such as search-interest indexes are not dollars and are not row-level. |
| 8 | **Not gambling: high-cost mortgages.** Which San Diego County mortgage applicants are denied or end up with high-cost loans, and how does that differ by lender and loan type? | A first-time borrower deciding where to apply | Interest-rate spread, in percentage points; denied or high-cost (yes or no) | One loan application | Consumer Financial Protection Bureau, Home Mortgage Disclosure Act data (lead) | No tie to the gambling interest, and the file is very large, so the scope would have to be cut to one county and year. |

## 3. Shortlist of three

Brennan handed this choice to the assistant (Q-012: "Up to your discretion, whichever are the best options"; Q-013: "Whichever you think"). The assistant shortlisted candidates **1, 2 and 4** (decision D-010). Candidates 5 and 8 are held as fallbacks.

## 4. Stress test (Prompt 1.2): skeptical manager, scores 1 to 5, no winner declared

Scores are the assistant's. The "public data" score rests on what was actually opened on 2026-11-23: the Michigan files were read; the Illinois file was not; Kalshi's data were not requested.

### The manager's three questions

**Candidate 1, Michigan free-bet bait.**
- *Why should anyone care?* Sportsbooks advertise "free" bets. The state's own files show what bettors lost and how much came back as free play, sportsbook by sportsbook.
- *What decision would change?* Honestly, not much for one bettor. The files are sportsbook totals; they cannot tell one person what he will lose or which promotions he will get. A bettor can use them to compare apps. A regulator could use the same numbers to judge a cap on free-play deductions, which is a sharper decision.
- *What would a surprising finding look like?* That the free play handed back is shrinking while the share of wagers the sportsbooks keep is rising, or that the biggest brands keep the most and give back the least.

**Candidate 2, parlays against single bets.**
- *Why should anyone care?* It is the one choice every bettor makes on every bet, and the apps push parlays.
- *What decision would change?* Whether to place parlays at all, and with whom.
- *What would a surprising finding look like?* That the gap is small in some sports or at some sportsbooks, or that it is not what the apps' own "boost" marketing implies.

**Candidate 4, prediction-market prices.**
- *Why should anyone care?* These markets sell themselves as trading, not gambling. If prices are systematically off, buyers of long shots or favorites are overpaying.
- *What decision would change?* Which contracts a trader buys, and at what price.
- *What would a surprising finding look like?* That contracts priced at 90 cents pay off clearly less than 90 percent of the time in one category and not in another.

### Scores

| Candidate | Decision relevance | Public row-level data exist | Feasible by 2026-12-01 | Room for varied figures | The blunt version |
|---|---|---|---|---|---|
| 1 Michigan free-bet bait | 3 | 5 | 4 | 4 | The data are real and in hand: 923 active sportsbook-months, 15 operators, the legal definition of the free-play deduction verified in the statute. The weak point is the decision. Totals per sportsbook do not tell a bettor what to do. Also: the state's terms forbid scripted downloads and republishing, so the files must be downloaded by hand and stay out of the repository. |
| 2 Parlays against single bets | 5 | 3 | 3 | 5 | The best question of the three and the least certain data. One regulator (Illinois) seems to offer the right table as CSV, but nobody has seen its columns. No data dictionary and no stated license were found. One test download would settle most of this. |
| 4 Prediction-market prices | 4 | 2 | 2 | 5 | The data exist row by row, but the only developer agreement that could be read limits use to a member's own trading and bars storing or sharing the data. Unless the current agreement says otherwise or Kalshi gives written permission, this fails the scorecard's license and ethics lines. |

For each score of 4 or 5 on public data, the kind of organization that publishes it: candidate 1, a state gaming regulator (Michigan Gaming Control Board), which collects monthly reports from operators under state law.

### What was checked and what was not

| Candidate | Checked on 2026-11-23 | Not checked |
|---|---|---|
| 1 | Six yearly workbooks read; row count, uniqueness and a correlation screen run; statute definitions quoted from legislature.mi.gov; michigan.gov terms of use read | Whether the State would give written permission to republish the files; the official copy of the administrative rules |
| 2 | Regulator pages opened for six states; the Illinois report form exists and offers CSV | The contents of any Illinois CSV; license; definitions |
| 4 | Kalshi's documentation pages; developer agreement version 1.1 (a PDF) | The current agreement on kalshi.com (blocked); any live request; whether a research program exists |

### Correlation screen for candidate 1 (read-only, 923 active rows)

"Kept per $100" is gross receipts divided by dollars wagered. "Free play per $100" is gross minus adjusted receipts divided by dollars wagered. "Prior month" is the same operator's value one month earlier (906 rows have one).

| Possible target | Strongest relationships with things known beforehand | Rows |
|---|---|---|
| Free play per $100 wagered (numeric) | prior month's free play per $100: r = 0.59; months since the operator's first active month: r = -0.26 | 906; 923 |
| Kept per $100 wagered (numeric) | size of the sportsbook (log of dollars wagered): r = 0.19; prior month's kept per $100: r = 0.06 with every row, 0.39 after setting aside the most extreme 1 percent at each end, 0.41 by rank | 923; 906 |
| Kept $10 or more per $100 (yes or no; 32.7% yes) | prior month's kept per $100: r = 0.33; commercial (Detroit casino) operator: r = 0.26; prior month's size: r = 0.23 | 906; 923 |
| Free play per $100 at or above the median (yes or no; 50.1% yes) | prior month's free play per $100: r = 0.37; months active: r = -0.26 | 906; 923 |

Reading it against the course rule (each target correlated with something at about 0.2 or more): free play per $100 passes as a numeric target. Kept per $100 passes only if the handful of months with almost no wagering are dealt with, which is a cleaning decision for Brennan. Both yes-or-no targets pass.

Group averages behind the strongest relationships (the course's Verify step): commercial operators' median kept per $100 is 10.45 (210 rows) against 7.24 for tribal operators (713 rows). By year, the median free play per $100 goes 5.82 (2021, 155 rows), 4.01, 3.39, 3.56, 3.02, 3.09 (2026, 127 rows), and the median kept per $100 goes 7.89, 7.27, 7.30, 6.88, 9.17, 10.26. These are screening numbers on uncleaned data, not findings.

## 5. Brennan's choice of question and decision-maker

*Pending.*
