# 10_number_audit.R
# Audits every number in the static report, the web page and the figure titles
# (course Prompts 10.2 and 11.5). It changes nothing in either report.
#
# How the reports are built: a number that comes from the analysis is never
# typed. In the LaTeX it is \V{key}; in the page it sits in an element marked
# data-n="key". Both are filled from output/tables/report_numbers.csv, which
# names the file and cell each value comes from. So the audit has three jobs:
#   1. every key used exists, and the page shows exactly the value on record;
#   2. every other digit typed in the text is on a short list of things that
#      are not results (years, the $100 unit, course numbers, band labels,
#      Brennan's recorded expectations), each with its reason;
#   3. every number in a figure title equals a value on record, after rounding.
# It also checks that the page is one file that loads nothing from elsewhere
# and that each report figure has a chart in the page.
#
# Reads:  report/static/sections/*.tex, docs/index.html, documentation/figure_titles.csv,
#         output/tables/report_numbers.csv
# Writes: output/tables/number_audit.csv, documentation/number_audit.md

num <- read.csv(file.path("output", "tables", "report_numbers.csv"), stringsAsFactors = FALSE, colClasses = "character")
val <- setNames(num$value, num$key)
tokens <- function(x) { m <- regmatches(x, gregexpr("(?<![A-Za-z0-9_])[0-9][0-9,]*(\\.[0-9]+)?", x, perl = TRUE))[[1]]; sub(",$", "", m) }

# Digits that may be typed, and why. Anything else typed in the text is reported as having no source.
allowed <- c("2021" = "year", "2022" = "year", "2023" = "year", "2024" = "year", "2025" = "year", "2026" = "year",
             "100" = "the unit: free play per $100 wagered", "314-370" = "course number", "314" = "course number", "370" = "course number", "381" = "course number (BUAN 381)",
             "22" = "date: internet sports betting began on 22 January 2021 (provenance record)", "23" = "date of download, 23 November 2026 (provenance record)", "24" = "date of this draft, 24 November 2026",
             "1" = "a label: the $1 band, $1 more, $1 million, or the coding 1 = yes", "0" = "a label: the coding 0 = no, or the range 0 to 1",
             "10" = "Brennan's recorded expectation (under 10%), authored/eda_expectations.md", "50" = "Brennan's recorded expectation (50% to 70%), authored/eda_expectations.md",
             "70" = "Brennan's recorded expectation (50% to 70%), authored/eda_expectations.md", "5.2" = "name of the AI model (Claude Fable 5.2)",
             "16" = "a step number in the wrangling log (16a, 16b)", "20" = "a label on a control of the page (the $0 to $20 frame)")
# Names that carry a number but are not numbers in the text: "sub-questions 5, 6, 7 and 10", "Model 1", "Section 2".
labels_out <- function(x) gsub("(sub-questions?|Sub-questions?|Models?|Sections?|Steps?|Appendix)\\s+[0-9]+[ab]?((,| and|,? or)\\s+[0-9]+[ab]?)*", " ", x, perl = TRUE)
rows <- list(); add <- function(where, item, value, source, status) rows[[length(rows) + 1]] <<- data.frame(Where = where, Item = item, Value = value, Source = source, Status = status, stringsAsFactors = FALSE)

# ---- 1. Static report ----
tex_files <- sort(list.files(file.path("report", "static", "sections"), pattern = "\\.tex$", full.names = TRUE))
for (f in tex_files) {
  x <- readLines(f, warn = FALSE); x <- x[!grepl("^\\s*%", x)]; x <- paste(sub("(?<!\\\\)%.*$", "", x, perl = TRUE), collapse = "\n")
  keys <- regmatches(x, gregexpr("\\\\V\\{[^}]*\\}", x))[[1]]; keys <- gsub("^\\\\V\\{|\\}$", "", keys)
  for (k in unique(keys)) add(basename(f), paste0("\\V{", k, "}"), ifelse(k %in% names(val), val[[k]], ""), ifelse(k %in% names(val), paste0(num$source_file[num$key == k], " : ", num$source_cell[num$key == k]), ""), ifelse(k %in% names(val), "from a results file", "NO SOURCE: key not found"))
  y <- gsub("\\\\(V|ref|label|cite|input|url|includegraphics(\\[[^]]*\\])?|vspace\\*?|fbox|parbox|resizebox)\\{[^}]*\\}", " ", x)   # commands whose arguments are not text
  y <- gsub("\\[[^]]*(linewidth|leftmargin)[^]]*\\]|\\{[0-9.]+\\\\linewidth\\}|[0-9.]+(cm|em|pt)\\b|\\\\[A-Za-z]+", " ", y)
  y <- labels_out(y)
  for (t in unique(tokens(y))) add(basename(f), paste0("typed: ", t), t, ifelse(t %in% names(allowed), allowed[[t]], ""), ifelse(t %in% names(allowed), "not a result (allowed)", "NO SOURCE: typed number"))
}

