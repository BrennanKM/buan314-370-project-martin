# Proposal: three problem statements and the viability scorecard

Milestone 1 (Parts 1 and 2 of the course instructions). Status on 2026-11-23: question, decision-maker and both targets chosen by Brennan; statements are still the assistant's working drafts; scorecard filled in from a read-only screen; **Brennan's decision: go** (section 5).

## 1. Research question and decision-maker

- **Research question:** how much do Michigan's online sportsbooks rely on promotional free play, and what does that do to the tax they pay? (Chosen by Brennan, decision D-012.)
- **Decision-maker:** a regulator protecting bettors (the Michigan Gaming Control Board, or a state lawmaker) deciding whether to cap or limit free-play deductions. (Chosen by Brennan, decision D-013.)
- **Numeric target:** free-play deductions per $100 wagered, in percent, for one sportsbook in one month (D-014).
- **Yes-or-no target:** the sportsbook paid no state tax or payment that month (D-015).

## 2. The three problem statements

> **Not final.** The text below is the AI assistant's draft A, which Brennan selected unchanged on 2026-11-23 as a starting point. The course requires the final wording to be his own. His rewrite goes in `authored/problem_statements.md` and then replaces this section (open question O-001).

| Version | Working draft (assistant-written) |
|---|---|
| Descriptive: what happened? | The Michigan Gaming Control Board needs to see how much free play the state's online sportsbooks deducted for every $100 wagered, and how often a sportsbook paid no state tax in a month, across the 15 licensed operators, commercial and tribal, month by month from January 2021 to October 2026, to learn which sportsbooks lean hardest on free-bet promotions and whether that reliance is fading. |
| Predictive: what could happen? | At the start of each month, using only what each sportsbook reported in earlier months, the Board wants two estimates for that sportsbook's month ahead: the free play it will deduct per $100 wagered (a percent), and whether it will pay no state tax that month (yes or no). |
| Prescriptive: what should be done? | Given those estimates, at what percent of a sportsbook's gross sports betting receipts should Michigan cap the monthly free-play deduction, to collect the most tax, with one cap for every operator and a cap no lower than 10 percent? |

### Five-part check of the working drafts

| Part | Descriptive | Predictive | Prescriptive |
|---|---|---|---|
| Decision-maker | The Michigan Gaming Control Board | the Board | "Michigan" (does not say who controls a cap; it is set in state law) |
| Decision or need | see how much free play was deducted and how often no tax was paid | two estimates for the month ahead | the level of a cap on the free-play deduction |
| Outcome measure (with units) | free play per $100 wagered (percent); paid no state tax (yes or no) | the same two, for the month ahead | tax collected (dollars) |
| Scope (one row; population, place, period) | one sportsbook in one month; 15 licensed operators; Michigan; January 2021 to October 2026 | one sportsbook in the month ahead | every licensed operator, monthly |
| Value | which sportsbooks lean hardest on free play, and whether it is fading | **EMPTY** | **EMPTY** |

Predictive sub-specifications: regression problem (numeric target) = free play per $100 wagered; classification problem (yes-or-no target) = paid no state tax; moment of prediction = the start of the month, using only earlier months' reports.

Prescriptive parts: decision = the cap on the monthly free-play deduction, as a percent of gross receipts; objective = collect the most tax; constraints = one cap for every operator, and a cap no lower than 10 percent (the 10 percent figure is unverified).

## 3. Shortlist of candidate data sources

Only pages opened in this project's search on 2026-11-23 are listed. "Not stated" means the page does not say. "Opened by" says who actually loaded the page; **Brennan still has to open each link himself** (course rule for Milestone 1).

