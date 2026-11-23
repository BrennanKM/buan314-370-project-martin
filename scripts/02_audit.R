# 02_audit.R
# Audit of the raw data before any cleaning (course Prompt 5.1).
# REPORT ONLY: fixes nothing, drops nothing, saves no data file.
#
# Reads:  data/raw/*.xlsx (through scripts/00_functions.R)
# Writes: documentation/data_audit.md

source(file.path("scripts", "00_functions.R"))
suppressPackageStartupMessages(library(tidyr))

raw    <- read_mgcb_raw()
blocks <- raw$blocks
notes  <- raw$notes

strip_note <- function(v) str_squish(str_remove(v, regex("\\s*note\\s*\\d+\\s*$", ignore_case = TRUE)))

month_rows <- blocks %>% filter(row_label != "Total") %>% mutate(month_num = match(row_label, month.name))
total_rows <- blocks %>% filter(row_label == "Total")

# All operator cells from every sheet, stacked as read (each year except the
# latest appears in two workbooks).
stacked <- month_rows %>% filter(block_type == "operator") %>% mutate(operator_key = strip_note(operator_raw))

# For profiling only: one copy of each year, taken from the newest workbook
# that carries it. This is a view in memory, not a cleaning step.
view <- stacked %>% group_by(sheet_year) %>% filter(file_year == max(file_year)) %>% ungroup() %>%
  mutate(deductions = gross - adjusted,
         rate = if_else(str_detect(tax_label_raw, "8\\.4"), 0.084, 0.0588),
         tax_expected = rate * adjusted)
active <- view %>% filter(!is.na(handle), handle > 0)

show_cols <- function(d, n = 3) {
  d %>% head(n) %>% transmute(
    Operator = operator_key, Year = sheet_year, Month = row_label,
    `Total Handle` = fmt(handle, 2), `Gross receipts` = fmt(gross, 2),
    `Adjusted gross receipts` = fmt(adjusted, 2), `Tax or payment` = fmt(tax, 2),
    Workbook = source_file)
}

# ---------------------------------------------------------------- profile ---
profile_num <- function(v, name) tibble(
  Column = name, Type = "number", `Share missing` = sprintf("%.1f%%", 100 * mean(is.na(v))),
  `Distinct values` = n_distinct(v, na.rm = TRUE),
  Minimum = fmt(min(v, na.rm = TRUE), 2), Median = fmt(median(v, na.rm = TRUE), 2),
  Mean = fmt(mean(v, na.rm = TRUE), 2), Maximum = fmt(max(v, na.rm = TRUE), 2), `Most common values (count)` = "")
profile_cat <- function(v, name, type = "text") {
  top <- sort(table(v), decreasing = TRUE)
  tibble(Column = name, Type = type, `Share missing` = sprintf("%.1f%%", 100 * mean(is.na(v))),
         `Distinct values` = n_distinct(v, na.rm = TRUE), Minimum = "", Median = "", Mean = "", Maximum = "",
         `Most common values (count)` = paste(sprintf("%s (%d)", str_trunc(str_squish(names(top)[seq_len(min(3, length(top)))]), 45), as.integer(top)[seq_len(min(3, length(top)))]), collapse = "; "))
}
profile <- bind_rows(
  profile_cat(view$sheet_year, "Year (from the sheet name)", "whole number used as a category"),
  profile_cat(view$row_label, "Month"),
  profile_cat(view$operator_raw, "Operators"),
  profile_cat(view$casino_raw, "Casino Name"),
  profile_cat(view$platform_raw, "Platform Providers"),
  profile_cat(view$launch_raw, "Initial date of Operation launch", "date stored as a spreadsheet day number in text"),
  profile_cat(view$tax_label_raw, "Label of the tax or payment column"),
  profile_num(view$handle, "Total Handle"),
  profile_num(view$gross, "Gross Sports Betting Receipts"),
  profile_num(view$adjusted, "Adjusted Gross Sports Betting Receipts"),
  profile_num(view$tax, "Internet Sports Betting State Tax / State Payment")
)

# --------------------------------------------------------------- problems ---
problems <- list()
add_problem <- function(title, count, detail, examples = NULL) {
  problems[[length(problems) + 1]] <<- list(title = title, count = count, detail = detail, examples = examples)
}

