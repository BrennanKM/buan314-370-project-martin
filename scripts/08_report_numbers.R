# 08_report_numbers.R
# Collects every number the two reports use into one table, so that no number
# in a report is typed by hand (course Prompts 10.1 and 10.2). Each number has a
# short key, its value as printed, and the file and cell it comes from.
# The LaTeX report reads the numbers as \V{key}; the web page gets the same
# values written into it by 09_export_html_data.R.
# It also writes the LaTeX tables straight from the files in output/tables and
# copies the figure PDFs the report uses.
#
# Reads:  output/tables/*.csv, documentation/codebook.md, documentation/figure_titles.csv,
#         output/figures/*.pdf
# Writes: output/tables/report_numbers.csv
#         report/static/numbers.tex, report/static/tables/*.tex, report/static/figures/*.pdf
#         report/overleaf_upload.zip (the LaTeX project, ready to upload to Overleaf; not kept in Git)

suppressPackageStartupMessages(library(dplyr))
tb <- function(name) read.csv(file.path("output", "tables", paste0(name, ".csv")), check.names = FALSE, stringsAsFactors = FALSE)
i0 <- function(x) formatC(round(as.numeric(x)), format = "d", big.mark = ",")
d1 <- function(x) formatC(as.numeric(x), format = "f", digits = 1)
d2 <- function(x) formatC(as.numeric(x), format = "f", digits = 2)
d3 <- function(x) formatC(as.numeric(x), format = "f", digits = 3)
d4 <- function(x) formatC(as.numeric(x), format = "f", digits = 4)
pv <- function(p) ifelse(p < 0.001, "under 0.001", ifelse(p < 0.01, d3(p), d2(p)))   # p values, never shown as 0.00

N <- list()
add <- function(key, value, file, cell) {
  if (length(value) != 1 || is.na(value)) stop("Bad value for ", key)
  N[[length(N) + 1]] <<- data.frame(key = key, value = as.character(value), source_file = file, source_cell = cell, stringsAsFactors = FALSE)
}

# ---- Cleaning: row counts from the wrangling log ----
ws <- tb("wrangling_steps"); f <- "output/tables/wrangling_steps.csv (same as documentation/wrangling_log.md)"
st <- function(step, col) ws[[col]][ws$step == step]
add("cells_read", i0(st("1", "rows_before")), f, "step 1, rows before")
add("rows_after_duplicates", i0(st("2", "rows_after")), f, "step 2, rows after")
add("rows_duplicates_removed", i0(st("2", "rows_before") - st("2", "rows_after")), f, "step 2, before minus after")
add("rows_after_unreported", i0(st("3", "rows_after")), f, "step 3, rows after")
add("rows_unreported_removed", i0(st("3", "rows_before") - st("3", "rows_after")), f, "step 3, before minus after")
add("rows_after_no_wagering", i0(st("4", "rows_after")), f, "step 4, rows after")
add("rows_no_wagering_removed", i0(st("4", "rows_before") - st("4", "rows_after")), f, "step 4, before minus after")
add("rows_negative_removed", i0(st("5", "rows_before") - st("5", "rows_after")), f, "step 5, before minus after")
add("rows_final", i0(st("5", "rows_after")), f, "step 5, rows after")
add("lump_months", sub(" rows flagged", "", st("9", "values_changed")), f, "step 9, values changed")
add("first_months", sub(" rows flagged", "", st("14", "values_changed")), f, "step 14, values changed")
add("cleaning_steps", nrow(ws), f, "number of rows (steps 16a and 16b are two parts of step 16)")
add("cleaning_decisions", length(unique(sub("[ab]$", "", ws$step))), f, "number of different step numbers (16a and 16b counted once)")

