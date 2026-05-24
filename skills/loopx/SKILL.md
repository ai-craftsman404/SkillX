---
name: loopx
description: This skill should be used when Codex needs to repeat a task or check on a condition over time until a stop criterion is met.
---

# Loop X

Use this skill for repeated checks, polling, and scheduled re-runs.

## Scope
- Repeat a prompt or verification at a chosen interval.
- Preserve state between iterations when useful.
- Stop when the condition is satisfied.

## Workflow
1. Define the prompt and stop condition.
2. Pick a safe interval or pacing strategy.
3. Repeat the check while the condition remains unmet.
4. Record the latest result and termination reason.

## Output
- Latest status.
- Iteration summary.
- Stop reason.

## Boundaries
- Do not create open-ended loops without a stop condition.
- Do not use when a one-shot action is sufficient.