| # | Name | Original publisher | Page address | Opened by | Format | Rows × columns | What one row is | Period | License | Data dictionary | What it lacks |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Internet Sports Betting Revenues and Taxes (page title "Revenues and Wagering Tax Information") | Michigan Gaming Control Board | https://www.michigan.gov/mgcb/detroit-casinos/resources/revenues-and-wagering-tax-information | lead agent | Excel, one workbook per year, 2021 to 2026 | Not stated on the page. Counted in the files: 1,038 reported operator-months, 923 with dollars wagered above zero; 4 numeric columns per operator | One licensed operator in one month | January 2021 to October 2026 | Not stated for the data. Site terms ("Updated: December 2021") bar scripted access and republishing without written permission | None on the page. Each workbook has notes; the statute defines gross and adjusted receipts | A separate free-play column (it is derived as gross minus adjusted); a publisher definition of "Total Handle"; permission to repost |
| 2 | Internet Gaming Revenues and Taxes (online casino), same page | Michigan Gaming Control Board | same page | lead agent (links seen, files not opened) | Excel, one workbook per year | Not stated; not counted | Expected: one licensed operator in one month | 2021 to 2026 | Same site terms | Not checked | Not inspected. Possible extension only |
| 3 | Sports Wagering Monthly Reports | Illinois Gaming Board | https://igb.illinois.gov/sports-wagering/sports-reports.html | research subagent | CSV and PDF from a report form | Not stated | Not stated; file not seen | Form lists 2020 to 2026 | Not stated | None on the page | Contents unconfirmed; would answer a different question (parlays) |
| 4 | Monthly Sports Wagering Data | Maryland Lottery and Gaming | https://www.mdgaming.com/maryland-sports-wagering/revenue-reports/ | research subagent | Excel, one file per month | Not stated | Not stated; file not seen | From December 2021 | Not stated | Partial | Operator and bet type are not crossed; no free-play measure confirmed |
| 5 | Kalshi market data interface | Kalshi | https://docs.kalshi.com/getting_started/quick_start_market_data | research subagent | Web interface (JSON) | Not stated | One market | Not stated | Developer agreement v1.1 limits use to a member's own trading and bars storing or sharing | Yes (interface documentation) | Terms do not appear to allow this use; different question |

Ranking for the descriptive statement: source 1 is the only one that contains the outcome. Sources 3 to 5 answer other questions and were stress-tested and set aside (`process/interview.md`).

## 4. Inspection and correlation screen (Prompts 2.2 and 2.3)

Read-only, in memory, run 2026-11-23 on copies kept outside the repository. Nothing was cleaned or saved. These are screening numbers on uncleaned data, not findings.

**File facts**

| Fact | Value |
|---|---|
| Workbooks | 6 (one per year, 2021 to 2026); each also carries the prior year's sheet |
| What one row is | One licensed operator in one month (after reshaping; the workbooks are laid out wide, four columns per operator) |
| Row count, found | 1,068 operator-month cells, of which 30 are November and December 2026 (not yet reported, blank). 1,038 reported through October 2026. 923 have dollars wagered above zero |
| Row count, stated by the publisher | Not stated on the page |
| Columns per operator | Total Handle; Gross Sports Betting Receipts; Adjusted Gross Sports Betting Receipts; Internet Sports Betting State Tax (5.88%) or State Payment (8.4%) |
| Header fields per operator | Operator; Casino Name; Platform Provider; Initial date of Operation launch |
| Earliest and latest month with wagering | January 2021; October 2026 |
| Distinct operators | 15 (3 commercial Detroit casinos, 12 tribal) |
| Duplicated operator-month identifiers | 0 |
| Same year in two workbooks | 3,552 cells compared; 0 differ; 18 are blank in one workbook only |
| Numeric variables | 4 as published (handle, gross receipts, adjusted receipts, tax or payment) |
| Categorical variables | Operator (15), platform provider (brand; labels change across years for 9 operators), month, year, tax type (state tax 5.88% for commercial operators, state payment 8.4% for tribal operators) |
| Two-category variables | Tax type (commercial or tribal) as published; the yes-or-no target (tax column is zero) is derived |

**Every variable the statements need, mapped to the file**