# ---- Sub-question 1: spread ----
e <- tb("eda_01_free_play_spread"); f <- "output/tables/eda_01_free_play_spread.csv"; g <- function(m) e[[2]][e[[1]] == m]
add("fp_rows", i0(g("Rows with a value")), f, "Rows with a value"); add("fp_missing", g("Rows missing a value"), f, "Rows missing a value")
add("fp_q1", d2(g("Lower quartile")), f, "Lower quartile"); add("fp_median", d2(g("Median")), f, "Median"); add("fp_q3", d2(g("Upper quartile")), f, "Upper quartile")
add("fp_mean", d2(g("Mean")), f, "Mean"); add("fp_max", d2(g("Maximum")), f, "Maximum"); add("fp_p95", d2(g("95th percentile")), f, "95th percentile")
add("fp_n_5plus", g("Rows at $5 or more per $100"), f, "Rows at $5 or more per $100"); add("fp_pct_5plus", d2(g("Share at $5 or more per $100 (percent)")), f, "Share at $5 or more per $100 (percent)")
add("fp_n_10plus", g("Rows at $10 or more per $100"), f, "Rows at $10 or more per $100"); add("fp_pct_10plus", d2(g("Share at $10 or more per $100 (percent)")), f, "Share at $10 or more per $100 (percent)")
add("fp_pct_10plus_round", i0(g("Share at $10 or more per $100 (percent)")), f, "Share at $10 or more per $100 (percent), rounded to a whole number")
b <- tb("eda_01b_free_play_bins"); f <- "output/tables/eda_01b_free_play_bins.csv"
add("fp_n_under1", b[[2]][1], f, "$0 to under $1, operator-months"); add("fp_pct_under1", d2(b[[3]][1]), f, "$0 to under $1, share")
add("fp_n_3to4", b[[2]][4], f, "$3 to under $4, operator-months"); add("fp_pct_3to4", d2(b[[3]][4]), f, "$3 to under $4, share")
add("fp_n_20plus", sum(b[[2]][17:19]), f, "$20 to under $30, $30 to under $50 and $50 or more, added")

# ---- Sub-question 2 ----
e <- tb("eda_02_paid_no_tax_share"); f <- "output/tables/eda_02_paid_no_tax_share.csv"
add("notax_n", e[[2]][grepl("^Yes", e[[1]])], f, "Yes, operator-months"); add("notax_pct", d2(e[[3]][grepl("^Yes", e[[1]])]), f, "Yes, share")
add("tax_n", e[[2]][grepl("^No", e[[1]])], f, "No, operator-months"); add("tax_pct", d2(e[[3]][grepl("^No", e[[1]])]), f, "No, share")
add("notax_pct_round", i0(e[[3]][grepl("^Yes", e[[1]])]), f, "Yes, share, rounded to a whole number")

# ---- Sub-question 3 ----
e <- tb("eda_03_size_by_operator"); f <- "output/tables/eda_03_size_by_operator.csv"; sh <- "Share of all dollars wagered (percent)"; rs <- "Running share (percent)"
add("n_operators", nrow(e), f, "number of rows"); add("n_commercial", sum(e[["Operator type"]] == "commercial"), f, "rows with operator type commercial")
add("n_tribal", sum(e[["Operator type"]] == "tribal"), f, "rows with operator type tribal")
for (k in 1:3) add(paste0("share_top", k), d2(e[[sh]][k]), f, paste0(e$Operator[k], ", share of all dollars wagered"))
add("share_top3_total", d2(e[[rs]][3]), f, "running share, row 3"); add("share_top3_round", i0(e[[rs]][3]), f, "running share, row 3, rounded")
add("share_top6", d2(e[[rs]][6]), f, "running share, row 6"); add("share_bottom9", d2(100 - e[[rs]][6]), f, "100 minus running share, row 6")
add("share_bottom9_round", i0(100 - e[[rs]][6]), f, "100 minus running share, row 6, rounded")
add("months_full", max(e[["Months (rows)"]]), f, "largest value of Months (rows)"); add("months_fewest", min(e[["Months (rows)"]]), f, "smallest value of Months (rows)")
add("total_wagered_billion", d1(sum(e[["Total dollars wagered"]]) / 1e9), f, "Total dollars wagered, added over 15 operators, in billions")

# ---- Sub-question 4 ----
e <- tb("eda_04_free_play_by_operator"); f <- "output/tables/eda_04_free_play_by_operator.csv"; md <- "Median free play per $100 wagered"
op <- function(short, col) e[[col]][e$Operator == short]
for (o in list(c("lvd", "Lac Vieux Desert"), c("hannahville", "Hannahville"), c("betmgm", "MGM Grand Detroit"), c("fanduel", "MotorCity"), c("draftkings", "Bay Mills"),
               c("pokagon", "Pokagon Band"), c("sault", "Sault Ste. Marie Tribe"))) {
  add(paste0("op_", o[1], "_median"), d2(op(o[2], md)), f, paste0(o[2], ", median")); add(paste0("op_", o[1], "_months"), op(o[2], "Months with a value"), f, paste0(o[2], ", months with a value"))
}
add("op_pokagon_q1", d2(op("Pokagon Band", "Lower quartile")), f, "Pokagon Band, lower quartile"); add("op_pokagon_q3", d2(op("Pokagon Band", "Upper quartile")), f, "Pokagon Band, upper quartile")
add("op_fanduel_rank", which(e$Operator == "MotorCity"), f, "row of MotorCity (table is ordered by median)"); add("op_draftkings_rank", which(e$Operator == "Bay Mills"), f, "row of Bay Mills (table is ordered by median)")

