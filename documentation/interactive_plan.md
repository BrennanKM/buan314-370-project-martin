# Plan for the HTML versions

One row for every figure in the static report, plus the explorer (course Prompt 7.5). Plan only; nothing is built by this file. Decision-maker: the Michigan Gaming Control Board. Written 2026-11-24 by the AI assistant; the choice of which interactions to build follows the three trials in `figure_notes.md`.

Every view is rebuilt in the page's own CSS and JavaScript from data that `scripts/08_export_html_data.R` writes into the page. No view needs more than 923 rows (the limit is about 5,000 points), so nothing is sampled.

| Figure | Sub-question it serves | Static or interactive in the page | What the reader can do | What changes on screen | Rows or summary tables it needs | Reason for the interaction (one sentence) |
|---|---|---|---|---|---|---|
| fig01 Spread of free play per $100 | 1 | Static | Nothing | Nothing | eda_01b (19 bands) and eda_01 (median, quartiles) | None: 20 bars with the median marked can be read without help. |
| fig03 Share of all dollars wagered | 3 | Static | Nothing | Nothing | eda_03 (15 rows) | None: every bar carries its value as a label. |
| fig04 Free play per $100 by operator | 4 | **Interactive** | Point at an operator's box; switch the frame between "$0 to $20" and "all months" | A panel shows that operator's median, quartiles, months and largest month; the frame widens to the largest value | 919 rows (operator, type, month, free play per $100) and eda_04 (15 rows) | Fifteen boxes cannot all carry their numbers, and 29 months sit outside the printed frame. |
| fig09 Share of months with no tax, by year and type | 9, 2, 8 | **Interactive** | Point at a year; switch each operator type on and off | A panel shows the share with the count behind it (for example 88 of 119) for both types that year; a hidden type's line disappears | eda_09 (12 rows) | A percentage of 36 months means something different from a percentage of 141, and the print version cannot show every count. |
| fig10 Free play per $100 by age and type | 10, 5, 6 | Static | Nothing | Nothing | eda_10 (10 rows) | None: ten points, each labeled with its value and count. |
| fig12 Correlation heat map | 12 | **Interactive** | Point at a cell; click a variable name | The pair, its correlation and the rows used appear in words; clicking a name lists that variable's correlations from strongest to weakest | eda_12 matrix and the rows-used matrix for the 12 variables shown (144 cells) | With 144 cells, following one variable across a row is slow and the rows used differ by pair. |
| fig_m1 Predicted against actual (Model 1) | Model 1 | **Interactive** | Point at a dot; switch between the full range and a zoom on $0 to $20 | The operator, month, predicted and actual value appear; the axes rescale | 900 rows (operator, type, month, predicted, actual) | Most of the 900 points crowd one corner because a few months near $120 stretch the axes. |
| fig_m1 Errors against predicted (Model 1) | Model 1 | Static | Nothing | Nothing | The same 900 rows | Could be shown as well with hover, but the predicted-against-actual view already names every point. |
| fig_m2 Predicted probability by actual outcome (Model 2) | Model 2 | Static | Nothing | Nothing | 906 predicted probabilities in bands of 0.05, by actual outcome (at most 50 counts) | None: two histograms with the cutoff marked. |

Interactive figures: four (fig04, fig09, fig12, fig_m1 predicted against actual). No report figure is missing from the plan. Views where the same thing could be shown as well without interaction: fig_m1 errors (flagged above); it stays static.

## Explorer

One view where the reader picks a group of sportsbooks and a period, and both a chart and a summary table change.

| Control | Starting value | What it changes |
|---|---|---|
| Sportsbook (a list: all 15, commercial only, tribal only, or one named operator) | All 15 | Which rows feed the chart and the table |
| From year and to year (two lists, 2021 to 2026) | 2021 to 2026 | The months included |
| Leave out the flagged months (a tick box: the 21 lump-deduction months and 15 first months) | Not ticked | Whether those rows are counted |

Chart that updates: one bar per $1 band of free play per $100 (the same bands as fig01), for the chosen rows, with the median marked.

Summary that updates (a small table): sportsbook-months chosen; months with a free play value; median free play per $100; share of months at $10 or more; months with no state tax paid and that share; total dollars wagered. Any figure resting on fewer than 30 months is marked.

Data needed: all 923 rows with eight columns (operator, operator type, month, dollars wagered, free play per $100, paid no tax, lump-deduction flag, first-month flag).

Reason for the explorer, in one sentence: the Board regulates each operator separately, and the report's figures can only show all of them at once.

Check for the build: with the starting values the explorer's summary must equal eda_01 and eda_02 (923 months, 919 with a value, median $3.71, 8.81% at $10 or more, 449 no-tax months, 48.65%).
