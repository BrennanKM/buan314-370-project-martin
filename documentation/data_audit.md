# Data audit

What the raw data looked like before any cleaning (course Prompt 5.1). **Report only: nothing was fixed, dropped or saved as data.** This file is written by `scripts/02_audit.R`; do not edit it by hand.

Run on 2026-11-23.

## 1. What was read

- 6 workbooks, 11 sheets. Each workbook holds one sheet for its own year and (except the first) one for the prior year.
- Layout: wide. Column 1 holds the row labels. Each operator has a block of four columns (Total Handle, Gross Sports Betting Receipts, Adjusted Gross Sports Betting Receipts, state tax or payment). Rows above the months hold the operator, casino name, platform provider and launch date. After the operators come an all-operator total block and one city-tax column for the commercial operators.
- One row of the data, once reshaped, is **one licensed operator in one month**, identified by operator, year and month.
- Operator-month cells read from all sheets, stacked: **1,956**.
- Taking one copy of each year from the newest workbook that carries it: **1,068** operator-months, 15 operators, sheet years 2021 to 2026.
- Of those 1,068: Total Handle is blank in 48, exactly zero in 96, negative in 1, and above zero in **923**.
- First month with wagering: January 2021. Last: October 2026.
- Columns in the workbooks that are not about one operator: the all-operator total block (used below only as a cross-check) and "City Wagering Taxes and Municipal Service Fees" under "Commercial Operators".

## 2. Column profile

Profiled on the 1,068 operator-months (one copy of each year). Numbers are dollars.

| Column | Type | Share missing | Distinct values | Minimum | Median | Mean | Maximum | Most common values (count) |
|---|---|---|---|---|---|---|---|---|
| Year (from the sheet name) | whole number used as a category | 0.0% | 6 |  |  |  |  | 2022 (180); 2023 (180); 2024 (180) |
| Month | text | 0.0% | 12 |  |  |  |  | April (89); August (89); December (89) |
| Operators | text | 0.0% | 19 |  |  |  |  | Bay Mills Indian Community (72); Grand Traverse Band of Ottawa and Chippewa... (72); Greektown Casino (72) |
| Casino Name | text | 0.0% | 15 |  |  |  |  | Bay Mills Resort & Casino/ Kings Club Casino (72); FireKeepers Casino (72); Four Winds Casino (72) |
| Platform Providers | text | 0.0% | 26 |  |  |  |  | BetMGM (72); DraftKings (72); FanDuel (72) |
| Initial date of Operation launch | date stored as a spreadsheet day number in text | 0.0% | 7 |  |  |  |  | 44218 (720); 44225 (72); 44242 (72) |
| Label of the tax or payment column | text | 0.0% | 2 |  |  |  |  | Internet Sports Betting State Payment (8.4%) (852); Internet Sports Betting State Tax (5.88%) (216) |
| Total Handle | number | 4.5% | 925 | -1,419.34 | 3,896,744.67 | 27,499,115.69 | 245,649,032.43 |  |
| Gross Sports Betting Receipts | number | 2.8% | 925 | -749,274.97 | 229,527.74 | 2,678,582.21 | 40,610,149.41 |  |
| Adjusted Gross Sports Betting Receipts | number | 2.8% | 925 | -45,708,163.96 | 77,956.68 | 1,420,297.56 | 28,308,654.78 |  |
| Internet Sports Betting State Tax / State Payment | number | 2.8% | 475 | 0.00 | 0.00 | 96,950.62 | 1,674,414.42 |  |

## 3. Problems found

Each problem has a count and up to three example rows. A count of 0 means the check was run and found nothing.

