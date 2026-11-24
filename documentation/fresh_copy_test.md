# Fresh-copy test

Course Prompt 9.3, run by the AI assistant on 2026-11-24. The question: does the repository on GitHub, by itself, reproduce every output?

## What was done

1. A fresh copy of `github.com/BrennanKM/buan314-370-project-martin` was downloaded into a new temporary folder outside the project.
2. Following the README: the six raw workbooks were placed in `data/raw`, `renv::restore()` installed the packages from the lockfile into the copy's own library, and `Rscript scripts/run_all.R` ran.
3. Every output file of the copy was compared with the same file in the project, byte for byte (PDF files also with the creation date they store set aside).

One thing was copied from the working folder into the fresh copy, and the README step it stands in for is a manual one: the six raw workbooks. The State's site terms do not allow a script to download them, so the README has the reader download them by hand. For the test they were copied from the project's `data/raw`. The first script in the run checks each against its recorded checksum, and all six matched. Nothing else was copied.

## First run (commit 8837c27): failed

The copy ran from start to finish with no edits (38 packages restored, 13 scripts, 13.5 seconds, number audit clean). The comparison:

| Kind of output | Files | Result |
|---|---|---|
| Processed data, tables, generated documentation, web page and its data, LaTeX numbers and tables | 63 | identical |
| Figures as PDF | 19 | identical except the creation date stored inside the file |
| Figures as PNG | 10 | **different** |

Problem list (one problem): all 10 PNG figures differed in their bytes. Same picture, same size in pixels, different drawing. Cause: the plotting function picks the `ragg` drawing package when it happens to be installed and another one when it is not. The project's library had `ragg` (it came with the tidyverse install); the lockfile did not list it, because no script named it, so the fresh copy did not have it.

## Fix

`scripts/00_style.R` now names the PNG drawing package (`ragg`) in `save_figure`, and `renv.lock` records it with the three packages it needs (commit 20d26b7). The PNG files in the project did not change.

## Second run (commit 20d26b7): passed

A second fresh copy, same steps: 42 packages restored, 13 scripts in 13.7 seconds, 11 of 11 data tests passed, number audit clean (0 mismatches, 0 without a source).

| Kind of output | Files | Result |
|---|---|---|
| Processed data (`data/processed`) | 1 | identical |
| Tables (`output/tables`) | 41 | identical |
| Figures as PNG (`output/figures`) | 10 | identical |
| Figures as PDF (`output/figures` and the copies in `report/static/figures`) | 19 | identical except the creation date stored inside the file |
| Web page and its data (`docs/index.html`, `output/page_data.json`, `output/palette.json`) | 3 | identical |
| LaTeX numbers and tables (`report/static`) | 12 | identical |
| Generated documentation (audit, wrangling log, codebook, codebook rules, checksum record, number audit) | 6 | identical |
| **Total** | **92** | **73 identical; 19 identical except a stored date; 0 different; 0 missing** |

File-by-file list: `output/tables/fresh_copy_comparison.csv`.

## What this test does not show

- It ran on the same computer as the project (same R, same operating system). A different computer has not been tried.
- The raw workbooks were copied, not downloaded again. The publisher revises the current year's workbook as months are added, so a later download of the 2026 file will not match its checksum (the README says so).
- PDF figures carry the time they were made, so they can never be byte-identical from one run to the next.
- The static report was not compiled in the copy (no LaTeX on this computer).
- It was run by the same assistant that built the project. The final gate repeats it with an independent checker after Brennan's writing pass.

## The temporary folder

Deleted on 2026-11-24 at 12:12 PT, after Brennan said to ("Yes, delete it"). It held the two fresh copies and four log files, about 310 MB. The file-by-file comparison is kept in `output/tables/fresh_copy_comparison.csv`.
