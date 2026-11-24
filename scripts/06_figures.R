# 06_figures.R
# The report-quality figures for the exploration (course Prompts 7.2 and 7.3).
# Five are drawn here; the sixth, the correlation heat map, is drawn by
# 05_eda.R. Each figure is numbered to match its sub-question in
# documentation/eda_plan.md, is drawn from the processed data only, and is
# checked against the summary table that 05_eda.R saved for that sub-question:
# the script stops if a number in a figure differs from its table.
#
# TITLES: each title states a finding and is read from
# documentation/figure_titles.csv. The wording there is the AI assistant's draft
# (decision D-024) until Brennan keeps or changes it.
#
# Reads:  data/processed/mgcb_operator_months.csv, output/tables/eda_*.csv,
#         documentation/figure_titles.csv
# Writes: output/figures/fig01_free_play_spread, fig03_share_of_wagering,
#         fig04_free_play_by_operator, fig09_no_tax_by_year_and_type,
#         fig10_free_play_by_age_and_type (PNG and PDF each)
#         output/tables/figure_checks.csv

suppressPackageStartupMessages({library(dplyr); library(tidyr); library(ggplot2)})
source(file.path("scripts", "00_style.R"))

d <- read.csv(file.path("data", "processed", "mgcb_operator_months.csv"), stringsAsFactors = FALSE)
tbl <- function(name) read.csv(file.path("output", "tables", paste0(name, ".csv")), check.names = FALSE, stringsAsFactors = FALSE)

titles <- vapply(c(fig01 = "fig01", fig03 = "fig03", fig04 = "fig04", fig09 = "fig09", fig10 = "fig10"), fig_title, character(1))

# Every check is recorded: what the figure shows, what the table says, equal or not.
checks <- list()
check <- function(figure, what, in_figure, in_table) {
  ok <- isTRUE(all.equal(as.numeric(in_figure), as.numeric(in_table), tolerance = 1e-9))
  checks[[length(checks) + 1]] <<- data.frame(Figure = figure, `What was compared` = what, `Value in the figure` = paste(format(in_figure, trim = TRUE), collapse = "; "),
                                              `Value in the table` = paste(format(in_table, trim = TRUE), collapse = "; "), Equal = ifelse(ok, "yes", "NO"), check.names = FALSE)
  if (!ok) stop("Figure check failed for ", figure, ": ", what)
}

# One label per operator: the brand bettors know, then the license holder.
d$operator_label <- paste0(d$platform_latest, " (", d$operator_short, ")")
type_label <- c(commercial = "Commercial (Detroit casino)", tribal = "Tribal")
d$Operator_type <- factor(type_label[d$operator_type], levels = type_label)
type_colors <- setNames(project_colors$operator_type[names(type_label)], type_label)
brand_note <- "Each label gives the operator's latest platform brand, then the license holder."

# ---- Figure 1 (sub-question 1): spread of free play per $100 wagered ----
v <- d$free_play_per_100[!is.na(d$free_play_per_100)]
q <- round(quantile(v, c(0.25, 0.5, 0.75), names = FALSE), 2)
bins <- data.frame(lower = pmin(floor(v), 20)) %>% count(lower, name = "months") %>%
  mutate(x = ifelse(lower == 20, 21.5, lower + 0.5))