| # | Problem | Count |
|---|---|---|
| 1 | The same operator-month appears in two workbooks | 888 |
| 2 | Duplicated operator-month identifiers once one copy of each year is taken | 0 |
| 3 | Months not yet reported (blank) | 30 |
| 4 | Other blank Total Handle cells | 18 |
| 5 | Total Handle is exactly zero | 96 |
| 6 | Total Handle is negative | 1 |
| 7 | Total Handle is above zero but under $10,000 | 2 |
| 8 | Gross Sports Betting Receipts is negative (active months) | 50 |
| 9 | Adjusted receipts are larger than gross receipts (a negative deduction) | 2 |
| 10 | Adjusted Gross Sports Betting Receipts is negative (active months) | 217 |
| 11 | The deduction is more than a quarter of that month's handle | 21 |
| 12 | Adjusted receipts are positive but the tax or payment is zero | 232 |
| 13 | Tax or payment is neither zero nor the stated rate times adjusted receipts | 49 |
| 14 | Tax or payment is negative | 0 |
| 15 | Tax or payment is not zero although adjusted receipts are zero or negative | 0 |
| 16 | Operator names written more than one way | 4 |
| 17 | Platform provider (brand) label changes across sheets for the same operator | 10 |
| 18 | Casino Name written more than one way for the same operator | 0 |
| 19 | The tax column has two different labels | 2 |
| 20 | Launch date stored as the wrong type | 7 |
| 21 | Sheets that do not have a column block for every operator | 2 |
| 22 | A partial first month | 11 |
| 23 | Months where the operators do not add up to the published all-operator total | 0 |
| 24 | Operator blocks whose twelve months do not add up to the block's Total row | 1 |
| 25 | Columns the publisher does not define | 1 |

### 1. The same operator-month appears in two workbooks

**Count: 888.** Each yearly workbook also carries the prior year's sheet, so 888 operator-months are present twice (3,552 cells compared). Cells where both copies hold a number and the numbers differ by more than half a cent: 0. Cells that are blank in one copy and filled in the other: 18.

| Operator | Year | Month | Column | Older workbook | Newer workbook |
|---|---|---|---|---|---|
| Little Traverse Bay Bands of Odawa Indians | 2024 | January | handle | 0.00 | blank |
| Little Traverse Bay Bands of Odawa Indians | 2024 | February | handle | 0.00 | blank |
| Little Traverse Bay Bands of Odawa Indians | 2024 | March | handle | 0.00 | blank |

### 2. Duplicated operator-month identifiers once one copy of each year is taken

**Count: 0.** Identifier tested: operator, year, month, using the newest workbook for each year.

### 3. Months not yet reported (blank)

**Count: 30.** The 2026 sheet has rows for months after the last reported month (October); they are blank for every operator.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| MGM Grand Detroit | 2026 | November | blank | blank | blank | blank | Internet Sports Betting - 2026.xlsx |
| MGM Grand Detroit | 2026 | December | blank | blank | blank | blank | Internet Sports Betting - 2026.xlsx |
| MotorCity Casino | 2026 | November | blank | blank | blank | blank | Internet Sports Betting - 2026.xlsx |

### 4. Other blank Total Handle cells

**Count: 18.** Blank (not zero) in the newest workbook for that year. By operator: Little Traverse Bay Bands of Odawa Indians 12; Sault Ste. Marie Tribe of Chippewa Indians 6.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| Little Traverse Bay Bands of Odawa Indians | 2024 | January | blank | 0.00 | 0.00 | 0.00 | Internet Sports Betting - 2025.xlsx |
| Little Traverse Bay Bands of Odawa Indians | 2024 | February | blank | 0.00 | 0.00 | 0.00 | Internet Sports Betting - 2025.xlsx |
| Little Traverse Bay Bands of Odawa Indians | 2024 | March | blank | 0.00 | 0.00 | 0.00 | Internet Sports Betting - 2025.xlsx |

### 5. Total Handle is exactly zero

