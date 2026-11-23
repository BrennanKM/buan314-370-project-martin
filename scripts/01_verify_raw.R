# 01_verify_raw.R
# Checks the raw workbooks in data/raw. It does NOT download anything: the
# publisher's site terms do not allow scripted downloads, so the six files are
# downloaded by hand (steps in documentation/data_provenance.md).
#
# Reads:  data/raw/*.xlsx, documentation/raw_file_checksums.csv (if it exists)
# Writes: documentation/raw_file_checksums.csv (first run only),
#         output/tables/raw_file_facts.csv
# Never changes anything in data/raw.

suppressPackageStartupMessages({
  library(digest)
  library(readxl)
})

raw_dir     <- file.path("data", "raw")
record_path <- file.path("documentation", "raw_file_checksums.csv")
facts_path  <- file.path("output", "tables", "raw_file_facts.csv")

# The six workbooks, under the names the publisher gives them.
expected <- c(
  "Internet_Sports_Betting_revenue_716520_7.xlsx",
  "Internet_Sports_Betting_-_January_2022_748264_7.xlsx",
  "Internet-Sports-Betting-January-2023.xlsx",
  "Internet-Sports-Betting---2024.xlsx",
  "Internet-Sports-Betting---2025.xlsx",
  "Internet-Sports-Betting---2026.xlsx"
)

missing <- expected[!file.exists(file.path(raw_dir, expected))]
if (length(missing) > 0) {
  stop(
    "These raw files are not in data/raw:\n  ", paste(missing, collapse = "\n  "),
    "\nDownload them by hand, following documentation/data_provenance.md, ",
    "and do not open or rename them.", call. = FALSE
  )
}

describe_file <- function(name) {
  path   <- file.path(raw_dir, name)
  sheets <- excel_sheets(path)
  dims   <- vapply(sheets, function(s) {
    x <- suppressMessages(read_excel(path, sheet = s, col_names = FALSE, col_types = "text"))
    paste0(nrow(x), " x ", ncol(x))
  }, character(1))
  data.frame(
    file       = name,
    bytes      = file.size(path),
    sha256     = digest(path, algo = "sha256", file = TRUE),
    sheets     = paste(sheets, collapse = " | "),
    sheet_dims = paste(dims, collapse = " | "),
    stringsAsFactors = FALSE
  )
}

facts <- do.call(rbind, lapply(expected, describe_file))

if (!file.exists(record_path)) {
  # First run: these become the checksums of record.
  record <- facts[, c("file", "bytes", "sha256")]
  record$recorded_on <- format(Sys.Date())
  write.csv(record, record_path, row.names = FALSE)
  message("First run: wrote the checksums of record to ", record_path)
} else {
  record <- read.csv(record_path, stringsAsFactors = FALSE)
  check  <- merge(facts[, c("file", "sha256")], record[, c("file", "sha256")],
                  by = "file", suffixes = c("_found", "_recorded"), all = TRUE)
  bad <- check[is.na(check$sha256_found) | is.na(check$sha256_recorded) |
                 check$sha256_found != check$sha256_recorded, ]
  if (nrow(bad) > 0) {
    print(bad)
    stop(
      nrow(bad), " raw file(s) do not match the recorded checksums. ",
      "The publisher may have revised a file, or a file was opened and saved. ",
      "Nothing downstream should run until this is explained.", call. = FALSE
    )
  }
}

dir.create(dirname(facts_path), recursive = TRUE, showWarnings = FALSE)
write.csv(facts, facts_path, row.names = FALSE)

message("01_verify_raw: ", nrow(facts), " of ", length(expected),
        " raw files present and matching their recorded checksums.")
print(facts[, c("file", "bytes", "sheets", "sheet_dims")], row.names = FALSE)
