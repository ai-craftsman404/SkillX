---
name: batchx
description: This skill should be used when Codex needs to coordinate a large change across many files or modules by splitting work into independent units and executing them in a controlled sequence.
---

# Batch X

Use this skill to manage large-scale, parallelizable code changes.

## Scope
- Break large work into independent units.
- Sequence dependent changes carefully.
- Validate each unit before final reconciliation.

## Workflow
1. Map the change into independent work items.
2. Identify dependencies and merge order.
3. Execute units in parallel where safe.
4. Validate each unit before combining results.
5. Perform a final consistency pass.

## Output
- Decomposition plan.
- Progress by unit.
- Final merge/consistency status.

## Boundaries
- Do not use for tiny edits.
- Do not parallelize when units depend on each other.

