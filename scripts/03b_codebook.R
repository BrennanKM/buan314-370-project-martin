# 03b_codebook.R
# Writes the codebook: one row per variable in the processed data (course
# Prompt 5.4). Definitions are taken from the publisher's workbooks and from
# state law, with the place cited. Ranges and missing shares are computed from
# the processed file, never copied from anywhere.
#
# Reads:  data/processed/mgcb_operator_months.csv
# Writes: documentation/codebook.md
#         documentation/codebook_rules.csv  (the allowed values, in a form the
#                                            validation script can test)

source(file.path("scripts", "00_functions.R"))

d <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE, check.names = FALSE)

operators <- sort(unique(d$operator))
shorts    <- sort(unique(d$operator_short))
files     <- sort(unique(d$source_file))

# kind: number | whole | category | flag | date | text
# min / max are the allowed range (blank = no limit); values = allowed categories, separated by " | "
cb <- tribble(
  ~name, ~label, ~kind, ~units, ~min, ~max, ~values, ~from, ~transformation, ~notes,
  "operator", "Licensed internet sports betting operator (the licensee)", "category", "none", NA, NA, paste(operators, collapse = " | "),
    "\"Operators\" header row", "Typed footnote markers such as \"NOTE 4\" removed (wrangling log, step 10)", "With month_date, identifies a row. Who may be an operator: MCL 432.406(1).",
  "operator_short", "Short operator name for figures", "category", "none", NA, NA, paste(shorts, collapse = " | "),
    "operator", "Looked up from a list of 15 short names in scripts/03_clean.R (step 10)", "Not from the publisher; a display name only.",
  "operator_type", "Whether the operator is a commercial Detroit casino or a tribal operator", "category", "none", NA, NA, "commercial | tribal",
    "Label of the tax or payment column", "\"State Tax (5.88%)\" read as commercial, \"State Payment (8.4%)\" as tribal (step 12)", "Two categories. Workbook note: \"Tribal Operators pay the full 8.4% to the State, while Commercial Operators pay 70% to the State and 30% to the City of Detroit.\"",
  "casino_name", "Casino or casinos tied to the operator's license", "text", "none", NA, NA, NA,
    "\"Casino Name\" header row", "Extra spaces removed", "One value per operator.",
  "platform_as_listed", "Platform provider (the betting brand) as printed on that year's sheet", "text", "none", NA, NA, NA,
    "\"Platform Providers\" header row", "Extra spaces removed (step 11)", "Labels change across years for 10 operators; some are real changes of partner, some are renamings.",
  "platform_latest", "The operator's platform provider as printed on its most recent sheet", "text", "none", NA, NA, NA,
    "\"Platform Providers\" header row", "The label from the operator's latest year in the data (step 11)", "The brand name readers know today. Not a record of which brand ran in each month.",
  "launch_date", "Initial date of operation launch", "date", "date", "2021-01-22", NA, NA,
    "\"Initial date of Operation launch\" header row", "Converted from a spreadsheet day number stored as text (step 13)", "Workbook note: operators \"were authorized to begin operations on January 22, 2021\". FireKeepers had a limited soft launch in June 2021 before its listed date of 2021-07-12.",
  "year", "Calendar year of the reporting month", "whole", "year", "2021", "2026", NA,
    "Sheet name", "Taken from the sheet name", "",
  "month", "Calendar month of the reporting month", "whole", "month number", "1", "12", NA,
    "\"Month\" column", "Month name converted to its number", "",
  "month_name", "Name of the reporting month", "category", "none", NA, NA, paste(month.name, collapse = " | "),
    "\"Month\" column", "None", "",
  "month_date", "First day of the reporting month", "date", "date", "2021-01-01", "2026-10-01", NA,
    "Sheet name and \"Month\" column", "Built from year and month (step 16)", "With operator, identifies a row.",
  "handle", "Total dollars wagered online with the operator in the month", "number", "US dollars", "0.01", NA, NA,
    "\"Total Handle\"", "None. Months with zero, blank or negative handle were dropped (steps 4 and 5)", "The publisher does not define \"Total Handle\". This label was supplied by Brennan Martin on 2026-11-23, based on the reporting item \"Total amount of internet sports betting wagers received\" in MCL 432.416a(1)(a).",
  "gross_receipts", "Gross sports betting receipts: all sums wagered with the operator, less winnings, refunded or voided wagers, and uncollectible amounts", "number", "US dollars", NA, NA, NA,
    "\"Gross Sports Betting Receipts\"", "None", "Defined in MCL 432.403 (gross sports betting receipts). Free play that is wagered counts toward gross receipts. Can be negative when winnings exceed wagers (50 months).",
  "adjusted_gross_receipts", "Adjusted gross sports betting receipts: gross receipts less the deduction for free play", "number", "US dollars", NA, NA, NA,
    "\"Adjusted Gross Sports Betting Receipts\"", "None", "MCL 432.403(a): gross sports betting receipts \"less a deduction for the monetary value of free play wagered by authorized participants\". Negative when free play deducted exceeds gross receipts.",
  "state_tax_or_payment", "Tax (commercial operators) or payment (tribal operators) to the State for the month, as reported", "number", "US dollars", "0", NA, NA,
    "\"Internet Sports Betting State Tax (5.88%)\" or \"Internet Sports Betting State Payment (8.4%)\"", "None (step 15)", "Rate is 8.4% of adjusted gross receipts (MCL 432.414, 432.407); for commercial operators this column is the State's 70% share (5.88%). Zero in many months with positive receipts, consistent with negative receipts being carried forward. Excludes the City of Detroit's share.",
  "free_play_deduction", "Free play deducted in the month it was claimed", "number", "US dollars", "0", NA, NA,
    "gross_receipts, adjusted_gross_receipts", "gross_receipts minus adjusted_gross_receipts (step 16). Set to missing in 2 months where it is negative (step 8)", "Not a published column. The law makes free play the only deduction between gross and adjusted receipts. An operator can claim free play in a later month, so this is not always that month's promotions.",
  "free_play_per_100", "Free play deducted per $100 wagered", "number", "dollars per $100 wagered (percent of handle)", "0", NA, NA,
    "free_play_deduction, handle", "100 x free_play_deduction / handle (step 16). Missing where the deduction is negative (step 8) or handle is under $10,000 (step 6)", "**Numeric target** of the regression problem. Can exceed 100 when a lump of earlier free play is claimed in one month.",
  "kept_per_100", "Dollars the operator kept per $100 wagered, before free play is deducted", "number", "dollars per $100 wagered (percent of handle)", NA, "100", NA,
    "gross_receipts, handle", "100 x gross_receipts / handle (step 16). Missing where handle is under $10,000 (step 6)", "Negative in months when winnings exceeded wagers.",
  "paid_no_tax", "Whether the operator paid no state tax or payment for the month", "flag", "none", NA, NA, "0 | 1",
    "state_tax_or_payment", "1 if state_tax_or_payment is zero, 0 if it is above zero (step 16)", "**Yes-or-no target** of the classification problem. Coding: 1 = yes, paid nothing; 0 = no, paid something.",
  "log10_handle", "Size of the month's wagering: base-10 logarithm of handle", "number", "log10 of US dollars", "-2", NA, NA,
    "handle", "log10(handle) (step 16)", "6 means $1 million wagered; 8 means $100 million.",
  "months_active", "Count of months with wagering for this operator up to and including this one", "whole", "months", "1", "70", NA,
    "operator, month_date", "Running count within operator, in date order (step 16)", "Skips months with no wagering, so it is not the same as months since launch for operators that paused.",
  "first_active_month", "Whether this is the operator's first month with wagering", "flag", "none", NA, NA, "0 | 1",
    "months_active", "1 if months_active is 1 (step 14)", "Coding: 1 = yes. First months are partial: January 2021 covers January 22 to 31.",
  "lump_deduction", "Whether the free play deducted is more than a quarter of the month's handle", "flag", "none", NA, NA, "0 | 1",
    "gross_receipts, adjusted_gross_receipts, handle", "1 if (gross_receipts minus adjusted_gross_receipts) is more than 0.25 x handle (step 9)", "Coding: 1 = yes. Marks months that look like free play claimed late as a lump, so findings can be checked with and without them.",
  "prior_free_play_per_100", "The same operator's free play per $100 wagered in the previous calendar month", "number", "dollars per $100 wagered", "0", NA, NA,
    "free_play_per_100", "Previous row's value when it is exactly one month earlier, otherwise missing (step 16)", "Known at the start of the month.",
  "prior_kept_per_100", "The same operator's dollars kept per $100 wagered in the previous calendar month", "number", "dollars per $100 wagered", NA, "100", NA,
    "kept_per_100", "As above (step 16)", "Known at the start of the month.",
  "prior_log10_handle", "The same operator's log10 of handle in the previous calendar month", "number", "log10 of US dollars", "-2", NA, NA,
    "log10_handle", "As above (step 16)", "Known at the start of the month.",
  "prior_paid_no_tax", "Whether the same operator paid no state tax or payment in the previous calendar month", "flag", "none", NA, NA, "0 | 1",
    "paid_no_tax", "As above (step 16)", "Coding: 1 = yes. Known at the start of the month.",
  "source_file", "The raw workbook the row was read from", "category", "none", NA, NA, paste(files, collapse = " | "),
    "File name", "The newest workbook that carries the row's year (step 2)", "For tracing a row back to the raw data."
)