n10 <- sum(v >= 10)
t1 <- tbl("eda_01_free_play_spread"); t1v <- setNames(t1[[2]], t1[[1]])
check("fig01", "Lower quartile, median, upper quartile", q, t1v[c("Lower quartile", "Median", "Upper quartile")])
check("fig01", "Months with a value", length(v), t1v["Rows with a value"])
check("fig01", "Months at $10 or more per $100", n10, t1v["Rows at $10 or more per $100"])
t1b <- tbl("eda_01b_free_play_bins")
check("fig01", "Months in each $1 band from $0 to under $15", bins$months[bins$lower < 15], t1b[[2]][1:15])
check("fig01", "Months at $20 or more (last bar)", bins$months[bins$lower == 20], sum(t1b[[2]][17:19]))
top <- max(bins$months)
g1 <- ggplot(bins, aes(x, months)) +
  annotate("rect", xmin = q[1], xmax = q[3], ymin = 0, ymax = Inf, fill = "#F2F2F2") +
  geom_col(width = 1, fill = project_colors$single[["main"]], colour = "white", linewidth = 0.25) +
  geom_vline(xintercept = q[2], linetype = "dashed", colour = "#222222", linewidth = 0.4) +
  annotate("text", x = q[2] + 0.3, y = top * 1.13, label = sprintf("Median $%.2f", q[2]), hjust = 0, size = 3.1, colour = "#222222") +
  annotate("text", x = q[3] + 0.3, y = top * 1.02, label = sprintf("Shaded: the middle half,\n$%.2f to $%.2f", q[1], q[3]), hjust = 0, vjust = 1, size = 2.9, colour = "#555555", lineheight = 0.95) +
  annotate("segment", x = 10, xend = 22, y = top * 0.33, yend = top * 0.33, colour = "#222222", linewidth = 0.4) +
  annotate("text", x = 16, y = top * 0.38, label = sprintf("%d months (%.2f%%) at $10 or more", n10, 100 * n10 / length(v)), size = 3.1, colour = "#222222") +
  scale_x_continuous(breaks = c(0, 5, 10, 15, 21.5), labels = c("$0", "$5", "$10", "$15", "$20 or\nmore"), expand = expansion(mult = c(0.01, 0.03))) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.04)), limits = c(0, top * 1.2)) +
  labs(title = wrap_title(titles[["fig01"]]), x = "Free play deducted per $100 wagered (dollars, in $1 bands)", y = "Sportsbook-months",
       caption = caption_source(length(v), sprintf("The last bar gathers every month at $20 or more (largest: $%.2f). %d of the 923 months have no value.", max(v), nrow(d) - length(v)))) +
  theme_project() + theme(panel.grid.major.x = element_blank())
save_figure(g1, "fig01_free_play_spread", height_in = 4.3)

# ---- Figure 3 (sub-question 3): share of all dollars wagered, by operator ----
s3 <- d %>% group_by(operator_label, operator_short, Operator_type) %>% summarise(total = sum(handle), months = n(), .groups = "drop") %>%
  mutate(share = 100 * total / sum(total)) %>% arrange(desc(share))
t3 <- tbl("eda_03_size_by_operator")
check("fig03", "Share of all dollars wagered, 15 operators, largest first", round(s3$share, 2), t3[["Share of all dollars wagered (percent)"]])
check("fig03", "Top three together (percent)", round(sum(s3$share[1:3]), 2), t3[["Running share (percent)"]][3])
check("fig03", "Nine smallest together (percent)", round(100 - sum(s3$share[1:6]), 2), round(100 - t3[["Running share (percent)"]][6], 2))
s3$operator_label <- factor(s3$operator_label, levels = rev(s3$operator_label))
g3 <- ggplot(s3, aes(share, operator_label, fill = Operator_type)) + geom_col(width = 0.72) +
  geom_text(aes(label = sprintf("%.1f%%", share)), hjust = -0.15, size = 2.9, colour = "#222222") +
  scale_fill_manual(values = type_colors, name = "Operator type") +
  scale_x_continuous(labels = function(x) paste0(x, "%"), expand = expansion(mult = c(0, 0.16))) +
  labs(title = wrap_title(titles[["fig03"]]), subtitle = "January 2021 to October 2026", x = "Share of all dollars wagered", y = NULL,
       caption = caption_source(nrow(d), brand_note)) +
  theme_project() + theme(panel.grid.major.y = element_blank(), axis.text.y = element_text(size = 8.5))
save_figure(g3, "fig03_share_of_wagering", height_in = 4.8)