**Count: 96.** Months before an operator launched or after it stopped. By operator: Gun Lake Band Tribal Community 7; Hannahville Indian Community 4; Keweenaw Bay Indian Community 33; Little Traverse Bay Bands of Odawa Indians 19; Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) 5; Pokagon Band of Potawatomi Indians 1; Sault Ste. Marie Tribe of Chippewa Indians 24; Soaring Eagle Gaming 3.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) | 2021 | January | 0.00 | 0.00 | 0.00 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |
| Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) | 2021 | February | 0.00 | 0.00 | 0.00 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |
| Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) | 2021 | March | 0.00 | 0.00 | 0.00 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |

### 6. Total Handle is negative

**Count: 1.** Dollars wagered cannot be negative; likely a correction entered after the operator stopped.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| Little Traverse Bay Bands of Odawa Indians | 2023 | August | -1,419.34 | -97,578.10 | -4,890.84 | 0.00 | Internet Sports Betting - 2024.xlsx |

### 7. Total Handle is above zero but under $10,000

**Count: 2.** Real but tiny months. Any ratio that divides by handle (free play per $100 wagered, share kept) becomes extreme here.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| Sault Ste. Marie Tribe of Chippewa Indians | 2024 | April | 219.10 | -2,955.60 | -2,955.60 | 0.00 | Internet Sports Betting - 2025.xlsx |
| Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) | 2021 | June | 656.00 | 298.83 | -1.17 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |

### 8. Gross Sports Betting Receipts is negative (active months)

**Count: 50.** Possible in a month when winnings paid out exceed wagers taken, but worth seeing.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| Little River Band of Ottawa Indians | 2023 | October | 45,509,159.63 | -749,274.97 | -1,704,253.49 | 0.00 | Internet Sports Betting - 2024.xlsx |
| Sault Ste. Marie Tribe of Chippewa Indians | 2021 | June | 5,460,421.44 | -383,777.34 | -464,099.34 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |
| Grand Traverse Band of Ottawa and Chippewa Indians | 2023 | October | 42,020,379.41 | -306,455.97 | -1,028,427.70 | 0.00 | Internet Sports Betting - 2024.xlsx |

### 9. Adjusted receipts are larger than gross receipts (a negative deduction)

**Count: 2.** By law adjusted receipts are gross receipts less free play, so the difference should not be negative.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| Pokagon Band of Potawatomi Indians | 2022 | February | 817,694.23 | -69,041.03 | 17,740.27 | 0.00 | Internet Sports Betting January 2023.xlsx |
| Pokagon Band of Potawatomi Indians | 2022 | October | 845,498.95 | 47,757.63 | 49,731.47 | 0.00 | Internet Sports Betting January 2023.xlsx |

### 10. Adjusted Gross Sports Betting Receipts is negative (active months)

**Count: 217.** 23.5% of active months. Free play deducted was larger than gross receipts.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| MGM Grand Detroit | 2024 | June | 40,483,598.47 | 3,617,038.94 | -45,708,163.96 | 0.00 | Internet Sports Betting - 2025.xlsx |
| Little Traverse Bay Bands of Odawa Indians | 2026 | May | 66,842,847.42 | 22,325,098.63 | -15,944,670.62 | 0.00 | Internet Sports Betting - 2026.xlsx |
| Little Traverse Bay Bands of Odawa Indians | 2026 | April | 35,238,754.96 | 15,465,540.93 | -11,642,298.60 | 0.00 | Internet Sports Betting - 2026.xlsx |

### 11. The deduction is more than a quarter of that month's handle

