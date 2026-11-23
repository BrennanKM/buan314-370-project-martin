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

## 3. Shortlist of three (Brennan's choice)

*Pending.*

## 4. Stress test (Prompt 1.2): skeptical manager, scores 1 to 5, no winner declared

*Pending.*

## 5. Brennan's choice of question and decision-maker

*Pending.*