# ---- 2. Figure titles: every number must equal a value on record, allowing for rounding ----
titles <- read.csv(file.path("documentation", "figure_titles.csv"), stringsAsFactors = FALSE)
numeric_vals <- suppressWarnings(as.numeric(gsub(",", "", num$value))); ok_num <- !is.na(numeric_vals)
for (i in seq_len(nrow(titles))) for (t in unique(tokens(titles$title[i]))) {
  tv <- as.numeric(gsub(",", "", t)); dec <- ifelse(grepl("\\.", t), nchar(sub("^[^.]*\\.", "", t)), 0)
  hit <- which(ok_num & abs(round(numeric_vals, dec) - tv) < 1e-9)
  exact <- hit[num$value[hit] == t]; pick <- if (length(exact)) exact[1] else if (length(hit)) hit[1] else NA
  if (t %in% c("100", as.character(2021:2026)) || (t == "1" && grepl("Model 1", titles$title[i])) || (t == "2" && grepl("Model 2", titles$title[i]))) { add(paste0("title of ", titles$figure[i]), paste0("typed: ", t), t, "a year, the $100 unit, or the name of the model", "not a result (allowed)"); next }
  add(paste0("title of ", titles$figure[i]), paste0("typed: ", t), t, ifelse(is.na(pick), "", paste0(num$key[pick], " = ", num$value[pick], " (", num$source_file[pick], ")", ifelse(num$value[pick] == t, "", ", rounded"))),
      ifelse(is.na(pick), "MISMATCH: no value on record equals this number", "matches a value on record"))
}

# ---- 3. The web page ----
html <- paste(readLines(file.path("docs", "index.html"), warn = FALSE), collapse = "\n")
spans <- regmatches(html, gregexpr("<[a-z0-9]+[^>]*\\sdata-n=\"[^\"]+\"[^>]*>[^<]*</", html, perl = TRUE))[[1]]
for (s in unique(spans)) { k <- sub(".*data-n=\"([^\"]+)\".*", "\\1", s); shown <- sub("^.*>([^<]*)</$", "\\1", s)
  add("docs/index.html", paste0("data-n=", k), shown, ifelse(k %in% names(val), paste0(num$source_file[num$key == k], " : ", num$source_cell[num$key == k]), ""),
      ifelse(!k %in% names(val), "NO SOURCE: key not found", ifelse(shown == val[[k]], "from a results file", paste0("MISMATCH: the page shows ", shown, ", the record says ", val[[k]])))) }
body <- gsub("(?s)<script[^>]*>.*?</script>|<style[^>]*>.*?</style>|<!--.*?-->", " ", html, perl = TRUE)
body <- gsub("<[a-z0-9]+[^>]*\\sdata-(n|title)=\"[^\"]+\"[^>]*>[^<]*</[a-z0-9]+>", " ", body, perl = TRUE)
body <- gsub("<[^>]+>", " ", body); body <- gsub("&[a-z]+;", " ", body); body <- labels_out(body)
for (t in unique(tokens(body))) add("docs/index.html", paste0("typed: ", t), t, ifelse(t %in% names(allowed), allowed[[t]], ""), ifelse(t %in% names(allowed), "not a result (allowed)", "NO SOURCE: typed number"))

