# 03_clean.R
# Carries out the cleaning plan Brennan approved on 2026-11-23
# (documentation/cleaning_plan.md), in order, and nothing else.
# After every step it reports rows before and after. If a step affects a
# different number of rows or values than the plan predicted, it STOPS.
#
# Reads:  data/raw/*.xlsx (through scripts/00_functions.R)
# Writes: data/processed/mgcb_operator_months.csv
#         documentation/wrangling_log.md
#         output/tables/wrangling_steps.csv
# Never changes anything in data/raw.

source(file.path("scripts", "00_functions.R"))

steps <- list()
log_step <- function(step, what, why, before, after, expected_after = NULL, values = NA_character_) {
  if (!is.null(expected_after) && after != expected_after) {
    stop(sprintf("Step %s: expected %s rows after this step (approved plan) but got %s. Stopping; nothing was saved.",
                 step, fmt(expected_after), fmt(after)), call. = FALSE)
  }
  steps[[length(steps) + 1]] <<- tibble(step = step, what_changed = what, why = why,
                                        rows_before = before, rows_after = after, values_changed = values)
  message(sprintf("Step %-3s rows %s -> %s  %s", step, fmt(before), fmt(after), what))
}
expect_count <- function(step, what, found, expected) {
  if (found != expected) stop(sprintf("Step %s: the plan predicted %s %s but the data have %s. Stopping; nothing was saved.",
                                      step, fmt(expected), what, fmt(found)), call. = FALSE)
}

# ---- Step 1: reshape to one row per operator per month (no value changed) ----
raw <- read_mgcb_raw()$blocks
d <- raw %>% filter(block_type == "operator", row_label != "Total")
log_step("1", "Reshaped the wide workbooks to one row per operator per month. No value changed.",
         "One row must be one operator in one month.", nrow(d), nrow(d), 1956)

# ---- Step 2: one copy of each year, from the newest workbook that carries it ----
n0 <- nrow(d)
d <- d %>% group_by(sheet_year) %>% filter(file_year == max(file_year)) %>% ungroup()
log_step("2", "Kept each year's copy from the newest workbook that carries it; removed the duplicate copy.",
         "Every year except 2026 appears in two workbooks; the copies agree in every cell where both hold a number.", n0, nrow(d), 1068)

# ---- Step 3: months not yet reported ----
n0 <- nrow(d)
unreported <- d %>% group_by(sheet_year, row_label) %>% summarise(all_blank = all(is.na(handle) & is.na(gross) & is.na(adjusted) & is.na(tax)), .groups = "drop") %>% filter(all_blank)
d <- d %>% anti_join(unreported, by = c("sheet_year", "row_label"))
log_step("3", sprintf("Dropped months that are blank for every operator (%s).", paste(unreported$row_label, unreported$sheet_year, collapse = ", ")),
         "They have not been reported yet, so they are not observations.", n0, nrow(d), 1038)

# ---- Step 4: months with no wagering ----
n0 <- nrow(d)
no_wagering <- d %>% filter(is.na(handle) | handle == 0)
stray <- no_wagering %>% filter(coalesce(gross, 0) != 0 | coalesce(adjusted, 0) != 0 | coalesce(tax, 0) != 0)
if (nrow(stray) > 0) stop("Step 4: some no-wagering rows hold non-zero receipts or tax. Stopping.", call. = FALSE)
d <- d %>% filter(!is.na(handle), handle != 0)
log_step("4", sprintf("Dropped operator-months with no wagering: Total Handle zero (%d) or blank (%d). Receipts and tax are zero or blank in all of them.",
                      sum(no_wagering$handle == 0, na.rm = TRUE), sum(is.na(no_wagering$handle))),
         "The question is about sportsbooks that are operating; these are months before launch, after stopping, or paused.", n0, nrow(d), 924)

# ---- Step 5: negative Total Handle ----
n0 <- nrow(d)
neg <- d %>% filter(handle < 0)
d <- d %>% filter(handle > 0)
log_step("5", sprintf("Dropped the row with a negative Total Handle (%s, %s %d: %s).", str_squish(str_remove(neg$operator_raw, regex("\\s*note\\s*\\d+\\s*$", ignore_case = TRUE))), neg$row_label, neg$sheet_year, fmt(neg$handle, 2)),
         "A closing correction after the operator stopped, not a month of betting.", n0, nrow(d), 923)

