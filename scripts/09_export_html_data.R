# 09_export_html_data.R
# Builds, from the processed data and the saved tables, exactly the data each
# view of the web page needs (documentation/interactive_plan.md), and writes
# them into the marked block inside docs/index.html (course Prompts 11.1, 11.2).
# It also fills in every number and figure title in the page's text from
# output/tables/report_numbers.csv and documentation/figure_titles.csv, so no
# number on the page is typed by hand and the page matches the static report.
# The page itself (text, layout, style, charts) is hand-written HTML, CSS and
# JavaScript; this script only writes data into it.
#
# Reads:  data/processed/mgcb_operator_months.csv, output/tables/*.csv,
#         documentation/figure_titles.csv, output/palette.json, docs/index.html
# Writes: docs/index.html (data block, numbers, titles), output/page_data.json,
#         output/tables/html_data_checks.csv, output/tables/explorer_checks.csv

suppressPackageStartupMessages({library(dplyr); library(jsonlite)})
d <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE)
tb <- function(name) read.csv(file.path("output", "tables", paste0(name, ".csv")), check.names = FALSE, stringsAsFactors = FALSE)
r2 <- function(x) round(x, 2)
d$commercial <- as.integer(d$operator_type == "commercial")
d$label <- paste0(d$platform_latest, " (", d$operator_short, ")")

# Operators in the order of figure 3 (largest share of wagering first)
e3 <- tb("eda_03_size_by_operator"); e4 <- tb("eda_04_free_play_by_operator")
ops <- e3$Operator
op_tbl <- lapply(ops, function(o) {
  x <- d[d$operator_short == o, ]; v <- x$free_play_per_100[!is.na(x$free_play_per_100)]; bs <- boxplot.stats(v)   # whiskers by the usual 1.5 x box rule, as in the prototype
  list(short = o, brand = x$platform_latest[1], label = x$label[1], type = x$operator_type[1], share = e3[["Share of all dollars wagered (percent)"]][e3$Operator == o],
       months = length(v), q1 = r2(quantile(v, 0.25, names = FALSE)), median = r2(median(v)), q3 = r2(quantile(v, 0.75, names = FALSE)),
       low = r2(min(v[v >= quantile(v, 0.25) - 1.5 * IQR(v)])), high = r2(max(v[v <= quantile(v, 0.75) + 1.5 * IQR(v)])), max = r2(max(v)))
})

# Row-level data for the explorer, the box plot points and the model scatter (923 rows; no sampling)
rows <- d %>% transmute(o = match(operator_short, ops) - 1, m = substr(month_date, 1, 7), y = year, h = round(handle, 2), f = round(free_play_per_100, 4), t = paid_no_tax, l = lump_deduction, a = first_active_month)

# Figure 1: the same $1 bands as the prototype
v <- d$free_play_per_100[!is.na(d$free_play_per_100)]
fig01 <- list(rows = length(v), q1 = r2(quantile(v, 0.25, names = FALSE)), median = r2(median(v)), q3 = r2(quantile(v, 0.75, names = FALSE)), max = r2(max(v)),
              n10 = sum(v >= 10), bands = as.integer(table(factor(pmin(floor(v), 20), levels = 0:20))))

e9 <- tb("eda_09_no_tax_by_year_and_type"); e10 <- tb("eda_10_free_play_by_age_and_type")
fig09 <- lapply(seq_len(nrow(e9)), function(i) list(year = e9$Year[i], type = e9[["Operator type"]][i], months = e9[["Months (rows)"]][i], no_tax = e9[["Months with no state tax paid"]][i], share = e9[["Share with no state tax paid (percent)"]][i]))
fig10 <- lapply(seq_len(nrow(e10)), function(i) list(type = e10[["Operator type"]][i], band = e10[[2]][i], months = e10[["Months with a value"]][i], q1 = e10[["Lower quartile"]][i], median = e10[["Median free play per $100 wagered"]][i], q3 = e10[["Upper quartile"]][i]))

# Figure 12: the 12 variables of the prototype, with the rows used for each pair
hm <- c(free_play_per_100 = "Free play per $100 wagered", paid_no_tax = "Paid no state tax (1 = yes)", prior_free_play_per_100 = "Prior month: free play per $100",
        prior_paid_no_tax = "Prior month: paid no tax (1 = yes)", prior_kept_per_100 = "Prior month: kept per $100", prior_log10_handle = "Prior month: size (log10 dollars wagered)",
        kept_per_100 = "Kept per $100 wagered", log10_handle = "Size (log10 dollars wagered)", months_active = "Months active", commercial = "Commercial operator (1 = yes)",
        first_active_month = "First active month (1 = yes)", lump_deduction = "Lump deduction (1 = yes)")
