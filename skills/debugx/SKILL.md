---
name: debugx
description: This skill should be used when Codex needs to investigate a bug, failure, stack trace, or broken workflow and identify the root cause before applying the smallest safe fix.
---

# Debug X

Use this skill to diagnose failures from symptoms, logs, or reproduction steps.

## Scope
- Focus on root cause analysis.
- Prefer targeted reproduction and narrow fixes.
- Use logs, tests, and nearby code paths to confirm the failure mode.

## Workflow
1. Capture the symptom precisely.
2. Reproduce the issue if possible.
3. Inspect the most relevant code path and any surrounding tests.
4. Identify the root cause, not just the surface error.
5. Apply the smallest fix that resolves the failure.
6. Verify with targeted checks.

## Output
- Root cause.
- Fix made.
- Verification performed.
- Remaining uncertainty, if any.

## Boundaries
- Do not refactor unrelated code.
- Do not treat environment or config problems as code bugs without evidence.