# ---- Sub-question 5 ----
e <- tb("eda_05_free_play_by_year"); f <- "output/tables/eda_05_free_play_by_year.csv"
for (y in e$Year) { add(paste0("yr_", y, "_median"), d2(e[[md]][e$Year == y]), f, paste0(y, ", median")); add(paste0("yr_", y, "_months"), e[["Months with a value"]][e$Year == y], f, paste0(y, ", months with a value")) }

# ---- Sub-question 6 ----
e <- tb("eda_06_free_play_by_operator_type"); f <- "output/tables/eda_06_free_play_by_operator_type.csv"
for (ty in c("commercial", "tribal")) { r <- e[e[["Operator type"]] == ty, ]; p <- substr(ty, 1, 3)
  add(paste0(p, "_median"), d2(r[[md]]), f, paste0(ty, ", median")); add(paste0(p, "_months"), r[["Months with a value"]], f, paste0(ty, ", months with a value")); add(paste0(p, "_rows"), r[["Months (rows)"]], f, paste0(ty, ", months (rows)"))
  add(paste0(p, "_q1"), d2(r[["Lower quartile"]]), f, paste0(ty, ", lower quartile")); add(paste0(p, "_q3"), d2(r[["Upper quartile"]]), f, paste0(ty, ", upper quartile")); add(paste0(p, "_mean"), d2(r[["Mean free play per $100 wagered"]]), f, paste0(ty, ", mean")) }

# ---- Sub-question 7 ----
e <- tb("eda_07_free_play_vs_size_correlation"); f <- "output/tables/eda_07_free_play_vs_size_correlation.csv"
add("r_fp_size", d2(e$Value[1]), f, "straight-line correlation"); add("rank_fp_size", d2(e$Value[2]), f, "rank correlation")
e <- tb("eda_07b_free_play_by_size_band"); f <- "output/tables/eda_07b_free_play_by_size_band.csv"
for (k in 1:4) { add(paste0("size_band", k, "_median"), d2(e[[md]][k]), f, paste0(e[[1]][k], ", median")); add(paste0("size_band", k, "_months"), e[["Months with a value"]][k], f, paste0(e[[1]][k], ", months with a value")) }
add("size_band1_mean", d2(e[["Mean free play per $100 wagered"]][1]), f, paste0(e[[1]][1], ", mean"))

# ---- Sub-question 8 ----
e <- tb("eda_08_no_tax_by_operator_type"); f <- "output/tables/eda_08_no_tax_by_operator_type.csv"
for (ty in c("commercial", "tribal")) { r <- e[e[["Operator type"]] == ty, ]; p <- substr(ty, 1, 3)
  add(paste0(p, "_notax_n"), r[["Months with no state tax paid"]], f, paste0(ty, ", months with no state tax paid")); add(paste0(p, "_notax_pct"), d2(r[["Share with no state tax paid (percent)"]]), f, paste0(ty, ", share with no state tax paid")) }

# ---- Sub-question 9 ----
e <- tb("eda_09_no_tax_by_year_and_type"); f <- "output/tables/eda_09_no_tax_by_year_and_type.csv"
for (r in seq_len(nrow(e))) { p <- paste0(substr(e[["Operator type"]][r], 1, 3), "_", e$Year[r]); lab <- paste0(e[["Operator type"]][r], " ", e$Year[r])
  add(paste0(p, "_notax_pct"), d2(e[["Share with no state tax paid (percent)"]][r]), f, paste0(lab, ", share")); add(paste0(p, "_notax_round"), i0(e[["Share with no state tax paid (percent)"]][r]), f, paste0(lab, ", share, rounded"))
  add(paste0(p, "_notax_n"), e[["Months with no state tax paid"]][r], f, paste0(lab, ", months with no state tax paid")); add(paste0(p, "_rows"), e[["Months (rows)"]][r], f, paste0(lab, ", months (rows)")) }