if (!identical(cb$name, names(d))) {
  stop("The codebook does not list exactly the columns of the processed file, in order.\n  Only in codebook: ",
       paste(setdiff(cb$name, names(d)), collapse = ", "), "\n  Only in data: ", paste(setdiff(names(d), cb$name), collapse = ", "), call. = FALSE)
}

type_words <- c(number = "Number", whole = "Whole number", category = "Category", flag = "Category (0 or 1)", date = "Date", text = "Text")
observed <- function(nm, kind) {
  v <- d[[nm]]; v <- v[!is.na(v) & v != ""]
  if (kind %in% c("number", "whole")) { v <- as.numeric(v); return(sprintf("%s to %s", fmt(min(v), if (kind == "whole") 0 else 2), fmt(max(v), if (kind == "whole") 0 else 2))) }
  if (kind == "date") return(sprintf("%s to %s", min(v), max(v)))
  sprintf("%d distinct values", length(unique(v)))
}
allowed_text <- function(kind, mn, mx, values) {
  if (kind %in% c("category", "flag")) {
    vals <- str_split(values, " \\| ")[[1]]
    return(if (length(vals) > 6) sprintf("One of %d listed values (see documentation/codebook_rules.csv)", length(vals)) else paste(vals, collapse = "; "))
  }
  if (kind == "text") return("Any text")
  if (is.na(mn) && is.na(mx)) return("Any number")
  if (!is.na(mn) && !is.na(mx)) return(sprintf("%s to %s", mn, mx))
  if (!is.na(mn)) return(sprintf("%s or more", mn))
  sprintf("%s or less", mx)
}
missing_share <- function(nm) { v <- d[[nm]]; n <- sum(is.na(v) | v == ""); sprintf("%.1f%% (%d of %d)", 100 * n / nrow(d), n, nrow(d)) }