# ---- Steps 10, 11, 12, 13, 17: names, labels, types (no rows affected) ----
short_names <- c(
  "MGM Grand Detroit" = "MGM Grand Detroit",
  "MotorCity Casino" = "MotorCity",
  "Greektown Casino" = "Greektown",
  "Bay Mills Indian Community" = "Bay Mills",
  "Nottawaseppi Huron Band of Pottawatomi Indians (FireKeepers Casino)" = "FireKeepers",
  "Grand Traverse Band of Ottawa and Chippewa Indians" = "Grand Traverse Band",
  "Gun Lake Band Tribal Community" = "Gun Lake",
  "Hannahville Indian Community" = "Hannahville",
  "Keweenaw Bay Indian Community" = "Keweenaw Bay",
  "Lac Vieux Desert Band of Lake Superior Chippewa Indians" = "Lac Vieux Desert",
  "Little River Band of Ottawa Indians" = "Little River Band",
  "Little Traverse Bay Bands of Odawa Indians" = "Little Traverse Bay Bands",
  "Pokagon Band of Potawatomi Indians" = "Pokagon Band",
  "Soaring Eagle Gaming" = "Soaring Eagle",
  "Sault Ste. Marie Tribe of Chippewa Indians" = "Sault Ste. Marie Tribe"
)
parse_launch <- function(v) {
  num <- suppressWarnings(as.numeric(v))
  out <- as.Date(num, origin = "1899-12-30")                       # spreadsheet day number
  txt <- is.na(num) & !is.na(v)
  out[txt] <- as.Date(str_extract(v[txt], "\\d{1,2}/\\d{1,2}/\\d{4}"), format = "%m/%d/%Y")
  out
}
n0 <- nrow(d)
labels_before <- n_distinct(d$operator_raw)
d <- d %>% mutate(
  operator          = str_squish(str_remove(operator_raw, regex("\\s*note\\s*\\d+\\s*$", ignore_case = TRUE))),
  operator_short    = unname(short_names[operator]),
  casino_name       = str_squish(casino_raw),
  platform_as_listed = str_squish(platform_raw),
  operator_type     = case_when(str_detect(tax_label_raw, "5\\.88") ~ "commercial", str_detect(tax_label_raw, "8\\.4") ~ "tribal"),
  launch_date       = parse_launch(launch_raw),
  year              = sheet_year,
  month             = match(row_label, month.name),
  month_name        = row_label,
  month_date        = as.Date(sprintf("%d-%02d-01", year, month))
)
if (anyNA(d$operator_short)) stop("An operator has no short name in the lookup. Stopping.", call. = FALSE)
if (anyNA(d$operator_type))  stop("An operator's type could not be read from the tax label. Stopping.", call. = FALSE)
if (anyNA(d$launch_date))    stop("A launch date could not be read. Stopping.", call. = FALSE)
launch_per_op <- d %>% distinct(operator, launch_date) %>% count(operator)
if (any(launch_per_op$n != 1)) stop("An operator has more than one launch date after conversion. Stopping.", call. = FALSE)
expect_count("10", "operator names after removing footnote markers", n_distinct(d$operator), 15)
latest <- d %>% group_by(operator) %>% filter(year == max(year)) %>% summarise(platform_latest = first(platform_as_listed), .groups = "drop")
d <- d %>% left_join(latest, by = "operator")
log_step("10", sprintf("Removed typed footnote markers from operator names (%d labels became %d names) and added a short name for figures.", labels_before, n_distinct(d$operator)),
         "One operator needs one name.", n0, nrow(d), 923)
log_step("11", "Kept the platform provider (brand) as printed on each year's sheet and added each operator's latest label as a second column.",
         "Brand labels change across years; the operator is the stable key.", n0, nrow(d), 923)
log_step("12", sprintf("Created operator type from the label of the tax column: commercial (%d rows), tribal (%d rows).", sum(d$operator_type == "commercial"), sum(d$operator_type == "tribal")),
         "Operator type is not a column in the file.", n0, nrow(d), 923)