# ---- Sub-question 10 ----
e <- tb("eda_10_free_play_by_age_and_type"); f <- "output/tables/eda_10_free_play_by_age_and_type.csv"; band_key <- c("1 to 6" = "b1", "7 to 12" = "b2", "13 to 24" = "b3", "25 to 48" = "b4", "49 or more" = "b5")
for (r in seq_len(nrow(e))) { p <- paste0("age_", substr(e[["Operator type"]][r], 1, 3), "_", band_key[[e[[2]][r]]]); lab <- paste0(e[["Operator type"]][r], ", months ", e[[2]][r])
  add(paste0(p, "_median"), d2(e[[md]][r]), f, paste0(lab, ", median")); add(paste0(p, "_months"), e[["Months with a value"]][r], f, paste0(lab, ", months with a value")) }
cm <- e[e[["Operator type"]] == "commercial", ]
add("age_com_min", d2(min(cm[[md]])), f, "commercial, smallest of the five medians"); add("age_com_max", d2(max(cm[[md]])), f, "commercial, largest of the five medians")

# ---- Sub-question 11 ----
e <- tb("eda_11_unusual_months"); f <- "output/tables/eda_11_unusual_months.csv"; w <- e[e[[1]] == "Without both", ]; a <- e[e[[1]] == "All rows", ]
add("without_median", d2(w[[md]]), f, "Without both, median"); add("without_months", w[["Months with a value"]], f, "Without both, months with a value")
add("without_mean", d2(w[["Mean free play per $100 wagered"]]), f, "Without both, mean"); add("without_2021", d2(w[["Median in 2021"]]), f, "Without both, median in 2021")
add("without_2026", d2(w[["Median in 2026"]]), f, "Without both, median in 2026"); add("without_pct_5plus", d2(w[["Share at $5 or more per $100 (percent)"]]), f, "Without both, share at $5 or more")
wl <- e[grepl("^Without the 21 lump", e[[1]]), ]
add("without_lump_mean", d2(wl[["Mean free play per $100 wagered"]]), f, "Without the 21 lump-deduction months, mean"); add("without_lump_median", d2(wl[[md]]), f, "Without the 21 lump-deduction months, median")
e <- tb("eda_11c_unusual_months_by_year"); f <- "output/tables/eda_11c_unusual_months_by_year.csv"
add("lump_2021", e[["Lump-deduction months"]][e$Year == 2021], f, "2021, lump-deduction months"); add("first_2021", e[["First active months"]][e$Year == 2021], f, "2021, first active months")

# ---- Sub-question 12 ----
e <- tb("eda_12c_correlations_with_each_target"); f <- "output/tables/eda_12c_correlations_with_each_target.csv"
cr <- function(target, variable, col = "Correlation") e[[col]][grepl(target, e$Target, fixed = TRUE) & e$Variable == variable]
add("r_fp_prior", d2(cr("Free play", "Prior month: free play per $100")), f, "free play, prior month: free play per $100"); add("r_fp_prior_rows", cr("Free play", "Prior month: free play per $100", "Rows used"), f, "same pair, rows used")
add("r_fp_months", d2(cr("Free play", "Months active")), f, "free play, months active"); add("r_fp_lump", d2(cr("Free play", "Lump deduction (1 = yes)")), f, "free play, lump deduction")
add("r_fp_commercial", d2(cr("Free play", "Commercial operator (1 = yes)")), f, "free play, commercial operator")
add("r_nt_prior", d2(cr("Paid no", "Prior month: paid no tax (1 = yes)")), f, "paid no tax, prior month: paid no tax"); add("r_nt_prior_rows", cr("Paid no", "Prior month: paid no tax (1 = yes)", "Rows used"), f, "same pair, rows used")
add("r_nt_priorsize", d2(cr("Paid no", "Prior month: size (log10 dollars wagered)")), f, "paid no tax, prior month: size"); add("r_nt_commercial", d2(cr("Paid no", "Commercial operator (1 = yes)")), f, "paid no tax, commercial operator")
add("r_nt_months", d2(cr("Paid no", "Months active")), f, "paid no tax, months active"); add("r_nt_fp", d2(cr("Paid no", "Free play per $100 wagered")), f, "paid no tax, free play per $100")

# ---- Models ----
for (m in 1:2) { e <- tb(paste0("model", m, "_estimates")); f <- paste0("output/tables/model", m, "_estimates.csv")
  for (r in seq_len(nrow(e))) { p <- paste0("m", m, "_b", r - 1)
    add(p, d4(abs(e$Estimate[r])), f, paste0(e$Term[r], ", estimate (shown without its sign; the sign is written in the text)")); add(paste0(p, "_se"), d4(e[["Standard error"]][r]), f, paste0(e$Term[r], ", standard error"))
    add(paste0(p, "_p"), pv(e[["p value"]][r]), f, paste0(e$Term[r], ", p value")) } }
