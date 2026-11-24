# 07_models.R
# Fits the two models Brennan planned (course Prompts 8.2 and 8.3).
# Ordinary linear regression only, on all rows of the processed data that have
# a value for the target and every predictor. No train/test split, no variable
# selection, no transformation beyond what is in the processed file, and no
# trimming, rounding or capping of predictions. No interpretation is written.
#
# Model 1 (regression problem):      free_play_per_100 ~ prior_free_play_per_100 + months_active + operator type
# Model 2 (classification problem):  paid_no_tax       ~ prior_paid_no_tax + prior_log10_handle + operator type
#                                    (a linear probability model; cutoff 0.5)
# Predictors were chosen by Brennan on 2026-11-23 (decision D-023), and the
# direction he expects for each slope was recorded before this script existed.
#
# Reads:  data/processed/mgcb_operator_months.csv
# Writes: output/tables/model1_estimates.csv, model2_estimates.csv, model_equations.csv,
#         model_fit.csv, model_rows_left_out.csv, model2_classification_table.csv,
#         model_hand_predictions.csv
#         output/figures/fig_m1_predicted_vs_actual, fig_m1_errors_vs_predicted,
#         fig_m2_predicted_probability (PNG and PDF each)

suppressPackageStartupMessages({library(dplyr); library(tidyr); library(ggplot2)})
source(file.path("scripts", "00_style.R"))
set.seed(314)   # only used to pick three rows for the hand-calculated predictions

d <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE)
# Operator type enters as a 0/1 column: 1 = commercial, 0 = tribal. Tribal is the
# category the other is compared with (the reference category).
d$commercial <- as.integer(d$operator_type == "commercial")
tbl_dir <- file.path("output", "tables")
save_tbl <- function(x, name) write.csv(x, file.path(tbl_dir, paste0(name, ".csv")), row.names = FALSE, na = "")

labels <- c(`(Intercept)` = "Intercept (a tribal operator with every numeric predictor at zero)",
            prior_free_play_per_100 = "Prior month: free play per $100 wagered",
            months_active = "Months the operator has been active",
            commercial = "Commercial operator (1 = commercial, 0 = tribal)",
            prior_paid_no_tax = "Prior month: paid no state tax (1 = yes, 0 = no)",
            prior_log10_handle = "Prior month: size (log10 of dollars wagered)")

specs <- list(
  model1 = list(target = "free_play_per_100", target_label = "Free play per $100 wagered", preds = c("prior_free_play_per_100", "months_active", "commercial")),
  model2 = list(target = "paid_no_tax", target_label = "Probability of paying no state tax", preds = c("prior_paid_no_tax", "prior_log10_handle", "commercial"))
)

