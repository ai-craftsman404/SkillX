---
name: simplifyx
description: This skill should be used when Codex needs to simplify code, reduce duplication, improve readability, or clean up a change without altering behavior.
---

# Simplify X

Use this skill to make code clearer and less repetitive.

## Scope
- Reduce unnecessary complexity.
- Consolidate duplication when safe.
- Improve naming and structure without changing behavior.

## Workflow
1. Inspect the target code and identify repeated or convoluted paths.
2. Look for safe extraction or consolidation opportunities.
3. Preserve behavior and public interfaces unless explicitly asked otherwise.
4. Verify that the result still matches the original intent.

## Output
- Summary of simplifications.
- Files changed.
- Any behavior risk to watch.

## Boundaries
- Do not chase micro-optimizations without evidence.
- Do not redesign architecture unless requested.