# 1. Same operator-month in two workbooks
pairs <- stacked %>% group_by(operator_key, sheet_year, month_num) %>% filter(n() > 1) %>% ungroup()
n_ids_twice <- pairs %>% distinct(operator_key, sheet_year, month_num) %>% nrow()
cmp <- pairs %>% select(operator_key, sheet_year, month_num, row_label, file_year, handle, gross, adjusted, tax) %>%
  pivot_longer(c(handle, gross, adjusted, tax), names_to = "column") %>%
  group_by(operator_key, sheet_year, month_num, row_label, column) %>%
  summarise(older = value[which.min(file_year)], newer = value[which.max(file_year)], .groups = "drop")
n_cells   <- nrow(cmp)
n_differ  <- sum(!is.na(cmp$older) & !is.na(cmp$newer) & abs(cmp$older - cmp$newer) > 0.005)
blank_one <- cmp %>% filter(xor(is.na(older), is.na(newer)))
add_problem(
  "The same operator-month appears in two workbooks",
  n_ids_twice,
  sprintf("Each yearly workbook also carries the prior year's sheet, so %s operator-months are present twice (%s cells compared). Cells where both copies hold a number and the numbers differ by more than half a cent: %d. Cells that are blank in one copy and filled in the other: %d.",
          fmt(n_ids_twice), fmt(n_cells), n_differ, nrow(blank_one)),
  blank_one %>% head(3) %>% transmute(Operator = operator_key, Year = sheet_year, Month = row_label, Column = column,
                                      `Older workbook` = if_else(is.na(older), "blank", fmt(older, 2)), `Newer workbook` = if_else(is.na(newer), "blank", fmt(newer, 2))))

dup_view <- sum(duplicated(view[c("operator_key", "sheet_year", "month_num")]))
add_problem("Duplicated operator-month identifiers once one copy of each year is taken", dup_view,
            "Identifier tested: operator, year, month, using the newest workbook for each year.")

# 2. Blank cells
blank <- view %>% filter(is.na(handle))
future <- blank %>% filter(sheet_year == max(view$sheet_year), month_num > max(active$month_num[active$sheet_year == max(view$sheet_year)]))
add_problem("Months not yet reported (blank)", nrow(future),
            sprintf("The %d sheet has rows for months after the last reported month (%s); they are blank for every operator.", max(view$sheet_year), month.name[max(active$month_num[active$sheet_year == max(view$sheet_year)])]),
            show_cols(future))
other_blank <- anti_join(blank, future, by = c("operator_key", "sheet_year", "month_num"))
add_problem("Other blank Total Handle cells", nrow(other_blank),
            "Blank (not zero) in the newest workbook for that year. By operator: " %>% paste0(paste(sprintf("%s %d", names(table(other_blank$operator_key)), as.integer(table(other_blank$operator_key))), collapse = "; "), "."),
            show_cols(other_blank))

# 3. Zero, negative and tiny handle
zero <- view %>% filter(handle == 0)
add_problem("Total Handle is exactly zero", nrow(zero),
            "Months before an operator launched or after it stopped. By operator: " %>% paste0(paste(sprintf("%s %d", names(table(zero$operator_key)), as.integer(table(zero$operator_key))), collapse = "; "), "."),
            show_cols(zero))
neg_handle <- view %>% filter(handle < 0)
add_problem("Total Handle is negative", nrow(neg_handle), "Dollars wagered cannot be negative; likely a correction entered after the operator stopped.", show_cols(neg_handle))
tiny <- active %>% filter(handle < 10000) %>% arrange(handle)
add_problem("Total Handle is above zero but under $10,000", nrow(tiny),
            "Real but tiny months. Any ratio that divides by handle (free play per $100 wagered, share kept) becomes extreme here.", show_cols(tiny))

# 4. Receipts
neg_gross <- active %>% filter(gross < 0) %>% arrange(gross)
add_problem("Gross Sports Betting Receipts is negative (active months)", nrow(neg_gross),
            "Possible in a month when winnings paid out exceed wagers taken, but worth seeing.", show_cols(neg_gross))
neg_ded <- active %>% filter(deductions < -0.005) %>% arrange(deductions)
add_problem("Adjusted receipts are larger than gross receipts (a negative deduction)", nrow(neg_ded),
            "By law adjusted receipts are gross receipts less free play, so the difference should not be negative.", show_cols(neg_ded))