# One file, nothing loaded from elsewhere; every report figure has a chart in the page
loads <- regmatches(html, gregexpr("<(script|img|link|iframe|audio|video|source|object|embed)[^>]*\\s(src|href|data)=\"[^\"]*\"|@import[^;]*;|url\\([^)]*\\)", html, perl = TRUE))[[1]]
charts <- c(fig01 = "c-fig01", fig03 = "c-fig03", fig04 = "c-fig04", fig09 = "c-fig09", fig10 = "c-fig10", fig12 = "c-fig12", fig_m1_predicted_vs_actual = "c-m1a", fig_m1_errors_vs_predicted = "c-m1b", fig_m2_predicted_probability = "c-m2")
missing_charts <- names(charts)[!vapply(charts, function(id) grepl(paste0("id=\"", id, "\""), html, fixed = TRUE), logical(1))]
used_titles <- unique(sub(".*data-title=\"([^\"]+)\".*", "\\1", regmatches(html, gregexpr("data-title=\"[^\"]+\"", html))[[1]]))
missing_titles <- setdiff(titles$figure, used_titles)

audit <- do.call(rbind, rows)
write.csv(audit, file.path("output", "tables", "number_audit.csv"), row.names = FALSE)
mism <- audit[grepl("^MISMATCH", audit$Status), ]; nosrc <- audit[grepl("^NO SOURCE", audit$Status), ]
lst <- function(d) if (nrow(d)) paste0("- ", d$Where, ": ", d$Item, " (", d$Status, ")") else "- (none)"
count <- function(where_pat, status) sum(grepl(where_pat, audit$Where) & audit$Status == status)
md <- c("# Number audit", "",
  "Written by `scripts/10_number_audit.R` each time the master script runs. It changes nothing in either report. The full list, one line per number, is `output/tables/number_audit.csv`.", "",
  "How to read it: a number that comes from the analysis is never typed. The static report reads it as `\\V{key}` and the web page holds it in an element marked `data-n`. Both are filled from `output/tables/report_numbers.csv`, which names the file and cell behind each value. Digits that are typed must be on a short list of things that are not results (years, the $100 unit, course numbers, band labels, Brennan's recorded expectations).", "",
  "| Where | Numbers read from a results file | Typed, allowed (not results) | Mismatches | No source |", "|---|---|---|---|---|",
  sprintf("| Static report (`report/static/sections`) | %d | %d | %d | %d |", count("\\.tex$", "from a results file"), count("\\.tex$", "not a result (allowed)"), sum(grepl("\\.tex$", mism$Where)), sum(grepl("\\.tex$", nosrc$Where))),
  sprintf("| Web page (`docs/index.html`) | %d | %d | %d | %d |", count("index.html", "from a results file"), count("index.html", "not a result (allowed)"), sum(grepl("index.html", mism$Where)), sum(grepl("index.html", nosrc$Where))),
  sprintf("| Figure titles (`documentation/figure_titles.csv`) | %d | %d | %d | %d |", count("^title", "matches a value on record"), count("^title", "not a result (allowed)"), sum(grepl("^title", mism$Where)), sum(grepl("^title", nosrc$Where))), "",
  "## List 1: numbers that do not match their source", "", lst(mism), "", "## List 2: numbers with no source", "", lst(nosrc), "",
  "## The web page as one file", "",
  paste0("- Size: ", format(file.size(file.path("docs", "index.html")), big.mark = ","), " bytes."),
  paste0("- Things the page loads from outside itself: ", if (length(loads)) paste(loads, collapse = "; ") else "none."),
  paste0("- Report figures with no chart in the page: ", if (length(missing_charts)) paste(missing_charts, collapse = ", ") else "none (all 9 are drawn by the page's own JavaScript; the page contains no image)."),
  paste0("- Figure titles not used in the page: ", if (length(missing_titles)) paste(missing_titles, collapse = ", ") else "none (all 9 titles are the same strings the figure scripts use)."), "",
  "Not checked by this script, checked by hand in a browser on 2026-11-24: that every chart draws, that the interactions respond, that the explorer's numbers equal `output/tables/explorer_checks.csv`, and that nothing runs off the screen at phone width.", "",
  "## Typed numbers that are allowed, and why", "", "| Number | Why it is not a result |", "|---|---|", paste0("| ", names(allowed), " | ", allowed, " |"))
writeLines(md, file.path("documentation", "number_audit.md"))
message(sprintf("10_number_audit: %d numbers checked; %d do not match their source, %d have no source; the page loads %d things from outside itself.", nrow(audit), nrow(mism), nrow(nosrc), length(loads)))
if (nrow(mism) + nrow(nosrc) + length(loads) + length(missing_charts) > 0) warning("The number audit is not clean. See documentation/number_audit.md.")
