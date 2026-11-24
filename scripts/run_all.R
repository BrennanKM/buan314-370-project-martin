# run_all.R
# The master script: runs every numbered script in order from a clean session
# and reports each step as it finishes. Run it from the project folder:
#   Rscript scripts/run_all.R
# Later parts of the project (exploration, figures, models, page data) are
# added to this list as they are built.

scripts <- c(
  "01_verify_raw.R",    # check the hand-downloaded raw workbooks against recorded checksums
  "02_audit.R",         # audit the raw data (report only)
  "03_clean.R",         # carry out the approved cleaning plan; write the processed data and wrangling log
  "03b_codebook.R",     # write the codebook from the processed data
  "04_validate.R",      # tests that guard the processed data
  "05_eda.R",           # one summary table per exploration sub-question; correlation matrix and heat map
  "06a_style_check.R",  # figure style: palette sample, palette file for the web page, color-vision check
  "06_figures.R",       # the five exploration figures, each checked against its summary table
  "07a_model_plan.R",   # evidence for choosing predictors (fits nothing)
  "07_models.R"         # the two linear regressions: estimates, fit, classification table, figures, scenario predictions
)

started <- Sys.time()
for (s in scripts) {
  t0 <- Sys.time()
  message("\n=== ", s, " ===")
  source(file.path("scripts", s), local = new.env())
  message(sprintf("--- %s finished in %.1f seconds", s, as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}
message(sprintf("\nAll %d scripts finished in %.1f seconds.", length(scripts), as.numeric(difftime(Sys.time(), started, units = "secs"))))
