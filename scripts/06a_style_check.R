# 06a_style_check.R
# Draws a sample figure showing every category in its fixed color, writes the
# palette to a small file the HTML report reads, and checks the palette under
# simulated color-vision deficiency (course Prompt 7.1, Verify).
#
# Reads:  scripts/00_style.R
# Writes: output/figures/fig00_palette_sample.png and .pdf
#         output/palette.json
#         output/tables/palette_cvd_check.csv

source(file.path("scripts", "00_style.R"))

# ---- Palette file for the HTML report (written by hand to avoid extra packages) ----
groups <- project_colors
json <- paste0("{\n", paste(vapply(names(groups), function(g) {
  paste0("  \"", g, "\": {", paste(sprintf("\"%s\": \"%s\"", names(groups[[g]]), groups[[g]]), collapse = ", "), "}")
}, character(1)), collapse = ",\n"), "\n}\n")
writeLines(json, file.path("output", "palette.json"), sep = "")

# ---- Color-vision check ----
# Each color is passed through the standard simulation matrices for the three
# common deficiencies (Machado, Oliveira and Fernandes, 2009, full severity),
# then the distance between every pair of colors that appear together is
# measured in CIE Lab space. Larger is easier to tell apart; under about 10 is
# hard to tell apart.
sim <- list(
  normal = diag(3),
  protan = matrix(c(0.152286, 1.052583, -0.204868, 0.114503, 0.786281, 0.099216, -0.003882, -0.048116, 1.051998), 3, byrow = TRUE),
  deutan = matrix(c(0.367322, 0.860646, -0.227968, 0.280085, 0.672501, 0.047413, -0.011820, 0.042940, 0.968881), 3, byrow = TRUE),
  tritan = matrix(c(1.255528, -0.076749, -0.178779, -0.078411, 0.930809, 0.147602, 0.004733, 0.691367, 0.303900), 3, byrow = TRUE)
)
to_linear <- function(c) ifelse(c <= 0.04045, c / 12.92, ((c + 0.055) / 1.055)^2.4)
to_srgb   <- function(c) ifelse(c <= 0.0031308, 12.92 * c, 1.055 * c^(1 / 2.4) - 0.055)
lab_under <- function(hex, m) {
  rgb <- t(grDevices::col2rgb(hex)) / 255
  out <- pmin(pmax(to_linear(rgb) %*% t(m), 0), 1)
  grDevices::convertColor(to_srgb(out), from = "sRGB", to = "Lab")
}
checked <- c("operator_type", "paid_no_tax", "flagged", "single")
rows <- list()
for (g in checked) for (s in names(sim)) {
  lab <- lab_under(groups[[g]], sim[[s]])
  dist <- as.matrix(stats::dist(lab)); diag(dist) <- NA
  rows[[length(rows) + 1]] <- data.frame(palette = g, vision = s, colors = length(groups[[g]]), smallest_pair_distance = round(min(dist, na.rm = TRUE), 1))
}
cvd <- do.call(rbind, rows)
dir.create(file.path("output", "tables"), recursive = TRUE, showWarnings = FALSE)
write.csv(cvd, file.path("output", "tables", "palette_cvd_check.csv"), row.names = FALSE)
print(cvd, row.names = FALSE)

# ---- Sample figure: every category in its color ----
swatch <- do.call(rbind, lapply(checked, function(g) data.frame(group = g, category = names(groups[[g]]), color = unname(groups[[g]]), stringsAsFactors = FALSE)))
swatch$group <- factor(swatch$group, levels = checked, labels = c("Operator type", "Paid no state tax", "Flagged months", "Single-series figures"))
swatch$label <- paste0(swatch$category, "\n", swatch$color)
p <- ggplot(swatch, aes(x = category, y = 1, fill = color)) +
  geom_col(width = 0.8) +
  geom_text(aes(label = label), y = 0.5, colour = "white", fontface = "bold", size = 3.1, lineheight = 0.95) +
  scale_fill_identity() +
  facet_wrap(~ group, scales = "free_x", nrow = 2) +
  labs(title = "Every category keeps one color in every figure",
       subtitle = "The project palette, as used in the static report, the slides and the web page",
       x = NULL, y = NULL,
       caption = "Colors from the Okabe-Ito set. Checked under simulated protan, deutan and tritan vision\n(results in output/tables/palette_cvd_check.csv).") +
  theme_project() + theme(axis.text.y = element_blank(), panel.grid = element_blank(), axis.text.x = element_blank())
save_figure(p, "fig00_palette_sample", height_in = 4)
message("06a_style_check: wrote the sample figure, output/palette.json and the color-vision check. Smallest pair distance overall: ", min(cvd$smallest_pair_distance))