# ---- Figure 4 (sub-question 4): free play per $100 wagered, by operator ----
d4 <- d %>% filter(!is.na(free_play_per_100))
m4 <- d4 %>% group_by(operator_label, operator_short) %>% summarise(median = round(median(free_play_per_100), 2), months = n(), .groups = "drop") %>% arrange(desc(median))
t4 <- tbl("eda_04_free_play_by_operator")
check("fig04", "Median free play per $100 for each of the 15 operators", m4$median[match(t4$Operator, m4$operator_short)], t4[["Median free play per $100 wagered"]])
check("fig04", "Months with a value for each operator", m4$months[match(t4$Operator, m4$operator_short)], t4[["Months with a value"]])
frame_max <- 20; n_out <- sum(d4$free_play_per_100 > frame_max)
d4$operator_label <- factor(d4$operator_label, levels = rev(m4$operator_label))
g4 <- ggplot(d4, aes(free_play_per_100, operator_label, fill = Operator_type)) +
  geom_vline(xintercept = q[2], linetype = "dashed", colour = "#222222", linewidth = 0.4) +
  geom_boxplot(width = 0.65, linewidth = 0.3, outlier.size = 0.5, outlier.alpha = 0.5, colour = "#333333") +
  scale_fill_manual(values = type_colors, name = "Operator type") +
  scale_x_continuous(labels = function(x) paste0("$", x)) + coord_cartesian(xlim = c(0, frame_max)) +
  labs(title = wrap_title(titles[["fig04"]]), subtitle = sprintf("Ordered by median. Dashed line: the median of all sportsbook-months, $%.2f", q[2]),
       x = "Free play deducted per $100 wagered (dollars)", y = NULL,
       caption = caption_source(nrow(d4), sprintf("Box: middle half of an operator's months; line in the box: its median. %d months above $%d lie outside the frame (largest $%.2f); the boxes use every month. %s",
                                                  n_out, frame_max, max(d4$free_play_per_100), brand_note))) +
  theme_project() + theme(panel.grid.major.y = element_blank(), axis.text.y = element_text(size = 8.5))
save_figure(g4, "fig04_free_play_by_operator", height_in = 5.4)

# ---- Figure 9 (sub-question 9): share of months with no state tax, by year and type ----
s9 <- d %>% group_by(year, operator_type, Operator_type) %>% summarise(months = n(), no_tax = sum(paid_no_tax), .groups = "drop") %>% mutate(share = 100 * no_tax / months)
t9 <- tbl("eda_09_no_tax_by_year_and_type")
m9 <- match(paste(t9$Year, t9[["Operator type"]]), paste(s9$year, s9$operator_type))
check("fig09", "Share with no state tax paid, each year and type (percent)", round(s9$share[m9], 2), t9[["Share with no state tax paid (percent)"]])
check("fig09", "Months behind each point", s9$months[m9], t9[["Months (rows)"]])
s9$nudge <- ifelse(s9$operator_type == "tribal", 6, -6)
s9$nudge[s9$year == 2024 & s9$operator_type == "commercial"] <- 6   # below the point it would sit on the line
g9 <- ggplot(s9, aes(year, share, colour = Operator_type, group = Operator_type)) + geom_line(linewidth = 0.9) + geom_point(size = 2.3) +
  geom_text(aes(y = share + nudge, label = sprintf("%.0f%%", share)), size = 2.9, show.legend = FALSE) +
  scale_colour_manual(values = type_colors, name = "Operator type") +
  scale_x_continuous(breaks = 2021:2026, labels = c(2021:2025, "2026\n(Jan to Oct)"), limits = c(2020.8, 2026.35)) +
  scale_y_continuous(limits = c(-8, 100), breaks = seq(0, 100, 25), labels = function(x) paste0(x, "%")) +
  labs(title = wrap_title(titles[["fig09"]]), x = "Year", y = "Share of sportsbook-months\nwith no state tax paid",
       caption = caption_source(nrow(d), sprintf("Each point is one operator type in one year: %d to %d months for commercial, %d to %d for tribal.",
                                                 min(s9$months[s9$operator_type == "commercial"]), max(s9$months[s9$operator_type == "commercial"]),
                                                 min(s9$months[s9$operator_type == "tribal"]), max(s9$months[s9$operator_type == "tribal"])))) +
  theme_project() + theme(panel.grid.major.x = element_blank())
