# Wrangling log

One row per cleaning step, in the order the steps run. Written by `scripts/03_clean.R` each time it runs; do not edit by hand. Step numbers are those of the approved plan (`documentation/cleaning_plan.md`), which Brennan decided step by step on 2026-11-23 (questions Q-023 to Q-033). The script stops if any step affects a different number of rows or values than the plan predicted.

| Step | What changed | Why | Rows before | Rows after | Values changed or flagged | Script | Approved by Brennan |
|---|---|---|---|---|---|---|---|
| 1 | Reshaped the wide workbooks to one row per operator per month. No value changed. | One row must be one operator in one month. | 1,956 | 1,956 |  | scripts/03_clean.R | 2026-11-23 |
| 2 | Kept each year's copy from the newest workbook that carries it; removed the duplicate copy. | Every year except 2026 appears in two workbooks; the copies agree in every cell where both hold a number. | 1,956 | 1,068 |  | scripts/03_clean.R | 2026-11-23 |
| 3 | Dropped months that are blank for every operator (December 2026, November 2026). | They have not been reported yet, so they are not observations. | 1,068 | 1,038 |  | scripts/03_clean.R | 2026-11-23 |
| 4 | Dropped operator-months with no wagering: Total Handle zero (96) or blank (18). Receipts and tax are zero or blank in all of them. | The question is about sportsbooks that are operating; these are months before launch, after stopping, or paused. | 1,038 | 924 |  | scripts/03_clean.R | 2026-11-23 |
| 5 | Dropped the row with a negative Total Handle (Little Traverse Bay Bands of Odawa Indians, August 2023: -1,419.34). | A closing correction after the operator stopped, not a month of betting. | 924 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 10 | Removed typed footnote markers from operator names (19 labels became 15 names) and added a short name for figures. | One operator needs one name. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 11 | Kept the platform provider (brand) as printed on each year's sheet and added each operator's latest label as a second column. | Brand labels change across years; the operator is the stable key. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 12 | Created operator type from the label of the tax column: commercial (210 rows), tribal (713 rows). | Operator type is not a column in the file. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 13 | Converted the launch date from a spreadsheet day number in text to a date (one cell held text and reads as the same date as its other form). | Wrong type in the file. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 7 | No change: 50 months with negative gross receipts kept as reported. | A sportsbook can pay out more than it takes in a month. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 15 | No change: tax or payment kept as reported, including 232 months with positive adjusted receipts and zero tax. | The reported figure is what was paid; it defines the yes-or-no target. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 16a | Created: month_date, free_play_deduction (gross minus adjusted receipts), free_play_per_100, kept_per_100, paid_no_tax, log10_handle, months_active. | Needed by the problem statements; each is defined in the codebook. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 9 | Added the flag lump_deduction = 1 where the deduction is more than a quarter of that month's handle. No value changed. | Free play can be claimed in a later month as a lump; the flag lets findings be checked with and without those months. | 923 | 923 | 21 rows flagged | scripts/03_clean.R | 2026-11-23 |
| 14 | Added the flag first_active_month = 1 for each operator's first month with wagering. No value changed. | First months are partial (January 2021 starts on the 22nd). | 923 | 923 | 15 rows flagged | scripts/03_clean.R | 2026-11-23 |
| 8 | Kept the rows; set free_play_deduction and free_play_per_100 to missing where adjusted receipts exceed gross receipts. | A negative amount is not free play and the file does not explain it. | 923 | 923 | 4 values set to missing (2 rows) | scripts/03_clean.R | 2026-11-23 |
| 6 | Kept the rows; set free_play_per_100 and kept_per_100 to missing where Total Handle is under $10,000. | Ratios on a few hundred dollars are not meaningful. | 923 | 923 | 4 values set to missing (2 rows) | scripts/03_clean.R | 2026-11-23 |
| 16b | Created prior-month versions (prior_free_play_per_100, prior_kept_per_100, prior_log10_handle, prior_paid_no_tax), filled only when the operator's previous calendar month is in the data (906 of 923 rows). | Things known at the start of a month, for the predictive statement. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |
| 17 | Gave columns plain lower-case names and fixed their order (28 columns). Dollar amounts are kept exactly as published, with no rounding. | Clear names; no value changed. | 923 | 923 |  | scripts/03_clean.R | 2026-11-23 |

## Row accounting

| Stage | Rows |
|---|---|
| Operator-month cells read from the raw workbooks (11 sheets) | 1,956 |
| Less step 2: Kept each year's copy from the newest workbook that carries it; removed the duplicate copy. | -888 |
| Less step 3: Dropped months that are blank for every operator (December 2026, November 2026). | -30 |
| Less step 4: Dropped operator-months with no wagering: Total Handle zero (96) or blank (18). Receipts and tax are zero or blank in all of them. | -114 |
| Less step 5: Dropped the row with a negative Total Handle (Little Traverse Bay Bands of Odawa Indians, August 2023: -1,419.34). | -1 |
| Rows in data/processed/mgcb_operator_months.csv | 923 |

The accounting closes: 1,956 - 888 - 30 - 114 - 1 = 923.

No missing values were filled in, no values were capped or trimmed, and no row was dropped for having an extreme value.