fits <- list(); used <- list(); left_out <- list(); eqs <- list(); fit_rows <- list(); hand <- list()
for (m in names(specs)) {
  s <- specs[[m]]; vars <- c(s$target, s$preds)
  complete <- complete.cases(d[vars])
  # Rows left out, and the first variable (in the order target, predictors) that is missing for each
  first_missing <- apply(is.na(d[!complete, vars, drop = FALSE]), 1, function(r) vars[which(r)[1]])
  no_prior <- is.na(d$prior_log10_handle[!complete])
  cause <- ifelse(no_prior, "No prior month in the data for this operator (first active month, or first month after a pause)",
                  paste0("Missing value of ", first_missing, " (set to missing in cleaning steps 6 or 8)"))
  left_out[[m]] <- as.data.frame(table(cause), stringsAsFactors = FALSE) %>% transmute(Model = m, `Why the row was left out` = cause, Rows = Freq)
  u <- d[complete, ]; used[[m]] <- u
  f <- lm(reformulate(s$preds, s$target), data = u); fits[[m]] <- f
  co <- summary(f)$coefficients
  est <- tibble(Term = rownames(co), Label = unname(labels[rownames(co)]), Estimate = co[, "Estimate"], `Standard error` = co[, "Std. Error"],
                `t value` = co[, "t value"], `p value` = co[, "Pr(>|t|)"])
  save_tbl(est, paste0(m, "_estimates"))
  b <- coef(f)
  eqs[[m]] <- tibble(Model = m, Equation = paste0(s$target_label, " = ", sprintf("%.4f", b[1]), paste(sprintf(" %s %.4f x [%s]", ifelse(b[-1] < 0, "-", "+"), abs(b[-1]), labels[names(b)[-1]]), collapse = "")))
  pred <- fitted(f); res <- resid(f)
  fit_rows[[m]] <- tibble(Model = m, Target = s$target, `Rows in the processed data` = nrow(d), `Rows used` = nrow(u), `Rows left out` = nrow(d) - nrow(u),
                          `R-squared` = summary(f)$r.squared, `Root mean squared error (target units)` = sqrt(mean(res^2)))
  # Three rows, prediction worked out step by step from the fitted equation
  pick <- sort(sample(seq_len(nrow(u)), 3))
  hand[[m]] <- bind_rows(lapply(pick, function(i) {
    x <- unlist(u[i, s$preds]); terms <- b[-1] * x
    tibble(Model = m, Operator = u$operator_short[i], Month = u$month_date[i],
           `Predictor values` = paste(sprintf("%s = %s", s$preds, format(round(x, 4), trim = TRUE)), collapse = "; "),
           `Step by step` = paste0(sprintf("%.4f", b[1]), paste(sprintf(" %s %.4f x %s", ifelse(b[-1] < 0, "-", "+"), abs(b[-1]), format(round(x, 4), trim = TRUE)), collapse = ""),
                                   " = ", sprintf("%.4f", b[1] + sum(terms))),
           `Prediction by hand` = round(b[1] + sum(terms), 4), `Prediction from the script` = round(unname(pred[i]), 4), Actual = round(u[[s$target]][i], 4))
  }))
}
save_tbl(bind_rows(left_out), "model_rows_left_out")
save_tbl(bind_rows(eqs), "model_equations")
save_tbl(bind_rows(hand), "model_hand_predictions")

# ---- Model 2: classification measures (cutoff 0.5; nothing trimmed) ----
u2 <- used$model2; p2 <- fitted(fits$model2)
pred_yes <- as.integer(p2 >= 0.5)
tab <- table(Actual = u2$paid_no_tax, Predicted = pred_yes)
get <- function(a, p) if (as.character(a) %in% rownames(tab) && as.character(p) %in% colnames(tab)) tab[as.character(a), as.character(p)] else 0L
ct <- tibble(` ` = c("Actual: paid no tax (yes)", "Actual: paid tax (no)", "Total"),
             `Predicted yes (0.5 or more)` = c(get(1, 1), get(0, 1), sum(pred_yes == 1)),
             `Predicted no (under 0.5)` = c(get(1, 0), get(0, 0), sum(pred_yes == 0)),
             Total = c(sum(u2$paid_no_tax == 1), sum(u2$paid_no_tax == 0), nrow(u2)))
save_tbl(ct, "model2_classification_table")
share_yes <- mean(u2$paid_no_tax)
fit_tbl <- bind_rows(fit_rows) %>% mutate(
  `Smallest prediction` = c(min(fitted(fits$model1)), min(p2)), `Largest prediction` = c(max(fitted(fits$model1)), max(p2)),
  `Predictions below 0` = c(NA, sum(p2 < 0)), `Predictions above 1` = c(NA, sum(p2 > 1)),
  `Share of predictions outside 0 to 1 (percent)` = c(NA, 100 * mean(p2 < 0 | p2 > 1)),
  `Share classified correctly at 0.5 (percent)` = c(NA, 100 * mean(pred_yes == u2$paid_no_tax)),
  `More common category` = c(NA, ifelse(share_yes >= 0.5, "paid no tax (yes)", "paid tax (no)")),
  `Share correct by always guessing the more common category (percent)` = c(NA, 100 * max(share_yes, 1 - share_yes)),
  `Share of yes rows in the rows used (percent)` = c(NA, 100 * share_yes),
  `Average predicted probability (percent)` = c(NA, 100 * mean(p2)))
