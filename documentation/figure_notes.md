# Figure notes

One entry per report figure (course Prompts 7.2 and 7.3): the sub-question it serves, what is mapped to what, the table it was checked against, and the review. Titles state a finding; every title is the AI assistant's draft until Brennan keeps or changes it (`process/assistant_drafts.md`, decision D-024). Written 2026-11-24.

All figures: 6.5 inches wide, PNG and PDF in `output/figures/`, drawn from `data/processed/mgcb_operator_months.csv` only, in the one style and palette of `scripts/00_style.R`. Commercial is blue (#0072B2) and tribal is orange (#E69F00) in every figure; "paid no tax" is vermillion (#D55E00) and "paid tax" is grey (#999999). The palette was checked under simulated color-vision deficiency (`output/tables/palette_cvd_check.csv`).

## Mapping and checks

| Figure | Sub-question | Chart form | Horizontal axis (type) | Vertical axis (type) | Color (type) | Panels, shape | Variables shown | Checked against | Rows |
|---|---|---|---|---|---|---|---|---|---|
| fig01_free_play_spread | 1 | Histogram | Free play per $100, in $1 bands (numeric, banded) | Count of sportsbook-months (numeric) | none (one color) | none | 1 | eda_01, eda_01b | 919 |
| fig03_share_of_wagering | 3 | Ordered bar chart | Share of all dollars wagered (numeric, percent) | Operator, largest first (category) | Operator type (category) | none | 3 | eda_03 | 923 |
| fig04_free_play_by_operator | 4 | Box plot per operator | Free play per $100 (numeric, dollars) | Operator, highest median first (category) | Operator type (category) | none | 3 | eda_04 | 919 |
| fig09_no_tax_by_year_and_type | 9 (also 2, 8) | Line chart | Year (ordered, 6 values) | Share of months with no state tax (numeric, percent) | Operator type (category) | none | 3 | eda_09 | 923 |
| fig10_free_play_by_age_and_type | 10 (also 5, 6) | Points and line in two panels | Months active, in five bands (ordered category) | Median free play per $100, with the middle half as a bar (numeric, dollars) | Operator type (category) | Panel: operator type. Shape: hollow point where fewer than 30 months | 3 (4 with group size) | eda_10 | 919 |
| fig12_correlation_heatmap | 12 | Heat map | Variable (category) | Variable (category) | Correlation, -1 to 1, centered on zero (numeric) | none | 3 | eda_12 | 900 to 923 per pair |
| fig_m1_predicted_vs_actual | Model 1 | Scatter with 45-degree line | Predicted free play per $100 (numeric) | Actual free play per $100 (numeric) | Operator type (category) | none | 3 | model_fit | 900 |
| fig_m1_errors_vs_predicted | Model 1 | Scatter | Predicted free play per $100 (numeric) | Error, actual minus predicted (numeric) | Operator type (category) | none | 3 | model1_error_summary | 900 |
| fig_m2_predicted_probability | Model 2 | Histogram in two panels | Predicted probability (numeric) | Count of sportsbook-months (numeric) | Actual outcome (category) | Panel: actual outcome | 2 | model_fit, model2_classification_table | 906 |

Course minimum: six figures in four or more chart forms, two or more showing three variables. Here: six exploration figures in five forms (histogram, bar, box plot, line, heat map; fig10 is a paneled point-and-line chart), five of them showing three or more variables, plus three model figures.

`scripts/06_figures.R` recomputes every number each exploration figure shows and compares it with the saved table; it stops if any differs. Result: 15 of 15 comparisons equal (`output/tables/figure_checks.csv`).

## The four questions, figure by figure

**fig01.** Axes: the outcome is on the horizontal axis because a histogram counts how often each value occurs; the count goes on the vertical axis. Color, size, shape: one color, since there is one variable. Panels or overlay: neither. Types: free play per $100 is numeric and is cut into $1 bands of equal width; the last bar gathers every month at $20 or more and is set apart with a gap and its own label so it is not read as a $1 band.

**fig03.** Axes: operators are categories, so bars; share on the numeric axis; ordered largest first so the top three sit together. Color: operator type, the same blue and orange as everywhere. Panels or overlay: one panel, the comparison is between bars. Types: share is numeric, operator and type are unordered categories.

**fig04.** Axes: the outcome on the numeric axis, one box per operator, ordered by median so "who deducts most" reads top to bottom. Color: operator type. Panels or overlay: one panel on one scale, because the comparison is across operators. Types: numeric against category. The frame stops at $20; 29 months above it are outside the frame, and the caption says so and gives the largest value.

**fig09.** Axes: time runs left to right; the outcome (share with no tax) is vertical. Color: operator type, one line each. Panels or overlay: overlaid, because the reader has to compare the two lines on the same scale and they cross only once. Types: year has six ordered values and is treated as such (one point per year); the share is numeric.

**fig10.** Axes: age band left to right in order, outcome vertical. Color: operator type, plus one panel per type. Shape: a hollow point marks a group under 30 months. Panels or overlay: panels, because each type has its own pattern (flat against falling) and the bars for the middle half would hide each other if overlaid. Types: months active is numeric but is shown in the five bands of table eda_10 so each point has a count behind it; the bands are ordered.

**fig12.** Axes: the same 12 variables on both. Color: correlation on a scale centered on zero, orange positive and blue negative, with the value printed in every cell. Panels or overlay: neither. Types: correlation is numeric and gets a continuous scale. Cells that cannot be computed show "n/a".

**Model figures.** fig_m1_predicted_vs_actual puts the prediction on the horizontal axis and the actual value on the vertical, on equal scales with a 45-degree line. fig_m1_errors_vs_predicted puts the error on the vertical axis around a zero line. fig_m2_predicted_probability shows the predicted probability separately for months that did and did not pay tax (two panels on a shared scale), with the 0.5 cutoff as a dashed line and the regions below 0 and above 1 shaded.

## Review (Prompt 7.3): problems found by looking at each saved image, and what was done

| Figure | Problem seen | What a reader would misread or miss | Fixed? |
|---|---|---|---|
| fig01 | The last axis label ("$20 or more") ran off the right edge | Would not know the last bar is an overflow bar | Yes: label on two lines, more room |
| fig01, fig09, fig10 | Titles wrapped to three lines with one word alone on the last | Looks unfinished on a slide | Yes: wider wrap in the style file |
| fig03, fig04 | Legend cut off at the right edge ("Tribal" missing) | Could not tell what orange means | Yes: legend lined up with the title |
| fig03 | Horizontal axis title cut off; the 33.5% label clipped | Would miss the period covered | Yes: period moved to the subtitle, more room for labels |
| fig03, fig04 | Long operator names squeezed the plot; wrapping them made names overlap | Could not read which operator is which | Yes: no wrapping, smaller name text |
| fig09 | The "56%" label sat on the line; "(Jan to Oct)" clipped | Would misread 2024; would miss that 2026 is a part year | Yes: label moved above its point, more room on the right |
| fig10 | Value labels sat on the lines; the last two age-band labels ran together | Could not read the medians | Yes: values above the points, last band label on two lines |
| fig04 | The frame hides 29 months above $20 | Might think no month goes above $20 | Kept, with the count and the largest value in the caption; the boxes use every month |
| fig12 | Twelve column labels are small (6.5 point) | Hard to read on a slide | Kept for the report; the slide version will show a cut-down matrix if needed |
| fig_m1_predicted_vs_actual | A few months near $120 stretch both axes, so most points crowd the corner | Would not see how the model does for typical months | Kept, because the stretch is the finding; the web version adds a zoom |

A different chart form was considered for fig04 (a dot for each operator's median): it would be cleaner but would hide how wide the spread is for some operators (Pokagon Band's middle half runs from $0.05 to $11.35), which is part of the answer to sub-question 4.

## Interaction trials (Prompt 7.4)

Three quick trials were made with plotly and saved in `scratch/trials/` (ignored by Git; not deliverables). They were made by the assistant and have not been opened by Brennan. What each is judged to add comes from the data, not from watching a reader use it.

| Trial | Interaction | What it lets a reader learn that the static figure does not | Sub-question it answers faster | Worth building? |
|---|---|---|---|---|
| A | Hover a point to see which operator and month it is | The static box plot shows that extreme months exist but not which they are. Hover names the operator, month, value and dollars wagered. | 11 (where the unusual months are) | Yes, as hover on the per-operator and model figures |
| B | Switch each of the 15 operators' lines on and off over time | Fifteen lines at once cannot be read. One operator at a time shows its own path from launch. | 10 (does free play change as a sportsbook ages) | Yes, but as a choice of one operator in the explorer, not 15 toggles |
| C | Step through the years on the histogram | The spread moves left after 2021, which the single histogram cannot show. | 5 (trend from 2021 to 2026) | Yes, as the year control in the explorer |
