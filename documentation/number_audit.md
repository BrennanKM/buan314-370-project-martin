# Number audit

Written by `scripts/10_number_audit.R` each time the master script runs. It changes nothing in either report. The full list, one line per number, is `output/tables/number_audit.csv`.

How to read it: a number that comes from the analysis is never typed. The static report reads it as `\V{key}` and the web page holds it in an element marked `data-n`. Both are filled from `output/tables/report_numbers.csv`, which names the file and cell behind each value. Digits that are typed must be on a short list of things that are not results (years, the $100 unit, course numbers, band labels, Brennan's recorded expectations).

| Where | Numbers read from a results file | Typed, allowed (not results) | Mismatches | No source |
|---|---|---|---|---|
| Static report (`report/static/sections`) | 240 | 45 | 0 | 0 |
| Web page (`docs/index.html`) | 100 | 17 | 0 | 0 |
| Figure titles (`documentation/figure_titles.csv`) | 22 | 9 | 0 | 0 |

## List 1: numbers that do not match their source

- (none)

## List 2: numbers with no source

- (none)

## The web page as one file

- Size: 129,825 bytes.
- Things the page loads from outside itself: none.
- Report figures with no chart in the page: none (all 9 are drawn by the page's own JavaScript; the page contains no image).
- Figure titles not used in the page: none (all 9 titles are the same strings the figure scripts use).

Not checked by this script, checked by hand in a browser on 2026-11-24: that every chart draws, that the interactions respond, that the explorer's numbers equal `output/tables/explorer_checks.csv`, and that nothing runs off the screen at phone width.

## Typed numbers that are allowed, and why

| Number | Why it is not a result |
|---|---|
| 2021 | year |
| 2022 | year |
| 2023 | year |
| 2024 | year |
| 2025 | year |
| 2026 | year |
| 100 | the unit: free play per $100 wagered |
| 314-370 | course number |
| 314 | course number |
| 370 | course number |
| 381 | course number (BUAN 381) |
| 22 | date: internet sports betting began on 22 January 2021 (provenance record) |
| 23 | date of download, 23 November 2026 (provenance record) |
| 24 | date of this draft, 24 November 2026 |
| 1 | a label: the $1 band, $1 more, $1 million, or the coding 1 = yes |
| 0 | a label: the coding 0 = no, or the range 0 to 1 |
| 10 | Brennan's recorded expectation (under 10%), authored/eda_expectations.md |
| 50 | Brennan's recorded expectation (50% to 70%), authored/eda_expectations.md |
| 70 | Brennan's recorded expectation (50% to 70%), authored/eda_expectations.md |
| 5.2 | name of the AI model (Claude Fable 5.2) |
| 16 | a step number in the wrangling log (16a, 16b) |
| 20 | a label on a control of the page (the $0 to $20 frame) |
