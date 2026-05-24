# Advisor Checkpoint Skill

Use this skill to add lightweight strategic checkpoints to substantial coding or multi-step tasks so execution quality stays high without over-planning.

## Intent
- Apply an `executor + advisor` working pattern in a Codex-native workflow.
- Improve decision quality at key points: before deep work, during major uncertainty, and before completion.
- Keep advice short, actionable, and bounded by a strict call budget.

## Scope
- Best for substantial tasks: multi-file edits, complex debugging, design tradeoff decisions, or changing requirements.
- Skip for trivial one-step requests unless risk is high.
- This skill defines workflow behavior only; it does not require external API protocol blocks.

## Default Policy
- Advisor budget: `2-3` checkpoints for substantial tasks.
- Mandatory checkpoints for substantial tasks:
  - Early checkpoint before substantive implementation.
  - Final checkpoint before declaring completion.
- Optional mid-task checkpoint:
  - Trigger when stuck, when evidence contradicts current plan, or when approach materially changes.
- Fallback behavior:
  - If advisor checkpoint cannot run, continue with explicit risk note and conservative next step.

## Executor vs Advisor Posture
- Executor posture:
  - Focus on implementation, verification, and direct progress.
  - Preserve momentum and avoid unnecessary abstraction.
- Advisor posture:
  - Critique strategy, assumptions, risks, and verification quality.
  - Prefer shortest corrective guidance that improves outcome.
- Escalate from executor to advisor posture only at checkpoint triggers.

## Checkpoint Workflow
1. Determine if task is substantial using [`references/checkpoint-matrix.md`](references/checkpoint-matrix.md).
2. Reserve budget (`2-3`) and note expected checkpoint moments.
3. Run early checkpoint before major edits or irreversible decisions.
4. Run optional mid-task checkpoint only when a trigger condition is met.
5. Run final checkpoint before completion statement.
6. If a checkpoint fails/unavailable, apply [`references/fallback-policy.md`](references/fallback-policy.md).
7. Format advice using [`references/advice-format.md`](references/advice-format.md).

## Operational Rules
- Keep each checkpoint response concise and enumerated.
- Prefer action-oriented corrections over broad rewrites.
- Avoid repetitive checkpoint loops; at most one replan cycle per trigger.
- If no strategic risk is found, explicitly state that and proceed.

## Completion Standard
- Task outcome reflects checkpoint guidance where applicable.
- Budget was respected or overage justified.
- Final validation includes a clear risk callout (none or specific residual risk).