**Count: 21.** Consistent with free play being claimed in a later month as a lump (the Board's 18 July 2024 news release describes one such deduction), or with a tiny month.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| MGM Grand Detroit | 2024 | June | 40,483,598.47 | 3,617,038.94 | -45,708,163.96 | 0.00 | Internet Sports Betting - 2025.xlsx |
| Little Traverse Bay Bands of Odawa Indians | 2026 | April | 35,238,754.96 | 15,465,540.93 | -11,642,298.60 | 0.00 | Internet Sports Betting - 2026.xlsx |
| Pokagon Band of Potawatomi Indians | 2021 | February | 12,680.22 | 3,839.67 | -4,859.94 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |

### 12. Adjusted receipts are positive but the tax or payment is zero

**Count: 232.** Consistent with the rule that negative adjusted receipts are carried forward against later months; the file does not show the carried balance.

| Operator | Year | Month | Total Handle | Gross receipts | Adjusted gross receipts | Tax or payment | Workbook |
|---|---|---|---|---|---|---|---|
| MotorCity Casino | 2021 | March | 107,196,819.05 | 7,771,367.71 | 4,995,430.46 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |
| MotorCity Casino | 2021 | April | 74,239,233.53 | 7,035,079.75 | 5,226,606.29 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |
| Bay Mills Indian Community | 2021 | March | 76,504,589.12 | 6,034,906.13 | 3,672,965.73 | 0.00 | Internet_Sports_Betting_-_January_2022_748264_7.xlsx |

### 13. Tax or payment is neither zero nor the stated rate times adjusted receipts

**Count: 49.** Stated rate: 5.88% (commercial, state share) or 8.4% (tribal). A partial amount is what a carried-forward balance being used up would produce.

| Operator | Year | Month | Adjusted gross receipts | Tax or payment | Rate times adjusted |
|---|---|---|---|---|---|
| MGM Grand Detroit | 2021 | February | 2,448,687.64 | 140,840.87 | 143,982.83 |
| MotorCity Casino | 2021 | May | 7,418,042.72 | 385,818.51 | 436,180.91 |
| Greektown Casino | 2021 | March | 3,583,819.48 | 134,122.45 | 210,728.59 |

### 14. Tax or payment is negative

**Count: 0.** 

### 15. Tax or payment is not zero although adjusted receipts are zero or negative

**Count: 0.** 

### 16. Operator names written more than one way

**Count: 4.** A footnote marker is typed into the name on some sheets.

| Operator | Labels found |
|---|---|
| Hannahville Indian Community | Hannahville Indian Community  //  Hannahville Indian CommunityNOTE 6 |
| Keweenaw Bay Indian Community | Keweenaw Bay Indian Community  //  Keweenaw Bay Indian CommunityNOTE 4 |
| Little Traverse Bay Bands of Odawa Indians | Little Traverse Bay Bands of Odawa Indians  //  Little Traverse Bay Bands of Odawa IndiansNOTE 3 |

### 17. Platform provider (brand) label changes across sheets for the same operator

**Count: 10.** Some are real changes of partner, some are renamings; the file does not say which or when within a year.

| Operator | Labels found |
|---|---|
| Grand Traverse Band of Ottawa and Chippewa Indians | William Hill  //  Caesars/WSOP |
| Greektown Casino | Penn Sports Interactive / Barstool Sportsbook  //  theScore Bet |
| Gun Lake Band Tribal Community | Parx Interactive  //  BetPARX |

### 18. Casino Name written more than one way for the same operator

**Count: 0.** 

### 19. The tax column has two different labels

**Count: 2.** The label, which contains a line break in the file, tells commercial operators (state tax, 5.88%) from tribal operators (state payment, 8.4%): "Internet Sports Betting State Payment (8.4%)" on 1,560 cells; "Internet Sports Betting State Tax (5.88%)" on 396 cells.

### 20. Launch date stored as the wrong type

**Count: 7.** Stored as a spreadsheet day number in text (for example 44218, which is 2021-01-22). Cells that are not a number at all: 1 (7/12/2021 Note 4). Operators whose launch cell differs between sheets: 1.

| Operator | Launch cells found |
|---|---|
| Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) | 7/12/2021 Note 4  //  44389 |

### 21. Sheets that do not have a column block for every operator

**Count: 2.** Operator blocks per sheet: 2023 = 15, 2024 = 15, 2024 = 15, 2025 = 15, 2025 = 15, 2026 = 15, 2022 = 15, 2023 = 15, 2021 = 14, 2022 = 15, 2021 = 14. The operator missing from the 2021 sheets: Soaring Eagle Gaming.