neg_adj <- active %>% filter(adjusted < 0) %>% arrange(adjusted)
add_problem("Adjusted Gross Sports Betting Receipts is negative (active months)", nrow(neg_adj),
            sprintf("%.1f%% of active months. Free play deducted was larger than gross receipts.", 100 * nrow(neg_adj) / nrow(active)), show_cols(neg_adj))
lump <- active %>% filter(deductions > 0.25 * handle) %>% arrange(desc(deductions / handle))
add_problem("The deduction is more than a quarter of that month's handle", nrow(lump),
            "Consistent with free play being claimed in a later month as a lump (the Board's 18 July 2024 news release describes one such deduction), or with a tiny month.", show_cols(lump))

# 5. Tax or payment column
tax0_pos <- active %>% filter(adjusted > 0, tax == 0)
add_problem("Adjusted receipts are positive but the tax or payment is zero", nrow(tax0_pos),
            "Consistent with the rule that negative adjusted receipts are carried forward against later months; the file does not show the carried balance.", show_cols(tax0_pos))
tax_off <- active %>% filter(adjusted > 0, tax != 0, abs(tax - tax_expected) > 0.01)
add_problem("Tax or payment is neither zero nor the stated rate times adjusted receipts", nrow(tax_off),
            "Stated rate: 5.88% (commercial, state share) or 8.4% (tribal). A partial amount is what a carried-forward balance being used up would produce.",
            tax_off %>% head(3) %>% transmute(Operator = operator_key, Year = sheet_year, Month = row_label, `Adjusted gross receipts` = fmt(adjusted, 2), `Tax or payment` = fmt(tax, 2), `Rate times adjusted` = fmt(tax_expected, 2)))
tax_neg <- active %>% filter(tax < 0)
add_problem("Tax or payment is negative", nrow(tax_neg), "", show_cols(tax_neg))
tax_on_nonpos <- active %>% filter(adjusted <= 0, tax != 0)
add_problem("Tax or payment is not zero although adjusted receipts are zero or negative", nrow(tax_on_nonpos), "", show_cols(tax_on_nonpos))

# 6. Labels spelled more than one way
op_variants <- stacked %>% distinct(operator_key, operator_raw) %>% group_by(operator_key) %>% summarise(n = n(), labels = paste(unique(operator_raw), collapse = "  //  "), .groups = "drop") %>% filter(n > 1)
add_problem("Operator names written more than one way", nrow(op_variants),
            "A footnote marker is typed into the name on some sheets.", op_variants %>% head(3) %>% transmute(Operator = operator_key, `Labels found` = labels))
pl_variants <- stacked %>% distinct(operator_key, platform_raw) %>% group_by(operator_key) %>% summarise(n = n(), labels = paste(unique(platform_raw), collapse = "  //  "), .groups = "drop") %>% filter(n > 1)
add_problem("Platform provider (brand) label changes across sheets for the same operator", nrow(pl_variants),
            "Some are real changes of partner, some are renamings; the file does not say which or when within a year.", pl_variants %>% head(3) %>% transmute(Operator = operator_key, `Labels found` = labels))
casino_variants <- stacked %>% distinct(operator_key, casino_raw) %>% group_by(operator_key) %>% summarise(n = n(), labels = paste(unique(casino_raw), collapse = "  //  "), .groups = "drop") %>% filter(n > 1)
add_problem("Casino Name written more than one way for the same operator", nrow(casino_variants), "", casino_variants %>% head(3) %>% transmute(Operator = operator_key, `Labels found` = labels))
tax_labels <- stacked %>% count(label = str_squish(tax_label_raw))
add_problem("The tax column has two different labels", nrow(tax_labels),
            paste0("The label, which contains a line break in the file, tells commercial operators (state tax, 5.88%) from tribal operators (state payment, 8.4%): ", paste(sprintf("\"%s\" on %s cells", tax_labels$label, fmt(tax_labels$n)), collapse = "; "), "."))

# 7. Dates and types
launch <- stacked %>% distinct(operator_key, launch_raw)
launch_text <- launch %>% filter(is.na(suppressWarnings(as.numeric(launch_raw))))
launch_multi <- launch %>% group_by(operator_key) %>% summarise(n = n(), values = paste(launch_raw, collapse = "  //  "), .groups = "drop") %>% filter(n > 1)
add_problem("Launch date stored as the wrong type", n_distinct(launch$launch_raw),
            sprintf("Stored as a spreadsheet day number in text (for example 44218, which is 2021-01-22). Cells that are not a number at all: %d (%s). Operators whose launch cell differs between sheets: %d.",
                    nrow(launch_text), paste(unique(launch_text$launch_raw), collapse = "; "), nrow(launch_multi)),
            launch_multi %>% head(3) %>% transmute(Operator = operator_key, `Launch cells found` = values))
