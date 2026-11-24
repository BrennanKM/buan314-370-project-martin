# 00_style.R
# One figure style and one fixed palette for the whole project (course Prompt
# 7.1). Every figure script loads this file. The same colors are written to
# output/palette.json so the HTML report can use them and the two reports match.
# Loading this file draws nothing and writes nothing.

suppressPackageStartupMessages(library(ggplot2))

# A category keeps its color everywhere. Colors are from the Okabe-Ito set,
# which was designed to stay distinguishable under the common forms of
# color-vision deficiency.
project_colors <- list(
  operator_type = c(commercial = "#0072B2", tribal = "#E69F00"),      # blue, orange
  paid_no_tax   = c(`Paid no tax` = "#D55E00", `Paid tax` = "#999999"), # vermillion, grey
  flagged       = c(`Flagged month` = "#000000", `Other months` = "#999999"),     # black, grey
  single        = c(main = "#0072B2", accent = "#D55E00", muted = "#999999"),
  diverging     = c(negative = "#0072B2", zero = "#FFFFFF", positive = "#D55E00"),
  text          = c(dark = "#222222", grid = "#E5E5E5")
)

figure_width_in <- 6.5

theme_project <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = "white", colour = NA),
      panel.background   = element_rect(fill = "white", colour = NA),
      panel.grid.major   = element_line(colour = project_colors$text[["grid"]], linewidth = 0.3),
      panel.grid.minor   = element_blank(),
      text               = element_text(colour = project_colors$text[["dark"]]),
      axis.text          = element_text(colour = project_colors$text[["dark"]], size = rel(0.95)),
      axis.title         = element_text(size = rel(1.0)),
      plot.title         = element_text(face = "bold", size = rel(1.15), lineheight = 1.05),
      plot.title.position = "plot",
      plot.subtitle      = element_text(size = rel(0.95)),
      plot.caption       = element_text(size = rel(0.8), hjust = 0, colour = "#555555"),
      plot.caption.position = "plot",
      legend.position    = "top",
      legend.justification = "left",
      legend.location    = "plot",      # line the legend up with the title, not the panel
      legend.title       = element_text(size = rel(0.9)),
      strip.text         = element_text(face = "bold", hjust = 0)
    )
}

# Standard caption: the source and the number of rows shown.
# Titles and captions are wrapped so nothing runs off a 6.5-inch figure.
wrap_text <- function(x, width) paste(strwrap(x, width = width), collapse = "\n")
wrap_title <- function(x, width = 68) wrap_text(x, width)
caption_source <- function(n_rows, extra = NULL) {
  wrap_text(paste0("Source: Michigan Gaming Control Board, internet sports betting revenues and taxes, 2021 to 2026. ",
                   "Rows shown: ", formatC(n_rows, format = "d", big.mark = ","), " operator-months.",
                   if (!is.null(extra)) paste0(" ", extra) else ""), width = 105)
}

# Save a figure as PNG and PDF, 6.5 inches wide, in output/figures.
save_figure <- function(plot, name, height_in = 4.2) {
  dir.create(file.path("output", "figures"), recursive = TRUE, showWarnings = FALSE)
  # The PNG device is named, not left to ggsave: ggsave quietly uses the ragg package when it happens to be
  # installed and another device when it is not, which made a fresh copy draw different files (fresh-copy test, 2026-11-24).
  ggsave(file.path("output", "figures", paste0(name, ".png")), plot, width = figure_width_in, height = height_in, dpi = 300, bg = "white", device = ragg::agg_png)
  ggsave(file.path("output", "figures", paste0(name, ".pdf")), plot, width = figure_width_in, height = height_in, bg = "white", device = grDevices::pdf)
  invisible(plot)
}

# Figure titles live in one file, documentation/figure_titles.csv, so the two
# reports and the slides always show the same wording. Each title states a
# finding. The "wording" column says whose words they are: "assistant draft"
# until Brennan keeps or changes the title (decision D-024).
fig_title <- function(key) {
  t <- read.csv(file.path("documentation", "figure_titles.csv"), stringsAsFactors = FALSE)
  if (!key %in% t$figure) stop("No title for figure ", key, " in documentation/figure_titles.csv")
  t$title[t$figure == key]
}
