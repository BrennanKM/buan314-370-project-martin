# Subagent prompts

Every prompt the lead AI agent gives to a subagent is saved here word for word **before** the subagent starts, as `NNN_<phase>_<task>.md`, in the course's prompt-card format (Context / Ask / Constraints / Verify). After the subagent finishes, one line is added at the bottom: the result, and whether its checkpoint passed or failed.

| # | File | Phase | Task | Result |
|---|---|---|---|---|