| Needed | Column in the file |
|---|---|
| Free play deducted | Absent as a column. Derived: Gross Sports Betting Receipts minus Adjusted Gross Sports Betting Receipts (the statute makes free play the only deduction between the two; see scorecard, Documentation) |
| Dollars wagered | Total Handle (not defined by the publisher on the pages opened: **undocumented**) |
| Paid no state tax | Internet Sports Betting State Tax / State Payment column equal to zero |
| Operator, operator type, brand | Operators row; tax-type label; Platform Providers row |
| Month and year | Month column; sheet name |
| Months since launch | Initial date of Operation launch row |

**Correlation screen** (923 active rows; "prior month" is the same operator one month earlier, 906 rows)

| Target | Variable | Correlation | Rows used |
|---|---|---|---|
| Free play per $100 wagered | Prior month's free play per $100 wagered | 0.59 | 906 |
| Free play per $100 wagered | No tax paid the month before (1 = yes) | 0.27 | 906 |
| Free play per $100 wagered | Months the operator has been active | -0.26 | 923 |
| Free play per $100 wagered | Prior month's share of wagers kept | 0.18 | 906 |
| Free play per $100 wagered | Size (log of dollars wagered, same month) | -0.09 | 923 |
| Paid no state tax (1 = yes; 48.6% yes) | Prior month's size (log of dollars wagered) | -0.46 | 906 |
| Paid no state tax | No tax paid the month before | 0.42 | 906 |
| Paid no state tax | Prior month's free-play dollars (log) | -0.31 | 881 |
| Paid no state tax | Commercial operator (1 = yes) | -0.30 | 923 |

Checks on the strongest relationships: the 0.59 does not rest on a few rows (it is 0.64 with the most extreme 1 percent at each end set aside, and 0.80 by rank). Warning from the course card on correlations near 1: adjusted receipts and tax are built from gross receipts and deductions in the same month, so same-month versions of the targets are not used as drivers.

