# Data provenance record

Where the data came from (Part 4). Every field is backed by a quote or pointer to the publisher's page. A field that cannot be supported reads `UNVERIFIED` until Brennan settles it himself.

Status on 2026-11-23: Brennan downloaded the six workbooks by hand at 14:00 PT. Checksums are recorded in `documentation/raw_file_checksums.csv` and checked by `scripts/01_verify_raw.R`. Three fields are still UNVERIFIED (listed at the bottom) and are Brennan's to settle.

| Field | Value | Support (quote or pointer, with address) |
|---|---|---|
| Source and publisher | "Internet Sports Betting Revenues and Taxes", six yearly Excel workbooks (2021 to 2026). Publisher: Michigan Gaming Control Board, State of Michigan. | Page title "Revenues and Wagering Tax Information"; section heading "Internet Sports Betting Revenues and Taxes Downloads". https://www.michigan.gov/mgcb/detroit-casinos/resources/revenues-and-wagering-tax-information |
| Address and date | Page: the address above. Files: the six "Excel" links under that heading, one per year. Downloaded 2026-11-23 at 14:00 Pacific time (the files' creation times run from 14:00:14 to 14:00:23). The download record kept by macOS for each file names the publisher's file address and this page as where it came from. | File addresses are of the form `https://www.michigan.gov/mgcb/-/media/Project/Websites/mgcb/Detroit-Casino-Revenue-Files/<file name>.xlsx`. The browser saves four of the files with spaces where the address has hyphens; the saved names are the ones listed in `scripts/01_verify_raw.R`. |
| Version | UNVERIFIED. The page shows no "last updated" date. The 2026 workbook's footnote reads "As of June 2026, not all revenue amounts have been subjected to audit or review." while the sheet holds data through October 2026. | Footnote in the 2026 workbook (seen in a screening copy; to be re-read in the project file) |
| License and citation | No license is stated for the data. The site terms say: "You may not modify, copy, distribute, display, reproduce, publish, license, create derivative works from, sell, or transfer information, products, services, images, designs, or logos obtained from Michigan.gov unless the law otherwise provides or the State gives you prior written permission." and "You specifically agree not to access [...] any of the website through any automated means (including, but not limited to, use of scripts, web crawlers or screen scrapers)". Citation form asked for by the publisher: UNVERIFIED (none found). | https://www.michigan.gov/som/footer/policies , section dated "Updated: December 2021" |
| How obtained | By hand, in a web browser (scripted download is not allowed by the site terms). Steps: (1) open the page address above; (2) scroll to "Internet Sports Betting Revenues and Taxes Downloads"; (3) click "Excel" next to each year from 2026 down to 2021; (4) move the six .xlsx files into `data/raw` without opening or renaming them; (5) run `scripts/01_verify_raw.R`, which compares each file with the recorded checksum. Downloaded by: Brennan Martin. The files are not stored in this repository because the site terms do not allow republishing. | Course Prompt 4.1 allows recorded manual steps when a script is not possible |
| What it covers | One row (after reshaping) is one licensed internet sports betting operator in one month. Population: every operator licensed for internet sports betting in Michigan (3 commercial Detroit casinos and 12 tribal operators). Period: January 2021 to October 2026. Retail sports betting is not included. Collected from operators' monthly reports to the Board. | Workbook note: "The information reported in this spreadsheet represents Internet Sports Betting numbers only, and does not include any information from Retail Sports Betting". Reporting duty: MCL 432.416a(1), https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-432-416a . Page text: "Internet sports betting and internet gaming began in Michigan on Jan. 22, 2021." |
| Known limits | Figures are "As reported by operator" and not all are audited. There is no free-play column; it is derived as gross receipts minus adjusted gross receipts. A sportsbook can take a free-play deduction in a later month than the promotion. Three operators stopped offering internet sports betting (August 2023, February 2024, April 2024); one resumed in April 2026 under a different platform. Platform (brand) labels change across years. | Workbook notes 3 to 5 and footnotes; Board news release of 18 July 2024, https://content.govdelivery.com/accounts/MIGCB/bulletins/3a92995 ; MCL 432.403(a), https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-432-403 |

## File facts

Written from `output/tables/raw_file_facts.csv` after `scripts/01_verify_raw.R` runs on the hand-downloaded files.

| File name | Size (bytes) | Checksum (SHA-256) | Sheets (rows x columns) | Downloaded (date, time) | Downloaded by |
|---|---|---|---|---|---|
| Internet_Sports_Betting_revenue_716520_7.xlsx | 44,190 | `d6316ddbcc393883d81226b6f76f5e1a66d5f8774078ea429d9eaf058988f5eb` | Internet Sports Betting 2021 (25 x 62) | 2026-11-23, 14:00 PT | Brennan Martin, in a web browser |
| Internet_Sports_Betting_-_January_2022_748264_7.xlsx | 81,063 | `769f2553ad13990b795aca4ca0cf7dea504b34f47b70982afc7caf83b81228b2` | Internet Sports Betting 2022 (23 x 66); Internet Sports Betting 2021 (25 x 62) | 2026-11-23, 14:00 PT | Brennan Martin, in a web browser |
| Internet Sports Betting January 2023.xlsx | 83,491 | `91d36cf1dcefe15ab09223451667bdcbdf26540c8c468aa19cc275977928af4e` | Internet Sports Betting 2023 (24 x 66); Internet Sports Betting 2022 (23 x 66) | 2026-11-23, 14:00 PT | Brennan Martin, in a web browser |
| Internet Sports Betting - 2024.xlsx | 81,837 | `38debc4d364e170a3d667449923b8d7c30718187ac9b3f902a75ab3d8a1ba942` | Internet Sports Betting 2024 (26 x 66); Internet Sports Betting 2023 (24 x 66) | 2026-11-23, 14:00 PT | Brennan Martin, in a web browser |
| Internet Sports Betting - 2025.xlsx | 80,758 | `88e3f9f37773e6012422c5493752ad020fd478611ab177e5467ceed073efb6b0` | Internet Sports Betting 2025 (27 x 66); Internet Sports Betting 2024 (26 x 66) | 2026-11-23, 14:00 PT | Brennan Martin, in a web browser |
| Internet Sports Betting - 2026.xlsx | 78,918 | `91fe4790a95ce3c609bc7b34ca589ef7e58c6baaaeaaacb7af53b7173f74470f` | Internet Sports Betting 2026 (27 x 66); Internet Sports Betting 2025 (27 x 66) | 2026-11-23, 14:00 PT | Brennan Martin, in a web browser |

## Row and column counts against the publisher

| File | Rows found | Rows stated by publisher | Difference explained |
|---|---|---|---|
| All six workbooks | 1,956 operator-month cells across 11 sheets; 1,068 after taking one copy of each year; 923 with dollars wagered above zero (`documentation/data_audit.md`, section 1) | Not stated: the publisher gives no row count | Nothing to compare against. Internal check instead: in all 132 sheet-months the operators add up to the publisher's own all-operator total (audit, problem 23). |

## Fields marked UNVERIFIED

| Field | Where to look to settle it | Settled by | Date |
|---|---|---|---|
| Version | Look for a date on the page or in each workbook's footnotes; the Board's monthly news releases give the reporting month | | |
| Citation form | The site's policies page and the Board's contact page; if none is given, a standard citation with the page address and access date | | |
| The statute and site-terms quotes in this record | Open each address in a browser and compare the quoted sentence | | |