save_tbl(fit_tbl, "model_fit")

# ---- Figures (project style; neutral titles until Brennan writes the findings) ----
u1 <- used$model1; u1$predicted <- fitted(fits$model1); u1$error <- resid(fits$model1)
u1$Operator_type <- u1$operator_type
lim <- range(c(u1$predicted, u1$free_play_per_100))
g1 <- ggplot(u1, aes(predicted, free_play_per_100, colour = Operator_type)) +
  geom_abline(slope = 1, intercept = 0, colour = "#555555", linetype = "dashed") + geom_point(alpha = 0.55, size = 1.3) +
  scale_colour_manual(values = project_colors$operator_type, name = "Operator type") + coord_equal(xlim = lim, ylim = lim) +
  labs(title = wrap_title("Model 1: predicted against actual free play per $100 wagered"), subtitle = "Dashed line: prediction equals actual",
       x = "Predicted free play per $100 wagered (dollars)", y = "Actual free play per $100 wagered (dollars)", caption = caption_source(nrow(u1), "In-sample: fit is measured on the rows used to fit.")) + theme_project()
save_figure(g1, "fig_m1_predicted_vs_actual", height_in = 6.2)
g2 <- ggplot(u1, aes(predicted, error, colour = Operator_type)) + geom_hline(yintercept = 0, colour = "#555555", linetype = "dashed") + geom_point(alpha = 0.55, size = 1.3) +
  scale_colour_manual(values = project_colors$operator_type, name = "Operator type") +
  labs(title = wrap_title("Model 1: prediction errors against predicted values"), subtitle = "Error = actual minus predicted",
       x = "Predicted free play per $100 wagered (dollars)", y = "Prediction error (dollars per $100 wagered)", caption = caption_source(nrow(u1), "In-sample: fit is measured on the rows used to fit.")) + theme_project()
save_figure(g2, "fig_m1_errors_vs_predicted", height_in = 4.4)
u2$predicted <- p2; u2$Actual <- factor(ifelse(u2$paid_no_tax == 1, "Paid no tax", "Paid tax"), levels = c("Paid no tax", "Paid tax"))
g3 <- ggplot(u2, aes(predicted, fill = Actual)) + annotate("rect", xmin = -Inf, xmax = 0, ymin = -Inf, ymax = Inf, fill = "#F2F2F2") + annotate("rect", xmin = 1, xmax = Inf, ymin = -Inf, ymax = Inf, fill = "#F2F2F2") +
  geom_histogram(binwidth = 0.05, boundary = 0, colour = "white", linewidth = 0.2) + geom_vline(xintercept = 0.5, linetype = "dashed", colour = "#555555") +
  facet_wrap(~ Actual, ncol = 1) + scale_fill_manual(values = project_colors$paid_no_tax, guide = "none") +
  labs(title = wrap_title("Model 2: predicted probability of paying no state tax, by what actually happened"), subtitle = "Dashed line: the 0.5 cutoff. Shaded: predictions below 0 or above 1",
       x = "Predicted probability of paying no state tax", y = "Operator-months", caption = caption_source(nrow(u2), "In-sample: fit is measured on the rows used to fit.")) + theme_project()
save_figure(g3, "fig_m2_predicted_probability", height_in = 5)

message(sprintf("07_models: model 1 used %d rows (R-squared %.3f, RMSE %.2f); model 2 used %d rows (R-squared %.3f, %d predictions outside 0 to 1).",
                nrow(u1), summary(fits$model1)$r.squared, sqrt(mean(resid(fits$model1)^2)), nrow(u2), summary(fits$model2)$r.squared, sum(p2 < 0 | p2 > 1)))