### 22. A partial first month

**Count: 11.** January 2021 covers only the days from launch to month end. Workbook note: "Internet Sports Betting Operators were authorized to begin operations on January 22, 2021. January 2021 figures reflect revenues earned from the Operator's launch date through the end of the month." Operators that launched later also have a partial first month.

### 23. Months where the operators do not add up to the published all-operator total

**Count: 0.** Checked 132 sheet-months for handle, gross receipts and adjusted gross receipts (tolerance 50 cents).

### 24. Operator blocks whose twelve months do not add up to the block's Total row

**Count: 1.** Checked 163 operator blocks (tolerance 50 cents).

| Sheet | Operator | Sum of months, handle | Total row, handle | Sum of months, tax | Total row, tax |
|---|---|---|---|---|---|
| Internet Sports Betting 2024 | Sault Ste. Marie Tribe of Chippewa Indians | 467,815.08 | blank | 686.24 | 686.24 |

### 25. Columns the publisher does not define

**Count: 1.** "Total Handle" is not defined on the download page or in the workbooks. Gross and adjusted gross sports betting receipts are defined in state law (MCL 432.403); the tax and payment rates are in workbook Note 2 and MCL 432.414 and 432.407. There is no column for free play: it has to be derived as gross receipts minus adjusted gross receipts.

## 4. Notes printed in the workbooks

These are the publisher's own notes, copied from the bottom of the sheets, with the sheet years each appears on.

| Label | Note | On sheets for |
|---|---|---|
| * | As reported by operator | 2021, 2022, 2023, 2024, 2025, 2026 |
| ** | As of June 2026, not all revenue amounts have been subjected to audit or review. | 2026 |
| Note 1: | Internet Sports Betting Operators were authorized to begin operations on January 22, 2021. January 2021 figures reflect revenues earned from the Operator's launch date through the end of the month. | 2021 |
| Note 1: | Internet Sports Betting tax/payment percentages are 8.4% of Adjusted Gross Sports Betting Receipts. Tribal Operators pay the full 8.4% to the State, while Commercial Operators pay 70% to the State and 30% to the City of Detroit. | 2022, 2023, 2024, 2025, 2026 |
| Note 2: | Internet Sports Betting tax/payment percentages are 8.4% of Adjusted Gross Sports Betting Receipts. Tribal Operators pay the full 8.4% to the State, while Commercial Operators pay 70% to the State and 30% to the City of Detroit. | 2021 |
| Note 2: | The information reported in this spreadsheet represents Internet Sports Betting numbers only, and does not include any information from Retail Sports Betting conducted by the Detroit or Tribal casinos. | 2022, 2023, 2024, 2025, 2026 |
| Note 3: | The information reported in this spreadsheet represents Internet Sports Betting numbers only, and does not include any information from Retail Sports Betting conducted by the Detroit or Tribal casinos. | 2021 |
| Note 3: | Little Traverse Bay Bands of Odawa Indians/FoxBet ceased their offering of Internet Sports Betting in Michigan in August 2023. | 2023, 2024, 2025 |
| Note 3: | Little Traverse Bay Bands of Odawa Indians/FoxBet ceased their offering of Internet Sports Betting in Michigan in August 2023. In April 2026 Internet Sports Betting was resumed under the Bet365 platform. | 2026 |
| Note 4: | Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino) was approved for a soft launch with limited play for VIP's in June 2021, official launch to the public was July 12, 2021. | 2021 |
| Note 4: | Keweenaw Bay Indian Community ceased offering Internet Sports Betting in February 2024 | 2024, 2025, 2026 |
| Note 5: | Sault Ste. Marie ceased offering Internet Sports Betting in April 2024 | 2024, 2025, 2026 |
| Note 6: | Hannahville ceased offering Internet Sports Betting in July 2025 and resumed in December 2025 | 2025 |

