# 003 · Part 2 · Search: prediction-market prices and outcomes (Kalshi and alternatives)

Launched 2026-11-23 by the lead agent. Subagent type: general-purpose (web research, read only). Adapts course Prompt 2.1 (search for candidate data sets).

## Context
A business analytics student is choosing a course project topic. One candidate question is: "Do event contracts priced as near-sure things pay off as often as their prices say, and where do buyers overpay?" The decision-maker is a person who trades on a prediction market. The ideal data set has one row per settled market (event contract), with the contract's price at a fixed time before it closed (for example 24 hours or 7 days before), its final result (yes or no), trading volume, category (sports, politics, economics, weather and so on), open and close dates, and similar fields. The course requires roughly 500 rows or more, at least three numeric and two categorical variables, public and free data from the original publisher, obtained within the publisher's terms of use (nothing scraped against terms), with documentation of what the fields mean, and reproducible by a stranger (a script that downloads the same data, or a file the terms allow reposting).

## Ask
Find out, from primary pages you actually open:
1. Whether Kalshi offers public market data without an account or API key: which endpoints or downloads return settled markets, results, volume, categories, and historical prices (candlesticks or trade history). Give the documentation page addresses and the field names the documentation lists.
2. What Kalshi's terms (API terms, data terms, developer agreement, website terms of use) say about using market data for academic work and about republishing it in a public GitHub repository. Quote the sentences.
3. Whether Kalshi, the CFTC, or another primary publisher offers bulk historical downloads (CSV) of settled markets.
4. The same three points, briefly, for one alternative primary source of prediction-market data with public historical prices and outcomes (for example Polymarket's public data interfaces, PredictIt's market data, or Manifold), so the student has a fallback.
5. Any limits that would make the data set hard to reproduce: rate limits, pagination, history that expires, fields that change after settlement.

## Constraints
- Report only what is on pages you opened in this search. For every claim give the page address and quote the exact sentence you relied on (short quotes). If a page does not say, write "not stated". Do not estimate and do not fill gaps from general knowledge.
- Do not call any API beyond at most two small unauthenticated test requests to confirm that a documented public endpoint responds; if you do, report the exact address requested and the fields returned. Do not create accounts, sign in, generate keys, accept terms or submit forms. Do not write or edit any files on this computer; return your findings in your final message.
- If a site blocks you, say so and name the page.

## Verify
End with a table: source · what one row would be · fields available (as named in the documentation) · how far back history goes · account or key needed (yes / no / not stated) · terms on academic use and on reposting, quoted · documentation address. Then say plainly, for Kalshi, whether a stranger could rebuild the same table of settled markets with a price from a fixed time before close, and what is the biggest risk to that.

---
Result: *(added when the subagent returns)*
