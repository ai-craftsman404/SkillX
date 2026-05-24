# Skill Build Plan: advisor-checkpoint

## 1) Reference Intake
- Source reference(s):
  - Anthropic Advisor tool documentation: https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool
- Intent extracted:
  - Reproduce the strategic quality lift pattern (fast executor + periodic higher-quality advisor guidance) in a Codex-native skill workflow.
- Existing structure/workflow extracted:
  - Early strategic check before substantive work.
  - Mid-task advisor call when stuck or changing approach.
  - Final advisor check before declaring completion.
  - Tight call budgeting and concise, structured advice.

## 2) Assumptions & Gaps
- Assumptions inferred:
  - Codex implementation should mimic behavior/pattern, not Claude API wire protocol.
  - Skill should target coding and multi-step agent tasks first.
  - Advice format should be short, enumerated, and action-oriented.
- Missing inputs:
  - Preferred advisor call budget per task (default candidate: 2-3).
  - Preferred strictness level (hard-stop gate vs advisory gate).
  - Preferred default output template for advisor checkpoints.
- Ambiguities:
  - Whether subagents should be mandatory or optional for "advisor" role.
  - Whether to optimize primarily for cost, speed, or quality.
- Risks (security/cost/maintainability):
  - Over-triggering advisor checkpoints may increase cost/latency.
  - Under-triggering can reduce quality benefits.
  - Loose trigger criteria can create inconsistent behavior.

## 3) Verification Gate (Do not proceed until confirmed)
- Confirmation questions:
  - Confirm default advisor budget: 2-3 checkpoints per substantial task?
  - Confirm hard rule: mandatory early + final checkpoint for substantial tasks?
  - Confirm fallback: if advisor step fails/unavailable, continue with explicit risk note?
- User decisions (confirm/reject/refine):
  - Confirmed: default advisor budget is 2-3 checkpoints per substantial task.
  - Confirmed: mandatory early + final checkpoint for substantial tasks.
  - Confirmed: if advisor step fails/unavailable, continue with explicit risk note.

## 4) Option Matrix (2-3 options)
### Option A - Direct adaptation
- Scope:
  - Single SKILL.md with checkpoint triggers and concise advisor response format.
- Pros:
  - Fastest delivery; lowest complexity.
- Tradeoffs:
  - Less deterministic enforcement; depends on prompt compliance.

### Option B - Modularized skill
- Scope:
  - SKILL.md + references/checklists for trigger matrix, advice format, fallback policy.
- Pros:
  - Better maintainability and clearer policy boundaries.
- Tradeoffs:
  - Slightly more setup effort.

### Option C - Skill + tools/subagents
- Scope:
  - Modular skill plus optional subagent execution pattern for advisor checkpoints.
- Pros:
  - Strongest parity with "separate advisor" mental model.
- Tradeoffs:
  - Higher runtime overhead and complexity.

## 5) Recommended Approach
- Selected option:
  - Option B (Modularized skill).
- Why:
  - Best balance of reliability, clarity, and maintainability for repeated use across projects.
- Non-goals:
  - Replicating Claude-specific API blocks, beta headers, or server tool protocol.

## 6) Codex Mapping
- Skill structure:
  - `skills/advisor-checkpoint/SKILL.md`
  - `skills/advisor-checkpoint/references/checkpoint-matrix.md`
  - `skills/advisor-checkpoint/references/advice-format.md`
  - `skills/advisor-checkpoint/references/fallback-policy.md`
- Agents guidance file:
  - Include "executor vs advisor reasoning posture" and when to escalate.
- Tools integration:
  - Use existing local tools; no custom API tool protocol required.
- Subagents plan (if any):
  - Optional phase-2 enhancement; not required for v1.

## 7) Implementation Plan
- Target path: `skills/advisor-checkpoint/`
- Files to create/update:
  - `SKILL.md`, `VERSION`, `CHANGELOG.md`, `tests/test-prompts.md`, `tests/run-tests.ps1`, `tests/run-adversarial.ps1`, optional `references/*`.
- Test plan:
  - Trigger-positive prompts (complex coding).
  - Trigger-negative prompts (simple direct requests).
  - Adversarial prompts (skip-checkpoint pressure, conflicting evidence, premature done).
  - Fallback behavior tests (advisor unavailable path).
- Edge cases:
  - Very short tasks where checkpoints should not over-trigger.
  - Tasks with rapidly changing evidence mid-execution.
  - Repeated failures where replan threshold should trigger once, not loop.
- Done criteria:
  - Skill passes quality gate and adversarial tests.
  - Checkpoint behavior is consistent across representative prompts.

## 8) Completion Record
- Status:
  - Completed.
- Validation:
  - Quality gate passed for `1.0.0` on 2026-04-15.
  - `run-tests.ps1` passed.
  - `run-adversarial.ps1` passed.