e1 <- tb("model1_estimates"); f <- "output/tables/model1_estimates.csv"
add("m1_prior_cents", i0(100 * e1$Estimate[2]), f, "prior_free_play_per_100, estimate x 100, rounded (cents per $1)")
add("m1_months_cents", i0(100 * abs(e1$Estimate[3])), f, "months_active, estimate x 100, rounded (cents per month)")
add("m1_months_year", d2(12 * abs(e1$Estimate[3])), f, "months_active, estimate x 12 (dollars per year)")
add("m1_com_dollars", d2(e1$Estimate[4]), f, "commercial, estimate"); add("m1_com_se_dollars", d2(e1[["Standard error"]][4]), f, "commercial, standard error")
e2 <- tb("model2_estimates"); f <- "output/tables/model2_estimates.csv"
add("m2_prior_points", d1(100 * e2$Estimate[2]), f, "prior_paid_no_tax, estimate x 100 (percentage points)"); add("m2_size_points", d1(100 * abs(e2$Estimate[3])), f, "prior_log10_handle, estimate x 100 (percentage points)")
add("m2_com_points", d1(100 * abs(e2$Estimate[4])), f, "commercial, estimate x 100 (percentage points)"); add("m2_com_se_points", d1(100 * e2[["Standard error"]][4]), f, "commercial, standard error x 100")
e <- tb("model_fit"); f <- "output/tables/model_fit.csv"; r1 <- e[e$Model == "model1", ]; r2 <- e[e$Model == "model2", ]
add("m1_rows", r1[["Rows used"]], f, "model1, rows used"); add("m1_left_out", r1[["Rows left out"]], f, "model1, rows left out"); add("m1_r2", d3(r1[["R-squared"]]), f, "model1, R-squared")
add("m1_r2_pct", d1(100 * r1[["R-squared"]]), f, "model1, R-squared x 100"); add("m1_r2_round", i0(100 * r1[["R-squared"]]), f, "model1, R-squared x 100, rounded")
add("m1_rmse", d2(r1[["Root mean squared error (target units)"]]), f, "model1, root mean squared error")
add("m2_rows", r2[["Rows used"]], f, "model2, rows used"); add("m2_left_out", r2[["Rows left out"]], f, "model2, rows left out"); add("m2_r2", d3(r2[["R-squared"]]), f, "model2, R-squared")
add("m2_min", d4(r2[["Smallest prediction"]]), f, "model2, smallest prediction"); add("m2_max", d3(r2[["Largest prediction"]]), f, "model2, largest prediction")
add("m2_below0", r2[["Predictions below 0"]], f, "model2, predictions below 0"); add("m2_above1", r2[["Predictions above 1"]], f, "model2, predictions above 1")
add("m2_outside", r2[["Predictions below 0"]] + r2[["Predictions above 1"]], f, "model2, predictions below 0 plus above 1"); add("m2_outside_pct", d2(r2[["Share of predictions outside 0 to 1 (percent)"]]), f, "model2, share outside 0 to 1")
add("m2_correct_pct", d1(r2[["Share classified correctly at 0.5 (percent)"]]), f, "model2, share classified correctly"); add("m2_correct_round", i0(r2[["Share classified correctly at 0.5 (percent)"]]), f, "model2, share classified correctly, rounded")
add("m2_baseline_pct", d1(r2[["Share correct by always guessing the more common category (percent)"]]), f, "model2, share correct by always guessing the more common category")
add("m2_baseline_round", i0(r2[["Share correct by always guessing the more common category (percent)"]]), f, "same, rounded"); add("m2_share_yes", d1(r2[["Share of yes rows in the rows used (percent)"]]), f, "model2, share of yes rows")
add("m2_mean_pred", d1(r2[["Average predicted probability (percent)"]]), f, "model2, average predicted probability")
e <- tb("model2_classification_table"); f <- "output/tables/model2_classification_table.csv"
add("m2_yes_yes", e[1, 2], f, "actual yes, predicted yes"); add("m2_yes_no", e[1, 3], f, "actual yes, predicted no"); add("m2_no_yes", e[2, 2], f, "actual no, predicted yes"); add("m2_no_no", e[2, 3], f, "actual no, predicted no")
add("m2_correct_n", e[1, 2] + e[2, 3], f, "actual yes predicted yes, plus actual no predicted no"); add("m2_actual_yes", e[1, 4], f, "actual yes, total"); add("m2_actual_no", e[2, 4], f, "actual no, total")
e <- tb("model1_error_summary"); f <- "output/tables/model1_error_summary.csv"; g <- function(m) e$Value[e$Measure == m]
add("m1_within5_n", g("Errors within $5 either way (rows)"), f, "errors within $5, rows"); add("m1_within5_pct", i0(g("Errors within $5 either way (percent)")), f, "errors within $5, percent")
add("m1_above10", g("Actual more than $10 above the prediction (rows)"), f, "actual more than $10 above"); add("m1_below10", g("Actual more than $10 below the prediction (rows)"), f, "actual more than $10 below")
add("m1_largest_miss", d2(g("Largest error above the prediction (dollars per $100)")), f, "largest error above the prediction")
add("m1_above10_lump", g("Of those, months flagged as lump deductions (rows)"), f, "of those, months flagged as lump deductions")
e <- tb("model_rows_left_out"); f <- "output/tables/model_rows_left_out.csv"
add("m1_no_prior", e$Rows[e$Model == "model1" & grepl("^No prior", e[[2]])], f, "model1, no prior month"); add("m1_missing_value", sum(e$Rows[e$Model == "model1" & grepl("^Missing", e[[2]])]), f, "model1, the two missing-value rows added")
add("m2_no_prior", e$Rows[e$Model == "model2" & grepl("^No prior", e[[2]])], f, "model2, no prior month")
e <- tb("model_scenarios"); f <- "output/tables/model_scenarios.csv"
for (k in 1:3) { add(paste0("case", k, "_m1"), d2(e[[8]][k]), f, paste0("case ", k, ", model 1 prediction")); add(paste0("case", k, "_m2"), d4(e[[9]][k]), f, paste0("case ", k, ", model 2 prediction"))
  add(paste0("case", k, "_m2_pct"), i0(100 * e[[9]][k]), f, paste0("case ", k, ", model 2 prediction x 100, rounded")) }
