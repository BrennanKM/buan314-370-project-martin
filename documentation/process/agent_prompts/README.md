# Subagent prompts

Every prompt the lead AI agent gives to a subagent is saved here word for word **before** the subagent starts, as `NNN_<phase>_<task>.md`, in the course's prompt-card format (Context / Ask / Constraints / Verify). After the subagent finishes, one line is added at the bottom: the result, and whether its checkpoint passed or failed.

| # | File | Phase | Task | Result |
|---|---|---|---|---|
| 001 | [001_p2_michigan_terms_and_definitions.md](001_p2_michigan_terms_and_definitions.md) | 2 Data gate | Terms of use, statute definitions and reporting rules for the Michigan data | *running* |
| 002 | [002_p2_bet_type_data_search.md](002_p2_bet_type_data_search.md) | 2 Data gate | Search for regulator data by bet type (parlays against single bets) | *running* |
| 003 | [003_p2_prediction_market_data_search.md](003_p2_prediction_market_data_search.md) | 2 Data gate | Search for prediction-market price and outcome data and its terms | *running* |
