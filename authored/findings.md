# What I found

Written by Brennan Martin, after the exploration tables were computed.

How to fill this in: for each sub-question, one or two sentences with a number, a comparison and the count behind it, taken from the table named. Then say whether it matched what you expected (your picks are in `authored/eda_expectations.md`). The AI assistant does not write these; after you do, it lists the three strongest alternative explanations for any finding you choose (course Prompt 6.3) without rewriting your words.

| # | Sub-question | Table in `output/tables/` | What I found (number, comparison, count) | Matched what I expected? |
|---|---|---|---|---|
| 1 | How is free play per $100 wagered spread across all sportsbook-months? | eda_01_free_play_spread, eda_01b_free_play_bins | | |
| 2 | In what share of sportsbook-months was no state tax paid? | eda_02_paid_no_tax_share | | |
| 3 | How large are the sportsbooks, and how much wagering goes through the biggest? | eda_03_size_by_operator | | |
| 4 | Which operators deducted the most free play per $100 wagered? | eda_04_free_play_by_operator | | |
| 5 | Did free play per $100 fall, hold or rise from 2021 to 2026? | eda_05_free_play_by_year, eda_05b_free_play_by_month | | |
| 6 | Is free play per $100 different for commercial and tribal operators? | eda_06_free_play_by_operator_type | | |
| 7 | Do bigger months of wagering go with more or less free play per $100? | eda_07_free_play_vs_size_correlation, eda_07b_free_play_by_size_band | | |
| 8 | Is paying no state tax more common among tribal or commercial operators? | eda_08_no_tax_by_operator_type | | |
| 9 | Did the share paying no tax change by year, the same way for both types? | eda_09_no_tax_by_year_and_type | | |
| 10 | Does free play per $100 change as a sportsbook gets older, for both types? | eda_10_free_play_by_age_and_type | | |
| 11 | How much do the unusual months move the answers? | eda_11_unusual_months | | |
| 12 | Which variables move together, and which relate most to the two targets? | eda_12c_correlations_with_each_target; fig12_correlation_heatmap | | |

## The five or six findings that matter most to the decision-maker (these become the figures)

1.
2.
3.
4.
5.
6.
