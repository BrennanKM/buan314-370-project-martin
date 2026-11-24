# What I expect

Picked by Brennan Martin on 2026-11-23, **before** any exploration table, correlation matrix, figure or model was computed (the commit that adds this file comes before the commit that adds the first exploration table).

How these were collected, stated plainly: the AI assistant asked each question with three or four possible answers and no recommended option. Each option carried a one-line reason someone might hold it; those reasons were written by the assistant, not by Brennan. The answer recorded for each question is the option Brennan picked, word for word. He had first answered "up to you"; the assistant declined to choose for him and asked again.

A few screening numbers from the data gate had been shown before this: the two targets' correlations (including r = 0.59 with the prior month), that 48.6% of months had no tax paid, and medians by year and by operator type in a file the assistant wrote. Questions 2 and 12 therefore asked what he would have guessed before seeing the number.

| # | Sub-question | Brennan's pick | Options offered |
|---|---|---|---|
| 1 | How is free play per $100 wagered spread across all sportsbook-months? | **Two clusters** | Bunched low, long tail · Evenly spread · Two clusters |
| 2 | In what share of sportsbook-months was no state tax paid? (what he would have guessed before seeing the screening number, 48.6%) | **Under 10%** | Under 10% · About a quarter · About half · Well over half |
| 3 | How much of all dollars wagered do the three biggest operators account for? | **50% to 70%** | Under half · 50% to 70% · 70% to 85% · Over 85% |
| 4 | Which operators deducted the most free play per $100 wagered: big national brands or smaller operators? | **Big brands more** | Small operators more · About the same · Big brands more |
| 5 | From 2021 to 2026, did free play per $100 wagered fall, hold steady or rise? | **Rose** | Fell · Held steady · Rose |
| 6 | Is free play per $100 wagered higher for commercial or tribal operators? | **Commercial higher** | Commercial higher · About the same · Tribal higher |
| 7 | Do bigger months of wagering go with more or less free play per $100? | **More in bigger months** | More in bigger months · No clear link · Less in bigger months |
| 8 | Is a month with no state tax paid more common among tribal or commercial operators? | **More common for tribal** | More common for tribal · About the same · More common for commercial |
| 9 | From 2021 to 2026, how did the share of sportsbooks paying no state tax change, for commercial and tribal operators? | **Rose** | Fell for both types · Fell for tribal only · Stayed about the same · Rose |
| 10 | As a sportsbook gets older, what happens to its free play per $100 wagered? | **High at launch, then drops fast** | High at launch, then drops fast · Declines slowly over years · No pattern with age · Rises with age |
| 11 | If the 21 lump-deduction months and the 15 partial first months are set aside, how much do the main answers change? | **Not at all** | A lot · A little · Not at all |
| 12 | Which is most strongly related to a sportsbook's free play per $100 this month? (what he would have guessed before seeing r = 0.59 for last month's value) | **Size of the sportsbook** | Last month's free play · Size of the sportsbook · Age of the sportsbook · Operator type |

## In my own words (optional, Brennan)

*A sentence on why I expected each of these can be added here by Brennan. The assistant does not write it.*

## Model slopes (filled in after the predictors are chosen, before any model is fitted)

*(One line per predictor: the direction Brennan expects.)*
