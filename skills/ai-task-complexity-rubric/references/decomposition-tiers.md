# Decomposition Tiers

Map weighted total to one tier. Thresholds are fixed for v1.

## Tier 1 - Minimal (`5-10`)
- Execution: proceed directly.
- Decomposition: at most a short two-step outline.
- Controls: lightweight verification.

## Tier 2 - Structured (`10.1-18`)
- Execution: explicit short plan before edits.
- Decomposition: clear ordered steps with dependency awareness.
- Controls: verify key paths and likely regressions.

## Tier 3 - Deep (`18.1-24`)
- Execution: detailed plan with checkpoints.
- Decomposition: split into bounded subtasks; track assumptions and interfaces.
- Controls: stronger validation strategy and rollback awareness.
- Subagents: optional when independent subtasks exist.

## Tier 4 - Critical (`24.1-30`)
- Execution: strict sequencing with explicit risk register.
- Decomposition: fine-grained phases with gates before high-impact changes.
- Controls: comprehensive verification scope and residual-risk statement.
- Subagents: optional, only for clearly independent slices.

## Small Task Guardrail
- If task is plainly trivial, skip full rubric and proceed directly.
- Do not force decomposition that adds overhead without risk reduction.