save_figure(g9, "fig09_no_tax_by_year_and_type", height_in = 4.5)

# ---- Figure 10 (sub-question 10): free play per $100 by age of the sportsbook, within each type ----
bands <- c("1 to 6", "7 to 12", "13 to 24", "25 to 48", "49 or more")
d10 <- d %>% filter(!is.na(free_play_per_100)) %>%
  mutate(band = factor(as.character(cut(months_active, c(0, 6, 12, 24, 48, Inf), labels = bands)), levels = bands))
s10 <- d10 %>% group_by(operator_type, Operator_type, band) %>%
  summarise(months = n(), q1 = round(quantile(free_play_per_100, 0.25, names = FALSE), 2), median = round(median(free_play_per_100), 2),
            q3 = round(quantile(free_play_per_100, 0.75, names = FALSE), 2), .groups = "drop") %>%
  mutate(Group_size = factor(ifelse(months < 30, "Fewer than 30 months", "30 months or more"), levels = c("30 months or more", "Fewer than 30 months")))
t10 <- tbl("eda_10_free_play_by_age_and_type")
m10 <- match(paste(t10[["Operator type"]], t10[["Months the operator has been active"]]), paste(s10$operator_type, s10$band))
check("fig10", "Median free play per $100, each age band and type", s10$median[m10], t10[["Median free play per $100 wagered"]])
check("fig10", "Lower and upper quartile, each age band and type", c(s10$q1[m10], s10$q3[m10]), c(t10[["Lower quartile"]], t10[["Upper quartile"]]))
check("fig10", "Months with a value behind each point", s10$months[m10], t10[["Months with a value"]])
g10 <- ggplot(s10, aes(band, median, colour = Operator_type, group = Operator_type)) +
  geom_linerange(aes(ymin = q1, ymax = q3), linewidth = 2.6, alpha = 0.28) + geom_line(linewidth = 0.9) +
  geom_point(aes(shape = Group_size), size = 2.8, fill = "white", stroke = 1.1) +
  geom_text(aes(y = median + 1.25, label = sprintf("$%.2f", median)), size = 2.9, colour = "#222222", fontface = "bold") +
  geom_text(aes(y = -1.1, label = paste0("n = ", months)), size = 2.6, colour = "#555555") +
  facet_wrap(~ Operator_type, ncol = 2) +
  scale_colour_manual(values = type_colors, guide = "none") + scale_shape_manual(values = c(`30 months or more` = 19, `Fewer than 30 months` = 21), name = NULL, drop = FALSE) +
  scale_x_discrete(labels = c("1 to 6", "7 to 12", "13 to 24", "25 to 48", "49 or\nmore")) +
  scale_y_continuous(labels = function(x) paste0("$", x), limits = c(-1.6, NA), breaks = seq(0, 16, 4)) +
  labs(title = wrap_title(titles[["fig10"]]), subtitle = "Point: median. Bar: the middle half of months. n = months behind the point",
       x = "Months the sportsbook has been active", y = "Free play deducted\nper $100 wagered (dollars)",
       caption = caption_source(nrow(d10), "Months active counts months with wagering, so it skips any month an operator paused.")) +
  theme_project() + theme(panel.grid.major.x = element_blank(), axis.text.x = element_text(size = rel(0.85)), panel.spacing = unit(1.1, "lines"))
save_figure(g10, "fig10_free_play_by_age_and_type", height_in = 4.6)

write.csv(bind_rows(checks), file.path("output", "tables", "figure_checks.csv"), row.names = FALSE)
message(sprintf("06_figures: drew 5 figures; %d of %d checks against the exploration tables are equal.", sum(bind_rows(checks)$Equal == "yes"), length(checks)))