Things the screen turned up that will need a decision in Part 5: one month with negative dollars wagered; 50 active rows with negative gross receipts; 2 with negative deductions; ratios become extreme in months with almost no wagering (free play per $100 ranges from -10.6 to 121.8); in 232 active rows adjusted receipts are positive but no tax was paid, which fits the rule that negative receipts carry forward; a sportsbook can claim free play in a later month as a lump (the Board's 18 July 2024 release describes a $48.2 million deduction "taken by one of the operators").

## 5. Viability scorecard (Prompt 2.4)

Score each line pass, concern or fail, with evidence. One fail means the source is not viable as it stands.

| Criterion | Score | Evidence | What would resolve a concern |
|---|---|---|---|
| Access | **Concern** | The page and all six workbooks load in a browser without payment or sign-in. But "you have downloaded it yourself" is not yet true: Brennan has not downloaded a file. The site's terms bar scripted access, so the download must be by hand. | Brennan downloads the six workbooks in a browser into `data/raw` and the checksums are recorded. |
| License | **Concern** (on a strict reading, close to a fail) | https://www.michigan.gov/som/footer/policies, "Updated: December 2021": "You may not modify, copy, distribute, display, reproduce, publish, license, create derivative works from, sell, or transfer information [...] obtained from Michigan.gov unless the law otherwise provides or the State gives you prior written permission." Also: "You specifically agree not to access [...] any of the website through any automated means (including, but not limited to, use of scripts, web crawlers or screen scrapers)". Commercial use is barred; academic use is not mentioned. No separate terms for Gaming Control Board data were found. | (1) Keep the State's workbooks out of the public repository and give exact manual download steps plus checksums instead (the course treats "no reposting" as a pass; a download script is not possible here because the terms bar scripts). (2) Brennan asks the Board in writing whether a student may use and repost the files for a class project. (3) Brennan asks Dr. Levkoff whether manual steps plus checksums satisfy the replication requirement. |
| Relevance | **Pass** | Both targets and several drivers are in the files or derived from them (section 4 mapping). | |
| Granularity | **Pass** | One row is one licensed operator in one month, which is the unit in the statements. | |
| Size | **Pass** | 923 operator-months with wagering (1,038 reported through October 2026). | |
| Variable mix | **Pass** | 4 numeric variables as published; categorical: operator, platform provider, month, year, tax type; tax type has two categories. | |
| Correlation | **Pass** | Numeric target: r = 0.59 with its prior month (906 rows). Yes-or-no target: r = -0.46 with prior-month size and 0.42 with no tax the month before (906 rows). | |
| Documentation | **Concern** | No data dictionary on the page. Gross and adjusted receipts are defined in state law: MCL 432.403(a), https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-432-403 : "'Adjusted gross sports betting receipts' means gross sports betting receipts less a deduction for the monetary value of free play wagered by authorized participants" (quoted by a research subagent; substance confirmed by a second fetch; Brennan to open the page). Tax: MCL 432.414(1): "a sports betting operator is subject to a tax of 8.4% on its adjusted gross sports betting receipts". Each workbook carries notes (tax split, exits, audit status). "Total Handle" is not defined by the publisher on any page opened. | Cite the statute sections in the codebook for gross receipts, adjusted receipts and tax. For "Total Handle", get the Board's definition in writing or find it in the Board's rules; until then that label reads UNDOCUMENTED. |
| Provenance | **Pass** | The Board collects the figures from operators each month under MCL 432.416a(1), https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-432-416a : the operator's monthly report includes "Total amount of internet sports betting wagers received", "Winnings", "Free play redeemed", "Deductions" and "Adjusted gross sports betting receipts". The Board is the original publisher. Workbook footnote: "As reported by operator"; "not all revenue amounts have been subjected to audit or review". | |
| Privacy and ethics | **Pass, with one condition** | No people in the data: rows are licensed casinos and tribal operators. Condition: nothing may be collected against the site's terms, so project data must be the hand-downloaded files. On 2026-11-23 the assistant fetched the page and six workbooks by script before reading the terms; those copies are not project data and are not in the repository (prompt log entry 12). | Brennan's manual download replaces the scripted copies; the scripted copies are deleted once the checksums have been compared. |
| Room to grow | **Pass** | The lever is a cap on the free-play deduction. The files hold gross receipts and the deduction for every operator-month, so the tax due under any cap can be computed. What is missing: how sportsbooks would change their promotions under a cap. | |

**Recommendation (assistant): go, with three concerns to resolve (Access, License, Documentation). No line is scored fail, but License is the one a strict reader could fail.**

**Decision (Brennan, 2026-11-23): GO**, without outreach ("Go, but no emails"). Hand downloads; the State's files stay out of the repository; click steps and checksums are published instead. The License and Documentation lines remain concerns (decision D-016).

## 6. Loops back from the data gate

| Date | What was tried | Why it failed | What changed |
|---|---|---|---|
| 2026-11-23 | First framing: "predatory" gambling practices at Stake, DraftKings and Kalshi, with the bettor as decision-maker. | "Predatory" is not a measurable outcome; company practice data are private; the three companies sit under different regulators, so no single public data set covers them; sportsbook totals cannot guide one bettor. | Unit changed from the company's practices to one licensed sportsbook in one month in one state; outcome changed to free-play deductions per $100 wagered; decision-maker changed from the bettor to a regulator protecting bettors (course Part 2 table: "Change the unit [...] or the decision-maker"). |
| 2026-11-23 | Prediction-market prices (Kalshi) as an alternative question. | The developer agreement that could be read limits data use to a member's own trading and bars storing or sharing the data (license; ethics). | Set aside. |
| 2026-11-23 | Parlays against single bets (Illinois Gaming Board reports) as an alternative question. | The file's contents could not be confirmed, and no license or definitions were found. | Set aside; kept as a fallback if the Michigan source is rejected. |