e <- tb("model_hand_predictions"); add("hand_checks", nrow(e), "output/tables/model_hand_predictions.csv", "number of rows"); add("hand_equal", sum(e[["Prediction by hand"]] == e[["Prediction from the script"]]), "output/tables/model_hand_predictions.csv", "rows where the two predictions are equal")
e <- tb("validation_results"); add("tests_run", nrow(e), "output/tables/validation_results.csv", "number of rows")
e <- tb("figure_checks"); add("figure_checks", nrow(e), "output/tables/figure_checks.csv", "number of rows")

# ---- Fixed quantities used in the wording (definitions, not results) ----
for (x in list(c("def_cutoff", "0.5", "the cutoff the course sets for the linear probability model"), c("def_per", "100", "free play is stated per $100 wagered"),
               c("def_lump_share", "a quarter", "codebook: lump_deduction is 1 when the deduction is more than 0.25 x handle"), c("def_tiny_handle", "10,000", "cleaning step 6: rates are blank under $10,000 wagered"),
               c("def_small_group", "30", "course rule: flag any group with fewer than 30 rows"), c("def_within", "5", "error band used in model1_error_summary.csv"),
               c("def_fp_mid", "5", "threshold used in eda_01_free_play_spread.csv"), c("def_fp_high", "10", "threshold used in eda_01_free_play_spread.csv"),
               c("def_frame", "20", "frame of figure 4 and last bar of figure 1 (scripts/06_figures.R)"),
               c("def_big_miss", "10", "error band used in model1_error_summary.csv"), c("n_columns", "28", "documentation/codebook.md: one row per variable"),
               c("tax_rate", "8.4", "documentation/codebook.md, state_tax_or_payment (MCL 432.414)"), c("tax_rate_state_commercial", "5.88", "documentation/codebook.md, operator_type (label of the tax column)")))
  add(x[1], x[2], "definition", x[3])

num <- bind_rows(N)
if (any(duplicated(num$key))) stop("Duplicate keys: ", paste(num$key[duplicated(num$key)], collapse = ", "))
dir.create(file.path("report", "static", "tables"), recursive = TRUE, showWarnings = FALSE); dir.create(file.path("report", "static", "figures"), recursive = TRUE, showWarnings = FALSE)
write.csv(num, file.path("output", "tables", "report_numbers.csv"), row.names = FALSE)