log_step("13", "Converted the launch date from a spreadsheet day number in text to a date (one cell held text and reads as the same date as its other form).",
         "Wrong type in the file.", n0, nrow(d), 923)

# ---- Steps 7 and 15: kept as reported (recorded so the log is complete) ----
log_step("7", sprintf("No change: %d months with negative gross receipts kept as reported.", sum(d$gross < 0)),
         "A sportsbook can pay out more than it takes in a month.", n0, nrow(d), 923)
log_step("15", sprintf("No change: tax or payment kept as reported, including %d months with positive adjusted receipts and zero tax.", sum(d$adjusted > 0 & d$tax == 0)),
         "The reported figure is what was paid; it defines the yes-or-no target.", n0, nrow(d), 923)

# ---- Step 16: new variables ----
d <- d %>% arrange(operator, month_date) %>% mutate(
  gross_receipts          = gross,
  adjusted_gross_receipts = adjusted,
  state_tax_or_payment    = tax,
  free_play_deduction     = gross_receipts - adjusted_gross_receipts,
  free_play_per_100       = 100 * free_play_deduction / handle,
  kept_per_100            = 100 * gross_receipts / handle,
  paid_no_tax             = as.integer(state_tax_or_payment == 0),
  log10_handle            = log10(handle)
) %>% group_by(operator) %>% mutate(months_active = row_number()) %>% ungroup()
log_step("16a", "Created: month_date, free_play_deduction (gross minus adjusted receipts), free_play_per_100, kept_per_100, paid_no_tax, log10_handle, months_active.",
         "Needed by the problem statements; each is defined in the codebook.", n0, nrow(d), 923)

# ---- Step 9: flag lump deductions (computed from the reported values) ----
d <- d %>% mutate(lump_deduction = as.integer(free_play_deduction > 0.25 * handle))
expect_count("9", "months with a deduction above a quarter of handle", sum(d$lump_deduction), 21)
log_step("9", "Added the flag lump_deduction = 1 where the deduction is more than a quarter of that month's handle. No value changed.",
         "Free play can be claimed in a later month as a lump; the flag lets findings be checked with and without those months.", n0, nrow(d), 923, "21 rows flagged")

# ---- Step 14: flag each operator's first active month ----
d <- d %>% mutate(first_active_month = as.integer(months_active == 1))
expect_count("14", "first active months", sum(d$first_active_month), 15)
log_step("14", "Added the flag first_active_month = 1 for each operator's first month with wagering. No value changed.",
         "First months are partial (January 2021 starts on the 22nd).", n0, nrow(d), 923, "15 rows flagged")

# ---- Step 8: negative deductions set to missing ----
neg_ded <- which(d$free_play_deduction < -0.005)
expect_count("8", "months with a negative deduction", length(neg_ded), 2)
d$free_play_deduction[neg_ded] <- NA
d$free_play_per_100[neg_ded]   <- NA
log_step("8", "Kept the rows; set free_play_deduction and free_play_per_100 to missing where adjusted receipts exceed gross receipts.",
         "A negative amount is not free play and the file does not explain it.", n0, nrow(d), 923, "4 values set to missing (2 rows)")

# ---- Step 6: rates set to missing where handle is under $10,000 ----
tiny <- which(d$handle < 10000)
expect_count("6", "months with handle under $10,000", length(tiny), 2)
d$free_play_per_100[tiny] <- NA
d$kept_per_100[tiny]      <- NA
log_step("6", "Kept the rows; set free_play_per_100 and kept_per_100 to missing where Total Handle is under $10,000.",
         "Ratios on a few hundred dollars are not meaningful.", n0, nrow(d), 923, "4 values set to missing (2 rows)")

# ---- Step 16, continued: prior-month versions (after the blanking above) ----
d <- d %>% arrange(operator, month_date) %>% group_by(operator) %>% mutate(
  .has_prior = !is.na(lag(month_date)) & (year * 12 + month) - (lag(year) * 12 + lag(month)) == 1,
  prior_free_play_per_100 = if_else(.has_prior, lag(free_play_per_100), NA_real_),
  prior_kept_per_100      = if_else(.has_prior, lag(kept_per_100), NA_real_),
  prior_log10_handle      = if_else(.has_prior, lag(log10_handle), NA_real_),
  prior_paid_no_tax       = if_else(.has_prior, lag(paid_no_tax), NA_integer_)
) %>% ungroup()
expect_count("16", "rows whose previous calendar month is present for the same operator", sum(d$.has_prior), 906)
log_step("16b", sprintf("Created prior-month versions (prior_free_play_per_100, prior_kept_per_100, prior_log10_handle, prior_paid_no_tax), filled only when the operator's previous calendar month is in the data (%d of %d rows).", sum(d$.has_prior), nrow(d)),
         "Things known at the start of a month, for the predictive statement.", n0, nrow(d), 923)