# Variables whose observed values fall outside the stated range (course Verify step)
outside <- character(0)
for (i in seq_len(nrow(cb))) {
  v <- d[[cb$name[i]]]; v <- v[!is.na(v) & v != ""]
  if (cb$kind[i] %in% c("number", "whole")) {
    v <- as.numeric(v)
    if ((!is.na(cb$min[i]) && any(v < as.numeric(cb$min[i]))) || (!is.na(cb$max[i]) && any(v > as.numeric(cb$max[i])))) outside <- c(outside, cb$name[i])
  } else if (cb$kind[i] == "date") {
    if ((!is.na(cb$min[i]) && any(v < cb$min[i])) || (!is.na(cb$max[i]) && any(v > cb$max[i]))) outside <- c(outside, cb$name[i])
  } else if (cb$kind[i] %in% c("category", "flag")) {
    if (!all(as.character(v) %in% str_split(cb$values[i], " \\| ")[[1]])) outside <- c(outside, cb$name[i])
  }
}

tbl <- tibble(
  Name = paste0("`", cb$name, "`"), Label = cb$label, Type = unname(type_words[cb$kind]), Units = cb$units,
  `Allowed values or range` = pmap_chr(list(cb$kind, cb$min, cb$max, cb$values), allowed_text),
  `Observed in the data` = map2_chr(cb$name, cb$kind, observed),
  Missing = map_chr(cb$name, missing_share),
  From = cb$from, Transformation = cb$transformation, Notes = cb$notes
)

md <- c(
  "# Codebook",
  "",
  sprintf("One row per variable in `data/processed/mgcb_operator_months.csv` (%s rows, %d columns). One row of the data is one licensed internet sports betting operator in one month; `operator` and `month_date` together identify it.", fmt(nrow(d)), ncol(d)),
  "",
  "Written by `scripts/03b_codebook.R`; do not edit by hand. Observed ranges and missing shares are computed from the processed file each time the script runs.",
  "",
  "Where definitions come from: the publisher (Michigan Gaming Control Board) gives no data dictionary. Column meanings are taken from the labels and notes printed in the workbooks and from the Lawful Sports Betting Act, 2019 PA 149 (MCL 432.401 and following, https://www.legislature.mi.gov/Laws/MCL?objectName=mcl-act-149-of-2019 ). The one column the publisher does not define, Total Handle, carries a label supplied by Brennan Martin and says so in its Notes.",
  "",
  md_table(tbl),
  "",
  "## Coding of the 0 and 1 variables",
  "",
  md_table(tibble(Variable = c("`paid_no_tax`", "`prior_paid_no_tax`", "`first_active_month`", "`lump_deduction`"),
                  `1 means` = c("The operator paid no state tax or payment that month", "The operator paid no state tax or payment in the previous calendar month", "This is the operator's first month with wagering", "Free play deducted is more than a quarter of the month's handle"),
                  `0 means` = c("It paid some", "It paid some", "Any later month", "It is a quarter of handle or less"),
                  `Share coded 1` = sprintf("%.1f%% of %d rows", 100 * c(mean(d$paid_no_tax), mean(d$prior_paid_no_tax, na.rm = TRUE), mean(d$first_active_month), mean(d$lump_deduction)),
                                            c(nrow(d), sum(!is.na(d$prior_paid_no_tax)), nrow(d), nrow(d))))),
  "",
  sprintf("Check: the codebook has %d rows and the processed file has %d columns. Variables with observed values outside their stated range: %s.",
          nrow(cb), ncol(d), if (length(outside) == 0) "none" else paste(outside, collapse = ", ")),
  ""
)
writeLines(md, file.path("documentation", "codebook.md"))
write.csv(cb %>% select(name, kind, min, max, values), file.path("documentation", "codebook_rules.csv"), row.names = FALSE, na = "")

message(sprintf("03b_codebook: wrote documentation/codebook.md (%d variables; processed file has %d columns). Outside stated range: %s.",
                nrow(cb), ncol(d), if (length(outside) == 0) "none" else paste(outside, collapse = ", ")))
