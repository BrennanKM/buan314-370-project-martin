# Data provenance record

Where the data came from (Part 4). Every field is backed by a quote or pointer to the publisher's page. A field that cannot be supported reads `UNVERIFIED` until Brennan settles it himself.

Status on 2026-11-23: source chosen (decision D-016). **The raw files have not been downloaded for the project yet**, so the download date, file facts and checksums are still empty.

| Field | Value | Support (quote or pointer, with address) |
|---|---|---|
| Source and publisher | "Internet Sports Betting Revenues and Taxes", six yearly Excel workbooks (2021 to 2026). Publisher: Michigan Gaming Control Board, State of Michigan. | Page title "Revenues and Wagering Tax Information"; section heading "Internet Sports Betting Revenues and Taxes Downloads". https://www.michigan.gov/mgcb/detroit-casinos/resources/revenues-and-wagering-tax-information |
| Address and date | Page: the address above. Files: the six "Excel" links under that heading, one per year. Download date and time: *pending Brennan's download* | The six file names are listed in `scripts/01_verify_raw.R` |
| Version | UNVERIFIED. The page shows no "last updated" date. The 2026 workbook's footnote reads "As of June 2026, not all revenue amounts have been subjected to audit or review." while the sheet holds data through October 2026. | Footnote in the 2026 workbook (seen in a screening copy; to be re-read in the project file) |
| License and citation | No license is stated for the data. The site terms say: "You may not modify, copy, distribute, display, reproduce, publish, license, create derivative works from, sell, or transfer information, products, services, images, designs, or logos obtained from Michigan.gov unless the law otherwise provides or the State gives you prior written permission." and "You specifically agree not to access [...] any of the website through any automated means (including, but not limited to, use of scripts, web crawlers or screen scrapers)". Citation form asked for by the publisher: UNVERIFIED (none found). | https://www.michigan.gov/som/footer/policies , section dated "Updated: December 2021" |
| How obtained | By hand, in a web browser (scripted download is not allowed by the site terms). Steps: (1) open the page address above; (2) scroll to "Internet Sports Betting Revenues and Taxes Downloads"; (3) click "Excel" next to each year from 2026 down to 2021; (4) move the six .xlsx files into `data/raw` without opening or renaming them; (5) run `scripts/01_verify_raw.R`, which compares each file with the recorded checksum. Downloaded by: *pending* | Course Prompt 4.1 allows recorded manual steps when a script is not possible |
| What it covers | One row (after reshaping) is one licensed internet sports betting operator in one month. Population: every operator licensed for internet sports betting in Michigan (3 commercial Detroit casinos and 12 tribal operators). Period: January 2021 to October 2026. Retail sports betting is not included. Collected from operators' monthly reports to the Board. | Workbook note: "The information reported in this spreadsheet represents Internet Sports Betting numbers only, and does not include any information from Retail Sports Betting". Reporting duty: MCL 432.416a(1), https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-432-416a . Page text: "Internet sports betting and internet gaming began in Michigan on Jan. 22, 2021." |
| Known limits | Figures are "As reported by operator" and not all are audited. There is no free-play column; it is derived as gross receipts minus adjusted gross receipts. A sportsbook can take a free-play deduction in a later month than the promotion. Three operators stopped offering internet sports betting (August 2023, February 2024, April 2024); one resumed in April 2026 under a different platform. Platform (brand) labels change across years. | Workbook notes 3 to 5 and footnotes; Board news release of 18 July 2024, https://content.govdelivery.com/accounts/MIGCB/bulletins/3a92995 ; MCL 432.403(a), https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-432-403 |

## File facts

Written from `output/tables/raw_file_facts.csv` after `scripts/01_verify_raw.R` runs on the hand-downloaded files.

| File name | Size (bytes) | Checksum (SHA-256) | Sheets | Downloaded (date, time) | Downloaded by |
|---|---|---|---|---|---|

## Row and column counts against the publisher

| File | Rows found | Rows stated by publisher | Difference explained |
|---|---|---|---|

## Fields marked UNVERIFIED

| Field | Where to look to settle it | Settled by | Date |
|---|---|---|---|
| Version | Look for a date on the page or in each workbook's footnotes; the Board's monthly news releases give the reporting month | | |
| Citation form | The site's policies page and the Board's contact page; if none is given, a standard citation with the page address and access date | | |
| The statute and site-terms quotes in this record | Open each address in a browser and compare the quoted sentence | | |