by_sheet <- stacked %>% distinct(source_file, sheet, operator_key) %>% count(source_file, sheet, name = "operators")
add_problem("Sheets that do not have a column block for every operator", sum(by_sheet$operators < max(by_sheet$operators)),
            paste0("Operator blocks per sheet: ", paste(sprintf("%s = %d", str_extract(by_sheet$sheet, "\\d{4}"), by_sheet$operators), collapse = ", "), ". The operator missing from the 2021 sheets: ",
                   paste(setdiff(unique(stacked$operator_key), unique(stacked$operator_key[stacked$sheet_year == 2021])), collapse = ", "), "."))
first_note <- notes %>% filter(str_detect(coalesce(text, ""), "January 2021 figures"))
add_problem("A partial first month", nrow(view %>% filter(sheet_year == 2021, month_num == 1, !is.na(handle), handle > 0)),
            paste0("January 2021 covers only the days from launch to month end. Workbook note: \"", str_squish(first_note$text[1]), "\" Operators that launched later also have a partial first month."))

# 8. Internal cross-checks
all_ops <- month_rows %>% filter(block_type == "all_operators") %>% select(source_file, sheet, month_num, pub_handle = handle, pub_gross = gross, pub_adjusted = adjusted, pub_tax = tax)
sums <- stacked %>% group_by(source_file, sheet, month_num) %>% summarise(across(c(handle, gross, adjusted, tax), ~ sum(.x, na.rm = TRUE)), any_data = any(!is.na(handle)), .groups = "drop") %>%
  inner_join(all_ops, by = c("source_file", "sheet", "month_num")) %>% filter(any_data)
check_tot <- sums %>% mutate(d_handle = abs(handle - pub_handle), d_gross = abs(gross - pub_gross), d_adjusted = abs(adjusted - pub_adjusted))
n_month_checks <- nrow(check_tot)
bad_tot <- check_tot %>% filter(d_handle > 0.5 | d_gross > 0.5 | d_adjusted > 0.5)
add_problem("Months where the operators do not add up to the published all-operator total", nrow(bad_tot),
            sprintf("Checked %d sheet-months for handle, gross receipts and adjusted gross receipts (tolerance 50 cents).", n_month_checks),
            bad_tot %>% head(3) %>% transmute(Sheet = sheet, Month = month.name[month_num], `Sum of operators, handle` = fmt(handle, 2), `Published total, handle` = fmt(pub_handle, 2), `Sum, adjusted` = fmt(adjusted, 2), `Published, adjusted` = fmt(pub_adjusted, 2)))
tot_chk <- month_rows %>% filter(block_type == "operator") %>% group_by(source_file, sheet, block_column) %>%
  summarise(across(c(handle, gross, adjusted, tax), ~ sum(.x, na.rm = TRUE)), .groups = "drop") %>%
  inner_join(total_rows %>% select(source_file, sheet, block_column, operator_raw, t_handle = handle, t_gross = gross, t_adjusted = adjusted, t_tax = tax), by = c("source_file", "sheet", "block_column"))
bad_row <- tot_chk %>% filter(abs(handle - coalesce(t_handle, 0)) > 0.5 | abs(gross - coalesce(t_gross, 0)) > 0.5 | abs(adjusted - coalesce(t_adjusted, 0)) > 0.5 | abs(tax - coalesce(t_tax, 0)) > 0.5)
add_problem("Operator blocks whose twelve months do not add up to the block's Total row", nrow(bad_row),
            sprintf("Checked %d operator blocks (tolerance 50 cents).", nrow(tot_chk)),
            bad_row %>% head(3) %>% transmute(Sheet = sheet, Operator = strip_note(operator_raw), `Sum of months, handle` = fmt(handle, 2), `Total row, handle` = fmt(t_handle, 2), `Sum of months, tax` = fmt(tax, 2), `Total row, tax` = fmt(t_tax, 2)))

