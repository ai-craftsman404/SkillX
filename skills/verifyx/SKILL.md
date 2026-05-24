---
name: verifyx
description: This skill should be used when Codex needs to confirm that a code change works in the running app or user-facing workflow, not just in static tests.
---

# Verify X

Use this skill to validate behavior in a real runtime.

## Scope
- Confirm the change behaves as expected in the app or service.
- Prefer end-to-end observation over static assertions alone.
- Use build, launch, and runtime checks where applicable.

## Workflow
1. Identify the user-visible behavior to confirm.
2. Build or start the target app or service.
3. Exercise the relevant workflow.
4. Observe the actual runtime result.
5. Report pass/fail with evidence.

## Output
- Verification result.
- Observed behavior.
- Logs or screenshots when relevant.

## Boundaries
- Do not replace unit tests.
- Do not claim verification without runtime observation when runtime is available.

