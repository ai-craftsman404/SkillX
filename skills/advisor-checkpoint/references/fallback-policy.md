# Fallback Policy

Use this policy when an advisor checkpoint cannot be completed.

## Failure Conditions
- Advisor reasoning step unavailable.
- Context insufficient to run a meaningful checkpoint.
- Time or budget pressure prevents checkpoint execution.

## Required Fallback Actions
1. State that checkpoint could not be executed.
2. Record the highest-impact uncertainty as a risk note.
3. Choose the most conservative next action that preserves reversibility.
4. Add a verification step before final completion.

## Reporting Standard
- Include a short residual risk statement in final output.
- Do not claim checkpoint confidence when fallback path was used.
- Resume normal checkpoint flow if conditions recover.