X <- d[names(hm)]
cmat <- suppressWarnings(cor(X, use = "pairwise.complete.obs"))   # undefined for a first month against a prior-month variable; shown as n/a
nmat <- crossprod(!is.na(as.matrix(X)))
e12 <- tb("eda_12_correlation_matrix"); saved <- unname(data.matrix(e12[match(hm, e12$Variable), hm]))
calc <- unname(round(cmat, 2))
if (!identical(dim(calc), dim(saved)) || any(is.na(calc) != is.na(saved)) || max(abs(calc - saved), na.rm = TRUE) > 1e-9) stop("Heat map values differ from output/tables/eda_12_correlation_matrix.csv")
fig12 <- list(labels = unname(hm), r = lapply(seq_len(nrow(calc)), function(i) calc[i, ]), n = lapply(seq_len(nrow(nmat)), function(i) unname(nmat[i, ])))

# Models: refit exactly as scripts/07_models.R does, and stop if the estimates differ from the saved tables
fit <- function(target, preds) { u <- d[complete.cases(d[c(target, preds)]), ]; list(u = u, f = lm(reformulate(preds, target), data = u)) }
m1 <- fit("free_play_per_100", c("prior_free_play_per_100", "months_active", "commercial")); m2 <- fit("paid_no_tax", c("prior_paid_no_tax", "prior_log10_handle", "commercial"))
if (!isTRUE(all.equal(unname(coef(m1$f)), tb("model1_estimates")$Estimate)) || !isTRUE(all.equal(unname(coef(m2$f)), tb("model2_estimates")$Estimate))) stop("Model estimates differ from the saved tables")
m1pts <- data.frame(o = match(m1$u$operator_short, ops) - 1, m = substr(m1$u$month_date, 1, 7), p = r2(fitted(m1$f)), a = r2(m1$u$free_play_per_100))
p2 <- fitted(m2$f); bin2 <- floor(p2 / 0.05 + 1e-9)
m2bins <- lapply(sort(unique(bin2)), function(b) list(lower = round(b * 0.05, 2), yes = sum(bin2 == b & m2$u$paid_no_tax == 1), no = sum(bin2 == b & m2$u$paid_no_tax == 0)))

num <- tb("report_numbers"); titles <- read.csv(file.path("documentation", "figure_titles.csv"), stringsAsFactors = FALSE)
page <- list(numbers = as.list(setNames(num$value, num$key)), titles = as.list(setNames(titles$title, titles$figure)),
             palette = fromJSON(file.path("output", "palette.json")), operators = op_tbl, rows = rows, fig01 = fig01, fig09 = fig09, fig10 = fig10, fig12 = fig12,
             m1 = m1pts, m2 = list(rows = length(p2), bins = m2bins))
json <- toJSON(page, auto_unbox = TRUE, dataframe = "columns", digits = NA, na = "null")
json <- gsub("</", "<\\/", json, fixed = TRUE)
writeLines(json, file.path("output", "page_data.json"))

# ---- One number per view next to the same number in output/tables (Prompt 11.1, Verify) ----
e1 <- tb("eda_01_free_play_spread"); e1v <- setNames(e1[[2]], e1[[1]]); e2 <- tb("eda_02_paid_no_tax_share"); mf <- tb("model_fit"); ct <- tb("model2_classification_table")
chk <- function(view, what, page_value, table_value, file) data.frame(View = view, `What was compared` = what, `Value in the page data` = page_value, `Value in the table` = table_value, `Table file` = file,
                                                                       Equal = ifelse(isTRUE(all.equal(as.numeric(page_value), as.numeric(table_value))), "yes", "NO"), check.names = FALSE)
checks <- bind_rows(
  chk("Figure 1", "Months in the 21 bars added together", sum(fig01$bands), e1v[["Rows with a value"]], "eda_01_free_play_spread.csv"),
  chk("Figure 3", "Largest share of all dollars wagered", op_tbl[[1]]$share, e3[["Share of all dollars wagered (percent)"]][1], "eda_03_size_by_operator.csv"),
  chk("Figure 4", "Median for the first operator in eda_04", op_tbl[[match(e4$Operator[1], ops)]]$median, e4[["Median free play per $100 wagered"]][1], "eda_04_free_play_by_operator.csv"),
  chk("Figure 9", "Months with no tax, all 12 points added", sum(vapply(fig09, function(z) z$no_tax, 1)), e2[[2]][grepl("^Yes", e2[[1]])], "eda_02_paid_no_tax_share.csv"),
  chk("Figure 10", "Months behind the 10 points added", sum(vapply(fig10, function(z) z$months, 1)), e1v[["Rows with a value"]], "eda_01_free_play_spread.csv"),
  chk("Figure 12", "Correlation of the two targets", fig12$r[[1]][2], e12[["Paid no state tax (1 = yes)"]][e12$Variable == "Free play per $100 wagered"], "eda_12_correlation_matrix.csv"),
  chk("Model 1 scatter", "Points", nrow(m1pts), mf[["Rows used"]][1], "model_fit.csv"),
  chk("Model 2 histogram", "Months predicted at 0.5 or more", sum(vapply(m2bins, function(z) if (z$lower >= 0.5) z$yes + z$no else 0L, 1)), ct[3, 2], "model2_classification_table.csv"),
  chk("Explorer rows", "Rows", nrow(rows), e1v[["Operator-months (rows)"]], "eda_01_free_play_spread.csv"),
  chk("Explorer rows", "Months with no state tax", sum(rows$t), e2[[2]][grepl("^Yes", e2[[1]])], "eda_02_paid_no_tax_share.csv"))
