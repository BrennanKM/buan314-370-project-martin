# 00_functions.R
# Shared helpers. Loaded by the numbered scripts with source(); it does nothing
# when run by itself.
#
# read_mgcb_raw() reads the six raw workbooks exactly as published and returns
# them in long form WITHOUT cleaning anything: no rows dropped, no values
# changed, no names tidied. Every later script starts from this one reading of
# the raw files, so the audit and the cleaning script cannot disagree about
# what the raw data say.

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(purrr)
  library(stringr)
  library(tibble)
})

raw_files <- c(
  "Internet_Sports_Betting_revenue_716520_7.xlsx",
  "Internet_Sports_Betting_-_January_2022_748264_7.xlsx",
  "Internet Sports Betting January 2023.xlsx",
  "Internet Sports Betting - 2024.xlsx",
  "Internet Sports Betting - 2025.xlsx",
  "Internet Sports Betting - 2026.xlsx"
)

# The year each workbook is "for" (its first sheet). Used only to say which
# workbook is newer when the same year appears in two of them.
raw_file_year <- c(2021L, 2022L, 2023L, 2024L, 2025L, 2026L)
names(raw_file_year) <- raw_files

# Read one sheet. The sheet is laid out wide: column 1 holds row labels, then
# each operator has four columns (handle, gross receipts, adjusted gross
# receipts, tax or payment). The last block is the all-operator total, and the
# final column is a city tax total.
read_mgcb_sheet <- function(path, sheet) {
  x <- suppressMessages(read_excel(path, sheet = sheet, col_names = FALSE, col_types = "text"))
  first <- x[[1]]
  row_of <- function(pattern) {
    r <- which(str_detect(coalesce(first, ""), pattern))
    if (length(r) != 1) stop("Expected exactly one row matching '", pattern, "' in ", basename(path), " / ", sheet, call. = FALSE)
    r
  }
  r_operator <- row_of("^Operators$")
  r_casino   <- row_of("^Casino Name$")
  r_platform <- row_of("^Platform Providers$")
  r_launch   <- row_of("^Initial date of Operation launch$")
  r_labels   <- row_of("^Month$")
  r_total    <- row_of("^Total$")
  r_months   <- which(first %in% month.name)
  if (length(r_months) != 12) stop("Expected 12 month rows in ", basename(path), " / ", sheet, call. = FALSE)

  labels <- unlist(x[r_labels, ], use.names = FALSE)
  starts <- which(labels == "Total Handle")
  cell   <- function(r, j) as.character(x[[j]][r])

  blocks <- map_dfr(starts, function(j) {
    tibble(
      source_file   = basename(path),
      sheet         = sheet,
      sheet_year    = as.integer(str_extract(sheet, "\\d{4}")),
      block_column  = j,
      operator_raw  = cell(r_operator, j),
      casino_raw    = cell(r_casino, j),
      platform_raw  = cell(r_platform, j),
      launch_raw    = cell(r_launch, j),
      tax_label_raw = cell(r_labels, j + 3),
      row_label     = c(first[r_months], "Total"),
      handle_raw    = x[[j]][c(r_months, r_total)],
      gross_raw     = x[[j + 1]][c(r_months, r_total)],
      adjusted_raw  = x[[j + 2]][c(r_months, r_total)],
      tax_raw       = x[[j + 3]][c(r_months, r_total)]
    )
  })

  notes <- tibble(
    source_file = basename(path), sheet = sheet,
    label = x[[2]][seq(r_total + 1, nrow(x))],
    text  = if (ncol(x) >= 3) x[[3]][seq(r_total + 1, nrow(x))] else NA_character_
  ) %>% filter(!is.na(label) | !is.na(text))

  list(blocks = blocks, notes = notes, title = cell(1, 2))
}

# Read every sheet of every raw workbook.
read_mgcb_raw <- function(raw_dir = file.path("data", "raw")) {
  paths <- file.path(raw_dir, raw_files)
  if (!all(file.exists(paths))) stop("Raw files are missing. Run scripts/01_verify_raw.R first.", call. = FALSE)
  pieces <- map(paths, function(p) map(excel_sheets(p), function(s) read_mgcb_sheet(p, s))) %>% list_flatten()
  blocks <- map_dfr(pieces, "blocks") %>%
    mutate(
      file_year  = unname(raw_file_year[source_file]),
      block_type = if_else(str_detect(operator_raw, "^All Internet Sports Betting Operators"), "all_operators", "operator"),
      # Numbers are stored as text by the reader so nothing is lost; convert here.
      handle   = suppressWarnings(as.numeric(handle_raw)),
      gross    = suppressWarnings(as.numeric(gross_raw)),
      adjusted = suppressWarnings(as.numeric(adjusted_raw)),
      tax      = suppressWarnings(as.numeric(tax_raw))
    )
  list(blocks = blocks, notes = map_dfr(pieces, "notes"))
}

# Small helper: write a data frame as a Markdown table.
md_table <- function(df) {
  df <- as.data.frame(df, stringsAsFactors = FALSE)
  df[] <- lapply(df, function(v) { v <- as.character(v); v[is.na(v)] <- ""; str_replace_all(v, "\\|", "/") })
  c(paste0("| ", paste(names(df), collapse = " | "), " |"),
    paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
    apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |")))
}

# Format a number of dollars or a count with thousands separators.
# A missing value is shown as the word "blank".
fmt <- function(v, digits = 0) ifelse(is.na(v), "blank", formatC(v, format = "f", digits = digits, big.mark = ","))
