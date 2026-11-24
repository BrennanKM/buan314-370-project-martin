# 07a_model_plan.R
# Evidence for choosing predictors (course Prompt 8.1). FITS NOTHING.
# For each target it lists candidate predictors with the correlation or the
# difference in group averages that supports each, the rows behind it, and
# flags: not known at the moment of prediction, another version of the target,
# or correlated above 0.8 with another candidate.
#
# Reads:  data/processed/mgcb_operator_months.csv
# Writes: output/tables/model_candidates.csv

suppressPackageStartupMessages({library(dplyr); library(tibble)})
d <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE) %>% mutate(commercial = as.integer(operator_type == "commercial"))

cand <- tribble(
  ~variable, ~label, ~kind, ~known_at_start_of_month, ~flag,
  "prior_free_play_per_100", "Prior month: free play per $100 wagered", "numeric", "yes", "",
  "prior_paid_no_tax", "Prior month: paid no state tax (1 = yes)", "two categories", "yes", "",
  "prior_kept_per_100", "Prior month: dollars kept per $100 wagered", "numeric", "yes", "",
  "prior_log10_handle", "Prior month: size (log10 of dollars wagered)", "numeric", "yes", "",
  "months_active", "Months the operator has been active", "numeric", "yes", "Correlated 0.96 with year; use one or the other",
  "commercial", "Operator type (commercial against tribal)", "two categories", "yes", "",
  "year", "Calendar year", "numeric", "yes", "Correlated 0.96 with months active; use one or the other",
  "month", "Month of the year (1 to 12)", "numeric here; really a category", "yes", "A straight line through month numbers means little; would need 11 category terms",
  "log10_handle", "Size this month (log10 of dollars wagered)", "numeric", "NO", "NOT KNOWN at the start of the month. Correlated 0.97 with its prior-month version",
  "kept_per_100", "Dollars kept per $100 wagered this month", "numeric", "NO", "NOT KNOWN at the start of the month",
  "lump_deduction", "Lump deduction flag this month", "two categories", "NO", "NOT KNOWN at the start of the month, and ANOTHER VERSION of free play per $100 (it is defined from the same deduction)",
  "first_active_month", "First active month flag", "two categories", "yes", "Rows flagged 1 have no prior-month values, so they drop out of any model that uses a prior-month predictor",
  "state_tax_or_payment", "State tax or payment this month", "numeric", "NO", "NOT KNOWN at the start of the month, and ANOTHER VERSION of paid no tax (the target is defined from it)",
  "adjusted_gross_receipts", "Adjusted gross receipts this month", "numeric", "NO", "NOT KNOWN at the start of the month; built from the same figures as both targets"
)
targets <- c(free_play_per_100 = "Free play per $100 wagered (numeric target)", paid_no_tax = "Paid no state tax, 1 = yes (yes-or-no target)")

rows <- list()
for (t in names(targets)) for (i in seq_len(nrow(cand))) {
  v <- cand$variable[i]; ok <- !is.na(d[[t]]) & !is.na(d[[v]])
  r <- suppressWarnings(cor(d[[t]][ok], d[[v]][ok]))
  grp <- ""
  if (cand$kind[i] == "two categories") {
    g <- d[ok, ] %>% group_by(level = .data[[v]]) %>% summarise(n = n(), m = mean(.data[[t]]), .groups = "drop")
    unit <- if (t == "paid_no_tax") "share paying no tax" else "mean free play per $100"
    fmtm <- function(x) if (t == "paid_no_tax") sprintf("%.1f%%", 100 * x) else sprintf("%.2f", x)
    grp <- paste(sprintf("%s = %s: %s %s (%d rows)", v, g$level, unit, fmtm(g$m), g$n), collapse = "; ")
  }
  rows[[length(rows) + 1]] <- tibble(Target = targets[[t]], `Candidate predictor` = cand$label[i], `Variable name` = v, Type = cand$kind[i],
    Correlation = round(r, 2), `Rows used` = sum(ok), `Group averages (two-category candidates)` = grp,
    `Known at the start of the month` = cand$known_at_start_of_month[i], Flag = cand$flag[i])
}
out <- bind_rows(rows) %>% group_by(Target) %>% arrange(desc(`Known at the start of the month` == "yes"), desc(abs(Correlation)), .by_group = TRUE) %>% ungroup()
write.csv(out, file.path("output", "tables", "model_candidates.csv"), row.names = FALSE, na = "")

# Pairs of usable candidates correlated above 0.8 with each other
usable <- cand$variable[cand$known_at_start_of_month == "yes"]
cm <- suppressWarnings(cor(d[usable], use = "pairwise.complete.obs")); cm[lower.tri(cm, diag = TRUE)] <- NA
hi <- which(abs(cm) > 0.8, arr.ind = TRUE)
message("07a_model_plan: wrote output/tables/model_candidates.csv (", nrow(out), " rows). Usable candidates correlated above 0.8 with each other: ",
        if (nrow(hi) == 0) "none" else paste(sprintf("%s and %s (%.2f)", rownames(cm)[hi[, 1]], colnames(cm)[hi[, 2]], cm[hi]), collapse = "; "))