write.csv(checks, file.path("output", "tables", "html_data_checks.csv"), row.names = FALSE)
if (any(checks$Equal != "yes")) stop("A page-data check failed; see output/tables/html_data_checks.csv")

# ---- What the explorer should show for four settings, computed here and not by the page (Prompt 11.4, Verify) ----
explore <- function(name, keep) { x <- d[keep, ]; v <- x$free_play_per_100[!is.na(x$free_play_per_100)]
  data.frame(Setting = name, `Sportsbook-months chosen` = nrow(x), `Months with a free play value` = length(v), `Median free play per $100` = sprintf("%.2f", median(v)),
             `Share at $10 or more (percent)` = sprintf("%.2f", 100 * mean(v >= 10)), `Months with no state tax` = sum(x$paid_no_tax), `Share with no state tax (percent)` = sprintf("%.2f", 100 * mean(x$paid_no_tax)),
             `Total dollars wagered` = format(round(sum(x$handle)), big.mark = ",", scientific = FALSE, trim = TRUE), check.names = FALSE) }
flag <- d$lump_deduction == 1 | d$first_active_month == 1
write.csv(bind_rows(explore("All 15 sportsbooks, 2021 to 2026, flagged months included (the starting values)", rep(TRUE, nrow(d))),
                    explore("Tribal only, 2021 to 2021, flagged months included", d$operator_type == "tribal" & d$year == 2021),
                    explore("Commercial only, 2024 to 2025, flagged months left out", d$operator_type == "commercial" & d$year %in% 2024:2025 & !flag),
                    explore("FanDuel (MotorCity), 2021 to 2026, flagged months left out", d$operator_short == "MotorCity" & !flag)),
          file.path("output", "tables", "explorer_checks.csv"), row.names = FALSE)

# ---- Write the data, the numbers and the titles into the page ----
path <- file.path("docs", "index.html")
if (file.exists(path)) {
  html <- paste(readLines(path, warn = FALSE), collapse = "\n")
  m <- regexpr("<!-- DATA:START -->.*<!-- DATA:END -->", html)
  if (m < 0) stop("docs/index.html has no data block markers")
  block <- paste0("<!-- DATA:START -->\n<script id=\"page-data\" type=\"application/json\">", json, "</script>\n<!-- DATA:END -->")
  html <- paste0(substr(html, 1, m - 1), block, substr(html, m + attr(m, "match.length"), nchar(html)))
  fill <- function(html, attr, values, what) {
    pat <- paste0("(<([a-z0-9]+)[^>]*\\s", attr, "=\"([^\"]+)\"[^>]*>)[^<]*(</\\2>)")
    hits <- gregexpr(pat, html, perl = TRUE)[[1]]; if (hits[1] < 0) return(html)
    found <- regmatches(html, list(hits))[[1]]; keys <- sub(pat, "\\3", found, perl = TRUE)
    if (any(!keys %in% names(values))) stop("The page asks for ", what, " that do not exist: ", paste(unique(keys[!keys %in% names(values)]), collapse = ", "))
    esc <- function(x) gsub("\"", "&quot;", gsub(">", "&gt;", gsub("<", "&lt;", gsub("&", "&amp;", x, fixed = TRUE), fixed = TRUE), fixed = TRUE), fixed = TRUE)
    new <- mapply(function(f, k) paste0(sub(pat, "\\1", f, perl = TRUE), esc(values[[k]]), sub(pat, "\\4", f, perl = TRUE)), found, keys)   # the value is pasted in, never used as a pattern
    regmatches(html, list(hits)) <- list(new); html
  }
  html <- fill(html, "data-n", page$numbers, "numbers"); html <- fill(html, "data-title", page$titles, "figure titles")
  writeLines(html, path)
  message(sprintf("09_export_html_data: wrote %s of data into docs/index.html (%d rows for the explorer, %d model points); page is %s in all. %d of %d checks equal.",
                  format(structure(nchar(json, "bytes"), class = "object_size"), units = "Kb"), nrow(rows), nrow(m1pts), format(structure(file.size(path), class = "object_size"), units = "Kb"), sum(checks$Equal == "yes"), nrow(checks)))
} else message("09_export_html_data: docs/index.html does not exist yet; wrote output/page_data.json only.")
