# 04_validate.R
# Tests that guard the processed data (course Prompt 5.5). It only checks; it
# changes nothing. If any test fails it prints the list and stops, so nothing
# later in the master script runs on bad data.
#
# Reads:  data/processed/mgcb_operator_months.csv
#         documentation/codebook_rules.csv, documentation/codebook.md
#         output/tables/wrangling_steps.csv
# Writes: output/tables/validation_results.csv

suppressPackageStartupMessages({library(dplyr); library(stringr)})

d      <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE, check.names = FALSE)
rules  <- read.csv(file.path("documentation", "codebook_rules.csv"), stringsAsFactors = FALSE, na.strings = "")
steps  <- read.csv(file.path("output", "tables", "wrangling_steps.csv"), stringsAsFactors = FALSE)
cb_txt <- readLines(file.path("documentation", "codebook.md"))

expected_rows <- 923   # from the approved cleaning plan (documentation/cleaning_plan.md)

results <- list()
test <- function(name, passed, detail = "") {
  results[[length(results) + 1]] <<- data.frame(test = name, result = if (isTRUE(passed)) "pass" else "FAIL", detail = detail, stringsAsFactors = FALSE)
}
present <- function(v) v[!is.na(v) & v != ""]

# 1. The identifier is unique
n_dup <- sum(duplicated(d[c("operator", "month_date")]))
test("Identifier (operator, month_date) is unique", n_dup == 0, sprintf("%d duplicated", n_dup))

# 2. Row count
test(sprintf("Row count equals %d", expected_rows), nrow(d) == expected_rows, sprintf("%d rows", nrow(d)))

# 3. Codebook and data list the same columns
test("Codebook has one row per column of the processed file", identical(rules$name, names(d)),
     sprintf("%d codebook rows, %d columns", nrow(rules), ncol(d)))

# 4. Every numeric and date variable lies inside its codebook range
bad_range <- character(0)
for (i in which(rules$kind %in% c("number", "whole", "date"))) {
  v <- present(d[[rules$name[i]]])
  if (rules$kind[i] == "date") {
    lo <- !is.na(rules$min[i]) && any(v < rules$min[i]); hi <- !is.na(rules$max[i]) && any(v > rules$max[i])
  } else {
    v <- as.numeric(v)
    lo <- !is.na(rules$min[i]) && any(v < as.numeric(rules$min[i])); hi <- !is.na(rules$max[i]) && any(v > as.numeric(rules$max[i]))
  }
  if (lo || hi) bad_range <- c(bad_range, rules$name[i])
}
test("Every numeric and date variable lies inside its codebook range", length(bad_range) == 0,
     if (length(bad_range)) paste("outside range:", paste(bad_range, collapse = ", ")) else sprintf("%d variables checked", sum(rules$kind %in% c("number", "whole", "date"))))

# 5. Whole-number variables hold whole numbers
bad_whole <- character(0)
for (nm in rules$name[rules$kind == "whole"]) { v <- as.numeric(present(d[[nm]])); if (any(v != round(v))) bad_whole <- c(bad_whole, nm) }
test("Whole-number variables hold whole numbers", length(bad_whole) == 0, paste(bad_whole, collapse = ", "))

# 6. Every categorical variable takes only its codebook values
bad_cat <- character(0)
for (i in which(rules$kind %in% c("category", "flag"))) {
  allowed <- str_split(rules$values[i], " \\| ")[[1]]
  if (!all(as.character(present(d[[rules$name[i]]])) %in% allowed)) bad_cat <- c(bad_cat, rules$name[i])
}
test("Every categorical variable takes only its codebook values", length(bad_cat) == 0,
     if (length(bad_cat)) paste("unexpected values in:", paste(bad_cat, collapse = ", ")) else sprintf("%d variables checked", sum(rules$kind %in% c("category", "flag"))))

# 7. The row accounting from the wrangling log adds up
removed <- sum(steps$rows_before - steps$rows_after)
test("Row accounting adds up: raw rows less rows removed equals processed rows",
     steps$rows_before[1] - removed == nrow(d) && tail(steps$rows_after, 1) == nrow(d),
     sprintf("%d - %d = %d; processed file has %d", steps$rows_before[1], removed, steps$rows_before[1] - removed, nrow(d)))

# 8. Derived variables match their definitions
ok_ded  <- with(d, all(abs(free_play_deduction - (gross_receipts - adjusted_gross_receipts)) < 0.005, na.rm = TRUE))
ok_rate <- with(d, all(abs(free_play_per_100 - 100 * free_play_deduction / handle) < 1e-6, na.rm = TRUE))
ok_kept <- with(d, all(abs(kept_per_100 - 100 * gross_receipts / handle) < 1e-6, na.rm = TRUE))
ok_tax  <- with(d, all(paid_no_tax == as.integer(state_tax_or_payment == 0)))
test("Derived variables match their codebook definitions", ok_ded && ok_rate && ok_kept && ok_tax,
     sprintf("deduction %s, free play per 100 %s, kept per 100 %s, paid no tax %s", ok_ded, ok_rate, ok_kept, ok_tax))

# 9. Missing values are exactly the ones the approved plan created
miss <- sapply(d, function(v) sum(is.na(v) | v == ""))
expected_missing <- c(free_play_deduction = 2, free_play_per_100 = 4, kept_per_100 = 2)
never_missing <- setdiff(names(d), c(names(expected_missing), "prior_free_play_per_100", "prior_kept_per_100", "prior_log10_handle", "prior_paid_no_tax"))
test("Missing values are only where the approved plan put them",
     all(miss[names(expected_missing)] == expected_missing) && all(miss[never_missing] == 0),
     sprintf("free_play_deduction %d, free_play_per_100 %d, kept_per_100 %d; other non-prior columns with missing values: %d",
             miss["free_play_deduction"], miss["free_play_per_100"], miss["kept_per_100"], sum(miss[never_missing] > 0)))

# 10. Prior-month variables are missing exactly when the previous calendar month is not in the data
key  <- paste(d$operator, d$year * 12 + d$month)
has_prior <- paste(d$operator, d$year * 12 + d$month - 1) %in% key
test("Prior-month size is present exactly when the operator's previous month is in the data",
     all(is.na(d$prior_log10_handle) == !has_prior), sprintf("%d rows have a previous month", sum(has_prior)))

# 11. The codebook has no label left UNDOCUMENTED
n_undoc <- sum(str_detect(cb_txt, "UNDOCUMENTED"))
test("No codebook label reads UNDOCUMENTED", n_undoc == 0, sprintf("%d lines", n_undoc))

res <- do.call(rbind, results)
dir.create(file.path("output", "tables"), recursive = TRUE, showWarnings = FALSE)
write.csv(res, file.path("output", "tables", "validation_results.csv"), row.names = FALSE)
print(res, row.names = FALSE, right = FALSE)

if (any(res$result != "pass")) {
  stop(sum(res$result != "pass"), " validation test(s) failed. See the list above. Do not adjust a test to make it pass.", call. = FALSE)
}
message(sprintf("04_validate: all %d tests passed.", nrow(res)))