# ---- Step 17: final columns, names and order ----
out <- d %>% transmute(
  operator, operator_short, operator_type, casino_name, platform_as_listed, platform_latest, launch_date,
  year, month, month_name, month_date,
  handle, gross_receipts, adjusted_gross_receipts, state_tax_or_payment,
  free_play_deduction, free_play_per_100, kept_per_100, paid_no_tax,
  log10_handle, months_active, first_active_month, lump_deduction,
  prior_free_play_per_100, prior_kept_per_100, prior_log10_handle, prior_paid_no_tax,
  source_file
) %>% arrange(operator, month_date)
log_step("17", sprintf("Gave columns plain lower-case names and fixed their order (%d columns). Dollar amounts are kept exactly as published, with no rounding.", ncol(out)),
         "Clear names; no value changed.", n0, nrow(out), 923)

if (any(duplicated(out[c("operator", "month_date")]))) stop("Duplicated operator-months in the processed data. Stopping.", call. = FALSE)

# ---- Write the processed file, the step table and the wrangling log ----
dir.create(file.path("data", "processed"), recursive = TRUE, showWarnings = FALSE)
write.csv(out, file.path("data", "processed", "mgcb_operator_months.csv"), row.names = FALSE, na = "")

step_tbl <- bind_rows(steps)
dir.create(file.path("output", "tables"), recursive = TRUE, showWarnings = FALSE)
write.csv(step_tbl, file.path("output", "tables", "wrangling_steps.csv"), row.names = FALSE, na = "")

removed <- step_tbl %>% filter(rows_after != rows_before)
accounting <- bind_rows(
  tibble(Stage = "Operator-month cells read from the raw workbooks (11 sheets)", Rows = fmt(step_tbl$rows_before[1])),
  removed %>% transmute(Stage = paste0("Less step ", step, ": ", what_changed), Rows = paste0("-", fmt(rows_before - rows_after))),
  tibble(Stage = "Rows in data/processed/mgcb_operator_months.csv", Rows = fmt(nrow(out)))
)
closes <- step_tbl$rows_before[1] - sum(removed$rows_before - removed$rows_after) == nrow(out)
if (!closes) stop("The row accounting does not close. Stopping.", call. = FALSE)

log_md <- c(
  "# Wrangling log",
  "",
  "One row per cleaning step, in the order the steps run. Written by `scripts/03_clean.R` each time it runs; do not edit by hand. Step numbers are those of the approved plan (`documentation/cleaning_plan.md`), which Brennan decided step by step on 2026-11-23 (questions Q-023 to Q-033). The script stops if any step affects a different number of rows or values than the plan predicted.",
  "",
  md_table(step_tbl %>% transmute(Step = step, `What changed` = what_changed, Why = why, `Rows before` = fmt(rows_before), `Rows after` = fmt(rows_after),
                                  `Values changed or flagged` = coalesce(values_changed, ""), Script = "scripts/03_clean.R", `Approved by Brennan` = "2026-11-23")),
  "",
  "## Row accounting",
  "",
  md_table(accounting),
  "",
  sprintf("The accounting closes: %s - %s = %s.", fmt(step_tbl$rows_before[1]), paste(fmt(removed$rows_before - removed$rows_after), collapse = " - "), fmt(nrow(out))),
  "",
  "No missing values were filled in, no values were capped or trimmed, and no row was dropped for having an extreme value.",
  ""
)
writeLines(log_md, file.path("documentation", "wrangling_log.md"))

message(sprintf("03_clean: wrote data/processed/mgcb_operator_months.csv (%s rows, %d columns). Accounting closes.", fmt(nrow(out)), ncol(out)))