# ---- LaTeX: the numbers as \V{key} ----
esc <- function(x) { x <- gsub("\\\\", "\\\\textbackslash{}", x); x <- gsub("([&%$#_{}])", "\\\\\\1", x); x <- gsub("~", "\\\\textasciitilde{}", x); gsub("\\^", "\\\\textasciicircum{}", x) }
writeLines(c("% Written by scripts/08_report_numbers.R. Do not edit by hand.",
             "% Every number in the report is \\V{key}; the key, value and source file are listed in output/tables/report_numbers.csv.",
             "\\newcommand{\\V}[1]{\\ifcsname val@#1\\endcsname\\csname val@#1\\endcsname\\else\\textbf{[missing number: \\detokenize{#1}]}\\fi}",
             sprintf("\\expandafter\\def\\csname val@%s\\endcsname{%s}", num$key, esc(num$value))), file.path("report", "static", "numbers.tex"))

# ---- LaTeX tables, built from the files in output/tables ----
# Paragraph columns are set ragged-right: justified narrow columns pushed long words past the margin (Overleaf compile, 2026-11-24).
ragged <- function(align) gsub("p{", ">{\\raggedright\\arraybackslash}p{", align, fixed = TRUE)
tex_table <- function(df, file, align, head = names(df)) {
  body <- apply(df, 1, function(r) paste0(paste(esc(trimws(as.character(r))), collapse = " & "), " \\\\"))
  writeLines(c("% Written by scripts/08_report_numbers.R from output/tables. Do not edit by hand.", paste0("\\begin{tabular}{", ragged(align), "}"), "\\toprule",
               paste0(paste(esc(head), collapse = " & "), " \\\\"), "\\midrule", body, "\\bottomrule", "\\end{tabular}"), file.path("report", "static", "tables", file))
}
long_table <- function(df, file, align, head = names(df)) {
  body <- apply(df, 1, function(r) paste0(paste(esc(trimws(as.character(r))), collapse = " & "), " \\\\"))
  hl <- paste0(paste(sprintf("\\textbf{%s}", esc(head)), collapse = " & "), " \\\\")
  writeLines(c("% Written by scripts/08_report_numbers.R. Do not edit by hand.", paste0("\\begin{longtable}{", ragged(align), "}"), "\\toprule", hl, "\\midrule", "\\endhead", "\\bottomrule", "\\endfoot", body, "\\end{longtable}"),
             file.path("report", "static", "tables", file))
}
# Codebook rows (the codebook is itself written by 03b_codebook.R from the processed data)
cb_lines <- grep("^\\| `", readLines(file.path("documentation", "codebook.md")), value = TRUE)
cb <- do.call(rbind, lapply(strsplit(cb_lines, " | ", fixed = TRUE), function(p) if (length(p) >= 10) data.frame(Name = gsub("^\\| `|`$", "", p[1]), Label = p[2], Type = p[3], Units = p[4], Missing = p[7], stringsAsFactors = FALSE)))
cb$Label <- gsub("\\*\\*", "", cb$Label)
if (nrow(cb) != 28) stop("Expected 28 codebook rows, found ", nrow(cb))
key_vars <- c("operator", "operator_type", "month_date", "handle", "gross_receipts", "adjusted_gross_receipts", "state_tax_or_payment", "free_play_per_100", "paid_no_tax", "months_active", "lump_deduction", "first_active_month")
kv <- cb[match(key_vars, cb$Name), c("Name", "Label", "Units")]
tex_table(kv, "key_variables.tex", "@{}p{0.24\\linewidth}p{0.50\\linewidth}p{0.20\\linewidth}@{}", c("Variable", "What it is", "Units"))
long_table(cb, "codebook.tex", "@{}p{0.22\\linewidth}p{0.33\\linewidth}p{0.10\\linewidth}p{0.13\\linewidth}p{0.10\\linewidth}@{}")
wl <- ws %>% transmute(Step = step, `What changed` = what_changed, Why = why, Before = i0(rows_before), After = i0(rows_after))
long_table(wl, "wrangling_log.tex", "@{}p{0.05\\linewidth}p{0.38\\linewidth}p{0.31\\linewidth}rr@{}")
tex_table(ws %>% filter(step %in% c("1", "2", "3", "4", "5")) %>% transmute(Step = step, `What was done` = sub("\\s*\\(.*$", "", what_changed), `Rows before` = i0(rows_before), `Rows after` = i0(rows_after)),
          "row_accounting.tex", "@{}p{0.07\\linewidth}p{0.61\\linewidth}rr@{}")
