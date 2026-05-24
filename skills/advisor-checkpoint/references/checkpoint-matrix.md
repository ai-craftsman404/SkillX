# Checkpoint Trigger Matrix

Use this matrix to decide when to run advisor checkpoints.

## Task Classification
- Trivial:
  - Single-file small edit, direct answer, or routine command with obvious outcome.
  - Default: no checkpoint.
- Substantial:
  - Multi-step reasoning, multi-file edits, uncertain requirements, or non-obvious tradeoffs.
  - Default: early + final checkpoints required.

## Required Triggers
- Early checkpoint:
  - Run before substantive implementation for substantial tasks.
- Final checkpoint:
  - Run before declaring task complete for substantial tasks.

## Conditional Mid-Task Trigger
Run one mid-task checkpoint when any of the following occurs:
- Stuck for a meaningful interval without clear progress.
- New evidence invalidates the current approach.
- Proposed solution shifts architecture, risk profile, or delivery path.
- Repeated failure suggests current tactic is ineffective.

## Suppression Rules
- Do not over-trigger for short, deterministic requests.
- Do not repeat the same checkpoint question after a clear answer.
- Replan once per trigger event; avoid loops.