# 9. Documentation gaps
add_problem("Columns the publisher does not define", 1,
            "\"Total Handle\" is not defined on the download page or in the workbooks. Gross and adjusted gross sports betting receipts are defined in state law (MCL 432.403); the tax and payment rates are in workbook Note 2 and MCL 432.414 and 432.407. There is no column for free play: it has to be derived as gross receipts minus adjusted gross receipts.")

# ------------------------------------------------------------------ write ---
note_tbl <- notes %>% mutate(text = str_squish(coalesce(text, "")), label = coalesce(label, "")) %>% filter(text != "") %>%
  group_by(label, text) %>% summarise(sheets = paste(sort(unique(str_extract(sheet, "\\d{4}"))), collapse = ", "), .groups = "drop") %>% arrange(label, sheets)

out <- c(
  "# Data audit",
  "",
  "What the raw data looked like before any cleaning (course Prompt 5.1). **Report only: nothing was fixed, dropped or saved as data.** This file is written by `scripts/02_audit.R`; do not edit it by hand.",
  "",
  "## 1. What was read",
  "",
  sprintf("- %d workbooks, %d sheets. Each workbook holds one sheet for its own year and (except the first) one for the prior year.", n_distinct(blocks$source_file), n_distinct(paste(blocks$source_file, blocks$sheet))),
  "- Layout: wide. Column 1 holds the row labels. Each operator has a block of four columns (Total Handle, Gross Sports Betting Receipts, Adjusted Gross Sports Betting Receipts, state tax or payment). Rows above the months hold the operator, casino name, platform provider and launch date. After the operators come an all-operator total block and one city-tax column for the commercial operators.",
  "- One row of the data, once reshaped, is **one licensed operator in one month**, identified by operator, year and month.",
  sprintf("- Operator-month cells read from all sheets, stacked: **%s**.", fmt(nrow(stacked))),
  sprintf("- Taking one copy of each year from the newest workbook that carries it: **%s** operator-months, %d operators, sheet years %d to %d.", fmt(nrow(view)), n_distinct(view$operator_key), min(view$sheet_year), max(view$sheet_year)),
  sprintf("- Of those %s: Total Handle is blank in %d, exactly zero in %d, negative in %d, and above zero in **%d**.", fmt(nrow(view)), sum(is.na(view$handle)), sum(view$handle == 0, na.rm = TRUE), sum(view$handle < 0, na.rm = TRUE), nrow(active)),
  sprintf("- First month with wagering: %s %d. Last: %s %d.", month.name[min(active$month_num[active$sheet_year == min(active$sheet_year)])], min(active$sheet_year), month.name[max(active$month_num[active$sheet_year == max(active$sheet_year)])], max(active$sheet_year)),
  "- Columns in the workbooks that are not about one operator: the all-operator total block (used below only as a cross-check) and \"City Wagering Taxes and Municipal Service Fees\" under \"Commercial Operators\".",
  "",
  "## 2. Column profile",
  "",
  sprintf("Profiled on the %s operator-months (one copy of each year). Numbers are dollars.", fmt(nrow(view))),
  "",
  md_table(profile),
  "",
  "## 3. Problems found",
  "",
  "Each problem has a count and up to three example rows. A count of 0 means the check was run and found nothing.",
  ""
)
summary_tbl <- tibble(`#` = seq_along(problems), Problem = map_chr(problems, "title"), Count = map_chr(problems, ~ fmt(.x$count)))
out <- c(out, md_table(summary_tbl), "")
for (i in seq_along(problems)) {
  p <- problems[[i]]
  out <- c(out, sprintf("### %d. %s", i, p$title), "", sprintf("**Count: %s.** %s", fmt(p$count), p$detail), "")
  if (!is.null(p$examples) && nrow(p$examples) > 0) out <- c(out, md_table(p$examples), "")
}
out <- c(out,
  "## 4. Notes printed in the workbooks",
  "",
  "These are the publisher's own notes, copied from the bottom of the sheets, with the sheet years each appears on.",
  "",
  md_table(note_tbl %>% transmute(Label = label, Note = text, `On sheets for` = sheets)),
  "")
writeLines(out, file.path("documentation", "data_audit.md"))

message("02_audit: wrote documentation/data_audit.md")
message(sprintf("  stacked cells %d | one copy per year %d | blank %d | zero %d | negative %d | active %d | problems listed %d",
                nrow(stacked), nrow(view), sum(is.na(view$handle)), sum(view$handle == 0, na.rm = TRUE), sum(view$handle < 0, na.rm = TRUE), nrow(active), length(problems)))