e3 <- tb("eda_03_size_by_operator"); e4 <- tb("eda_04_free_play_by_operator")
by_op <- e4 %>% left_join(e3[, c("Operator", "Share of all dollars wagered (percent)")], by = "Operator") %>%
  transmute(Operator, Brand = `Latest platform provider`, Type = `Operator type`, Months = `Months with a value`, `Lower quartile` = d2(`Lower quartile`), Median = d2(`Median free play per $100 wagered`),
            `Upper quartile` = d2(`Upper quartile`), `Share of wagering (%)` = d2(`Share of all dollars wagered (percent)`))
# Short column heads so the table fits the page (first Overleaf compile, 2026-11-24: it ran 121pt past the margin); the caption spells them out.
tex_table(by_op, "by_operator.tex", "@{}p{0.20\\linewidth}p{0.24\\linewidth}lrrrrr@{}", c("Operator", "Brand", "Type", "Months", "Lower", "Median", "Upper", "Share (%)"))
e9 <- tb("eda_09_no_tax_by_year_and_type") %>% transmute(Year, `Operator type`, Months = `Months (rows)`, `Months with no tax` = `Months with no state tax paid`, `Share with no tax (%)` = d2(`Share with no state tax paid (percent)`))
tex_table(e9, "no_tax_by_year.tex", "@{}llrrr@{}")
e12 <- tb("eda_12c_correlations_with_each_target")
known <- c("Prior month: free play per $100", "Prior month: paid no tax (1 = yes)", "Prior month: size (log10 dollars wagered)", "Prior month: kept per $100", "Months active", "Commercial operator (1 = yes)", "Year", "Month of the year (1 to 12)")
tex_table(e12 %>% filter(Variable %in% known) %>% transmute(Target, `Variable known before the month starts` = Variable, Correlation = d2(Correlation), `Rows used`), "correlations_known.tex", "@{}p{0.27\\linewidth}p{0.42\\linewidth}rr@{}")
for (m in 1:2) tex_table(tb(paste0("model", m, "_estimates")) %>% transmute(Term = Label, Estimate = d4(Estimate), `Standard error` = d4(`Standard error`), `p value` = pv(`p value`)),
                         paste0("model", m, "_estimates.tex"), "@{}p{0.55\\linewidth}rrr@{}")
tex_table(tb("model2_classification_table"), "classification.tex", "@{}lrrr@{}")
sc <- tb("model_scenarios")
tex_table(data.frame(Case = sc$Case, a = d2(sc[[2]]), b = sc[[3]], c = sc[[4]], d = sc[[5]], e = sc[[6]], f = d2(sc[[8]]), g = d4(sc[[9]]), h = sub("^No:.*$", "No", sc[[11]])), "scenarios.tex",
          "@{}p{0.27\\linewidth}rrllrrrl@{}", c("Case", "Free play last month ($ per $100)", "Months active", "Type", "No tax last month", "Wagered last month ($)", "Model 1 ($ per $100)", "Model 2 (probability)", "Beyond the data?"))

# ---- Figures the report uses ----
figs <- c("fig01_free_play_spread", "fig03_share_of_wagering", "fig04_free_play_by_operator", "fig09_no_tax_by_year_and_type", "fig10_free_play_by_age_and_type", "fig12_correlation_heatmap",
          "fig_m1_predicted_vs_actual", "fig_m1_errors_vs_predicted", "fig_m2_predicted_probability")
ok <- file.copy(file.path("output", "figures", paste0(figs, ".pdf")), file.path("report", "static", "figures", paste0(figs, ".pdf")), overwrite = TRUE)
if (!all(ok)) stop("Could not copy: ", paste(figs[!ok], collapse = ", "))
# ---- Zip for Overleaf (course Prompt 10.3): only what Overleaf needs, main.tex at the top level ----
if (file.exists(file.path("report", "static", "main.tex"))) {
  here <- getwd(); setwd(file.path("report", "static"))
  zip_files <- c("main.tex", "numbers.tex", "references.bib", list.files("sections", pattern = "\\.tex$", full.names = TRUE), list.files("tables", pattern = "\\.tex$", full.names = TRUE), list.files("figures", pattern = "\\.pdf$", full.names = TRUE))
  unlink(file.path("..", "overleaf_upload.zip")); utils::zip(file.path("..", "overleaf_upload.zip"), files = zip_files, flags = "-q -X")
  setwd(here)
}
message(sprintf("08_report_numbers: %d numbers, %d LaTeX tables and %d figures written for the static report.", nrow(num), length(list.files(file.path("report", "static", "tables"))), length(figs)))
