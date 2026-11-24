# 05_eda.R
# Computes the summary table that answers each sub-question in
# documentation/eda_plan.md (course Prompt 6.2) and the correlation matrix
# with its heat map (Prompt 6.4). Numbers only: no interpretation.
# Every mean, median and percentage is shown with the count behind it, and any
# group with fewer than 30 rows is flagged.
#
# Reads:  data/processed/mgcb_operator_months.csv
# Writes: output/tables/eda_01 ... eda_12 (CSV files, named by sub-question)
#         output/figures/fig12_correlation_heatmap.png and .pdf

suppressPackageStartupMessages({library(dplyr); library(tidyr); library(stringr); library(ggplot2)})
source(file.path("scripts", "00_style.R"))

d <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE)
out_dir <- file.path("output", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
save_tbl <- function(x, name) { write.csv(x, file.path(out_dir, paste0(name, ".csv")), row.names = FALSE, na = ""); invisible(x) }
r2 <- function(v) round(v, 2)
small <- function(n) ifelse(n < 30, "yes", "")

# Summary of free play per $100 for any grouping
fp_summary <- function(df) {
  df %>% summarise(
    `Months (rows)` = n(),
    `Months with a value` = sum(!is.na(free_play_per_100)),
    `Lower quartile` = r2(quantile(free_play_per_100, 0.25, na.rm = TRUE)),
    `Median free play per $100 wagered` = r2(median(free_play_per_100, na.rm = TRUE)),
    `Upper quartile` = r2(quantile(free_play_per_100, 0.75, na.rm = TRUE)),
    `Mean free play per $100 wagered` = r2(mean(free_play_per_100, na.rm = TRUE)),
    .groups = "drop") %>%
    mutate(`Fewer than 30 rows` = small(`Months with a value`))
}

# ---- 1. Spread of free play per $100 wagered ----
v <- d$free_play_per_100
t1 <- tibble(
  Measure = c("Operator-months (rows)", "Rows with a value", "Rows missing a value", "Minimum", "5th percentile", "Lower quartile", "Median", "Upper quartile",
              "95th percentile", "Maximum", "Mean", "Rows at $5 or more per $100", "Share at $5 or more per $100 (percent)", "Rows at $10 or more per $100", "Share at $10 or more per $100 (percent)"),
  `Free play deducted per $100 wagered` = c(nrow(d), sum(!is.na(v)), sum(is.na(v)), r2(min(v, na.rm = TRUE)), r2(quantile(v, .05, na.rm = TRUE)), r2(quantile(v, .25, na.rm = TRUE)), r2(median(v, na.rm = TRUE)),
              r2(quantile(v, .75, na.rm = TRUE)), r2(quantile(v, .95, na.rm = TRUE)), r2(max(v, na.rm = TRUE)), r2(mean(v, na.rm = TRUE)),
              sum(v >= 5, na.rm = TRUE), r2(100 * mean(v >= 5, na.rm = TRUE)), sum(v >= 10, na.rm = TRUE), r2(100 * mean(v >= 10, na.rm = TRUE))))
save_tbl(t1, "eda_01_free_play_spread")
bins <- cut(v, breaks = c(0:15, 20, 30, 50, Inf), right = FALSE, include.lowest = TRUE,
            labels = c(paste0("$", 0:14, " to under $", 1:15), "$15 to under $20", "$20 to under $30", "$30 to under $50", "$50 or more"))
t1b <- as.data.frame(table(bins), stringsAsFactors = FALSE) %>% transmute(`Free play deducted per $100 wagered` = bins, `Operator-months` = Freq, `Share of rows with a value (percent)` = r2(100 * Freq / sum(!is.na(v))))
save_tbl(t1b, "eda_01b_free_play_bins")

# ---- 2. Share of months with no state tax paid ----
t2 <- d %>% count(paid_no_tax, name = "Operator-months") %>%
  mutate(`Paid no state tax or payment` = ifelse(paid_no_tax == 1, "Yes (paid nothing)", "No (paid something)"), `Share of all rows (percent)` = r2(100 * `Operator-months` / sum(`Operator-months`))) %>%
  select(`Paid no state tax or payment`, `Operator-months`, `Share of all rows (percent)`)
save_tbl(t2, "eda_02_paid_no_tax_share")

# ---- 3. Size of the sportsbooks ----
t3 <- d %>% group_by(Operator = operator_short, `Latest platform provider` = platform_latest, `Operator type` = operator_type) %>%
  summarise(`Months (rows)` = n(), `Median monthly dollars wagered` = round(median(handle)), `Total dollars wagered` = round(sum(handle)), .groups = "drop") %>%
  arrange(desc(`Total dollars wagered`)) %>%
  mutate(`Share of all dollars wagered (percent)` = r2(100 * `Total dollars wagered` / sum(`Total dollars wagered`)),
         `Running share (percent)` = r2(cumsum(100 * `Total dollars wagered` / sum(`Total dollars wagered`))), `Fewer than 30 rows` = small(`Months (rows)`))
save_tbl(t3, "eda_03_size_by_operator")

# ---- 4. Free play per $100 by operator ----
t4 <- d %>% group_by(Operator = operator_short, `Latest platform provider` = platform_latest, `Operator type` = operator_type) %>% fp_summary() %>%
  arrange(desc(`Median free play per $100 wagered`))
save_tbl(t4, "eda_04_free_play_by_operator")

# ---- 5. Free play per $100 over time ----
t5 <- d %>% group_by(Year = year) %>% fp_summary()
save_tbl(t5, "eda_05_free_play_by_year")
t5b <- d %>% group_by(`Month` = month_date) %>% summarise(`Operators reporting` = n(), `Operators with a value` = sum(!is.na(free_play_per_100)),
  `Median free play per $100 wagered` = r2(median(free_play_per_100, na.rm = TRUE)),
  `All operators together: free play per $100 wagered` = r2(100 * sum(free_play_deduction, na.rm = TRUE) / sum(handle)), .groups = "drop") %>% mutate(`Fewer than 30 rows` = small(`Operators with a value`))
save_tbl(t5b, "eda_05b_free_play_by_month")

# ---- 6. Free play per $100 by operator type ----
t6 <- d %>% group_by(`Operator type` = operator_type) %>% fp_summary()
save_tbl(t6, "eda_06_free_play_by_operator_type")

# ---- 7. Free play per $100 against size ----
ok <- !is.na(d$free_play_per_100)
t7 <- tibble(Measure = c("Correlation (straight-line) of free play per $100 with log10 of dollars wagered", "Rank correlation of the same pair", "Rows used"),
             Value = c(r2(cor(d$free_play_per_100[ok], d$log10_handle[ok])), r2(cor(d$free_play_per_100[ok], d$log10_handle[ok], method = "spearman")), sum(ok)))
save_tbl(t7, "eda_07_free_play_vs_size_correlation")
t7b <- d %>% mutate(`Dollars wagered in the month` = cut(log10_handle, c(-Inf, 6, 7, 8, Inf), labels = c("Under $1 million", "$1 million to under $10 million", "$10 million to under $100 million", "$100 million or more"), right = FALSE)) %>%
  group_by(`Dollars wagered in the month`) %>% fp_summary()
save_tbl(t7b, "eda_07b_free_play_by_size_band")

# ---- 8. No tax paid by operator type ----
t8 <- d %>% group_by(`Operator type` = operator_type) %>%
  summarise(`Months (rows)` = n(), `Months with no state tax paid` = sum(paid_no_tax), `Months with tax paid` = sum(paid_no_tax == 0),
            `Share with no state tax paid (percent)` = r2(100 * mean(paid_no_tax)), .groups = "drop") %>% mutate(`Fewer than 30 rows` = small(`Months (rows)`))
save_tbl(t8, "eda_08_no_tax_by_operator_type")

# ---- 9. No tax paid by year within operator type ----
t9 <- d %>% group_by(Year = year, `Operator type` = operator_type) %>%
  summarise(`Months (rows)` = n(), `Months with no state tax paid` = sum(paid_no_tax), `Share with no state tax paid (percent)` = r2(100 * mean(paid_no_tax)), .groups = "drop") %>%
  mutate(`Fewer than 30 rows` = small(`Months (rows)`))
save_tbl(t9, "eda_09_no_tax_by_year_and_type")

# ---- 10. Free play per $100 by age of the sportsbook within operator type ----
t10 <- d %>% mutate(`Months the operator has been active` = cut(months_active, c(0, 6, 12, 24, 48, Inf), labels = c("1 to 6", "7 to 12", "13 to 24", "25 to 48", "49 or more"))) %>%
  group_by(`Operator type` = operator_type, `Months the operator has been active`) %>% fp_summary()
save_tbl(t10, "eda_10_free_play_by_age_and_type")

# ---- 11. How much the unusual months move the answers ----
sets <- list(`All rows` = d, `Without the 21 lump-deduction months` = filter(d, lump_deduction == 0), `Without the 15 first months` = filter(d, first_active_month == 0),
             `Without both` = filter(d, lump_deduction == 0, first_active_month == 0))
t11 <- bind_rows(lapply(names(sets), function(nm) {
  s <- sets[[nm]]; top <- s %>% group_by(operator_short) %>% summarise(m = median(free_play_per_100, na.rm = TRUE), .groups = "drop") %>% arrange(desc(m))
  yr <- s %>% group_by(year) %>% summarise(m = median(free_play_per_100, na.rm = TRUE), .groups = "drop")
  tibble(`Rows used` = nm, `Months (rows)` = nrow(s), `Months with a value` = sum(!is.na(s$free_play_per_100)),
         `Median free play per $100 wagered` = r2(median(s$free_play_per_100, na.rm = TRUE)), `Mean free play per $100 wagered` = r2(mean(s$free_play_per_100, na.rm = TRUE)),
         `Share at $5 or more per $100 (percent)` = r2(100 * mean(s$free_play_per_100 >= 5, na.rm = TRUE)),
         `Three operators with the highest median` = paste(sprintf("%s (%.2f)", top$operator_short[1:3], top$m[1:3]), collapse = "; "),
         `Median in 2021` = r2(yr$m[yr$year == 2021]), `Median in 2026` = r2(yr$m[yr$year == 2026]))
}))
save_tbl(t11, "eda_11_unusual_months")
t11b <- d %>% filter(is.na(free_play_per_100) | is.na(kept_per_100) | lump_deduction == 1 | first_active_month == 1) %>%
  transmute(Operator = operator_short, Month = month_date, `Dollars wagered` = round(handle, 2), `Free play per $100 wagered` = r2(free_play_per_100), `Kept per $100 wagered` = r2(kept_per_100),
            `Missing free play value` = ifelse(is.na(free_play_per_100), "yes", ""), `Lump deduction flag` = lump_deduction, `First active month flag` = first_active_month) %>% arrange(Operator, Month)
save_tbl(t11b, "eda_11b_unusual_month_list")
t11c <- d %>% group_by(Year = year) %>% summarise(`Months (rows)` = n(), `Lump-deduction months` = sum(lump_deduction), `First active months` = sum(first_active_month), `Months missing a free play value` = sum(is.na(free_play_per_100)), .groups = "drop")
save_tbl(t11c, "eda_11c_unusual_months_by_year")

# ---- 12. Correlation matrix (Prompt 6.4) ----
labels <- c(
  free_play_per_100 = "Free play per $100 wagered", paid_no_tax = "Paid no state tax (1 = yes)",
  prior_free_play_per_100 = "Prior month: free play per $100", prior_paid_no_tax = "Prior month: paid no tax (1 = yes)",
  prior_kept_per_100 = "Prior month: kept per $100", prior_log10_handle = "Prior month: size (log10 dollars wagered)",
  kept_per_100 = "Kept per $100 wagered", log10_handle = "Size (log10 dollars wagered)", months_active = "Months active",
  commercial = "Commercial operator (1 = yes)", first_active_month = "First active month (1 = yes)", lump_deduction = "Lump deduction (1 = yes)",
  handle = "Dollars wagered", gross_receipts = "Gross receipts", adjusted_gross_receipts = "Adjusted gross receipts",
  state_tax_or_payment = "State tax or payment", free_play_deduction = "Free play deducted (dollars)", year = "Year", month = "Month of the year (1 to 12)")
m <- d %>% mutate(commercial = as.integer(operator_type == "commercial")) %>% select(all_of(names(labels)))
# A first active month never has a prior month, so those pairs have no variation and come out as NA (not available).
cm <- suppressWarnings(cor(m, use = "pairwise.complete.obs"))
nn <- crossprod(!is.na(as.matrix(m)))
cm_out <- as.data.frame(round(cm, 2)); names(cm_out) <- unname(labels); cm_out <- cbind(Variable = unname(labels), cm_out)
save_tbl(cm_out, "eda_12_correlation_matrix")
pairs <- which(upper.tri(cm), arr.ind = TRUE)
t12b <- tibble(`Variable 1` = unname(labels[rownames(cm)[pairs[, 1]]]), `Variable 2` = unname(labels[colnames(cm)[pairs[, 2]]]),
               Correlation = round(cm[pairs], 2), `Rows used` = nn[pairs]) %>% filter(!is.na(Correlation), abs(Correlation) >= 0.2) %>% arrange(desc(abs(Correlation)))
save_tbl(t12b, "eda_12b_correlation_pairs_0.2_or_more")
top_for <- function(target) {
  o <- setdiff(names(labels), target); r <- cm[o, target]; k <- order(-abs(r))
  tibble(Target = unname(labels[target]), Variable = unname(labels[o[k]]), Correlation = round(r[k], 2), `Rows used` = nn[o[k], target])
}
save_tbl(bind_rows(top_for("free_play_per_100"), top_for("paid_no_tax")), "eda_12c_correlations_with_each_target")

# Comparison with the Part 2 screen: the same correlations before the two
# cleaning steps that set values to missing (steps 6 and 8).
before <- m %>% mutate(free_play_per_100 = 100 * (gross_receipts - adjusted_gross_receipts) / handle, kept_per_100 = 100 * gross_receipts / handle)
ord <- order(d$operator, d$month_date); stopifnot(identical(ord, seq_len(nrow(d))))
has_prior <- !is.na(d$prior_log10_handle)
before$prior_free_play_per_100 <- ifelse(has_prior, dplyr::lag(before$free_play_per_100), NA)
before$prior_kept_per_100      <- ifelse(has_prior, dplyr::lag(before$kept_per_100), NA)
cm0 <- suppressWarnings(cor(before, use = "pairwise.complete.obs"))
t12d <- tibble(`Variable 1` = unname(labels[rownames(cm)[pairs[, 1]]]), `Variable 2` = unname(labels[colnames(cm)[pairs[, 2]]]),
               `Correlation before steps 6 and 8` = round(cm0[pairs], 2), `Correlation in the cleaned data` = round(cm[pairs], 2)) %>%
  mutate(Change = round(`Correlation in the cleaned data` - `Correlation before steps 6 and 8`, 2)) %>% filter(abs(Change) > 0.05) %>% arrange(desc(abs(Change))) %>%
  mutate(`Cleaning steps responsible` = "Step 6 (rates blanked where dollars wagered is under $10,000) and step 8 (negative deductions blanked); see eda_12e for each step alone")
save_tbl(t12d, "eda_12d_correlation_changes_after_cleaning")
# Which step is responsible: apply each blanking alone
only6 <- before; tiny <- d$handle < 10000; only6$free_play_per_100[tiny] <- NA; only6$kept_per_100[tiny] <- NA
only6$prior_free_play_per_100 <- ifelse(has_prior, dplyr::lag(only6$free_play_per_100), NA); only6$prior_kept_per_100 <- ifelse(has_prior, dplyr::lag(only6$kept_per_100), NA)
only8 <- before; negd <- (d$gross_receipts - d$adjusted_gross_receipts) < -0.005; only8$free_play_per_100[negd] <- NA
only8$prior_free_play_per_100 <- ifelse(has_prior, dplyr::lag(only8$free_play_per_100), NA)
c6 <- suppressWarnings(cor(only6, use = "pairwise.complete.obs")); c8 <- suppressWarnings(cor(only8, use = "pairwise.complete.obs"))
t12e <- tibble(`Variable 1` = unname(labels[rownames(cm)[pairs[, 1]]]), `Variable 2` = unname(labels[colnames(cm)[pairs[, 2]]]),
               `Before steps 6 and 8` = round(cm0[pairs], 2), `With step 6 only` = round(c6[pairs], 2), `With step 8 only` = round(c8[pairs], 2), `Cleaned data (both)` = round(cm[pairs], 2)) %>%
  filter(abs(`Cleaned data (both)` - `Before steps 6 and 8`) > 0.05) %>% arrange(desc(abs(`Cleaned data (both)` - `Before steps 6 and 8`)))
save_tbl(t12e, "eda_12e_correlation_changes_by_step")

# Heat map: the variables that matter for the two targets, value printed in each cell,
# color scale centered on zero. The full matrix is in eda_12_correlation_matrix.csv.
show <- c("free_play_per_100", "paid_no_tax", "prior_free_play_per_100", "prior_paid_no_tax", "prior_kept_per_100", "prior_log10_handle",
          "kept_per_100", "log10_handle", "months_active", "commercial", "first_active_month", "lump_deduction")
hm <- as.data.frame(as.table(cm[show, show]), stringsAsFactors = FALSE) %>%
  mutate(x = factor(labels[Var1], levels = labels[show]), y = factor(labels[Var2], levels = rev(labels[show])))
n_min <- min(nn[show, show]); n_max <- max(nn[show, show])
p12 <- ggplot(hm, aes(x, y, fill = Freq)) + geom_tile(colour = "white", linewidth = 0.4) +
  geom_text(aes(label = ifelse(is.na(Freq), "n/a", sprintf("%.2f", Freq)), colour = !is.na(Freq) & abs(Freq) > 0.6), size = 2.6, show.legend = FALSE) +
  scale_colour_manual(values = c(`TRUE` = "white", `FALSE` = "#222222")) +
  scale_fill_gradient2(low = project_colors$diverging[["negative"]], mid = project_colors$diverging[["zero"]], high = project_colors$diverging[["positive"]],
                       midpoint = 0, limits = c(-1, 1), name = "Correlation", na.value = "#F2F2F2") +
  scale_x_discrete(position = "top", labels = function(v) str_wrap(v, 16)) + scale_y_discrete(labels = function(v) str_wrap(v, 30)) +
  # Title: a finding, in the AI assistant's draft wording (assistant_drafts.md, section B); Brennan keeps or changes it.
  labs(title = wrap_title("Among things known before the month starts, each target is most closely tied to its own value the month before (0.59 and 0.79)", 74),
       subtitle = "Straight-line correlation, -1 to 1; orange is positive, blue is negative",
       x = NULL, y = NULL,
       caption = paste0("Source: Michigan Gaming Control Board, internet sports betting revenues and taxes, 2021 to 2026.\nRows used per pair: ", n_min, " to ", n_max,
                        " operator-months (pairs with a prior-month or missing value use fewer).\nn/a: cannot be computed, because a first active month never has a prior month. Full matrix: output/tables/eda_12_correlation_matrix.csv.")) +
  theme_project(base_size = 9) + theme(axis.text.x = element_text(angle = 90, hjust = 0, vjust = 0.5, size = 6.5), axis.text.y = element_text(size = 7),
                                       panel.grid = element_blank(), legend.position = "right", legend.justification = "center")
save_figure(p12, "fig12_correlation_heatmap", height_in = 6.3)

message(sprintf("05_eda: wrote %d tables to output/tables and the correlation heat map. Rows read: %d.", length(list.files(out_dir, pattern = "^eda_")), nrow(d)))
