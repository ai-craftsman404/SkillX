# Skill Build Plan: ai-task-complexity-rubric

## 1) Reference Intake
- Source reference(s):
  - User-provided Claude Code rubric draft (full text in session context).
  - Mandatory baseline for Codex skills: https://developers.openai.com/codex/skills
- Intent extracted:
  - Create a Codex-native skill that scores task complexity using AI-relevant dimensions instead of human time estimates.
  - Use the score to drive decomposition depth, sequencing, and risk controls.
- Existing structure/workflow extracted:
  - 5 scored dimensions (CWL, DCD, AL, BR, VC), weighted composite score, tiered decomposition rules, fixed output format, example assessment, and integration guidance.

## 2) Assumptions & Gaps
- Assumptions inferred:
  - Keep the same 5 dimensions and weighting model in v1.
  - Keep the same output table format with rationale per dimension.
  - Reproduce behavior, but map all Claude-specific mechanics to Codex-native guidance.
- Missing inputs:
  - Final skill name preference (`ai-task-complexity-rubric` vs alternative).
  - Whether score thresholds should remain identical in v1.
  - Whether decomposition guidance should explicitly encourage subagents by default at high tiers.
- Ambiguities:
  - How strict to enforce "no human time units" (hard prohibition vs soft preference).
  - Whether to require planning mode equivalents for all medium+ tasks.
- Risks (security/cost/maintainability):
  - Over-decomposition may slow delivery.
  - Under-decomposition on high-score tasks may cause failure/rework.
  - If thresholds are not calibrated, tier recommendations may be noisy.

## 3) Verification Gate (Do not proceed until confirmed)
- Confirmation questions:
  - Confirm v1 keeps the same 5 dimensions and current weights?
  - Confirm v1 keeps the same tier thresholds (`5-10`, `10.1-18`, `18.1-24`, `24.1-30`)?
  - Confirm strict rule: never output human time estimates in this skill?
- User decisions (confirm/reject/refine):
  - Confirmed: keep the same 5 dimensions and current weights for v1.
  - Confirmed: keep the same tier thresholds for v1.
  - Confirmed: enforce strict rule to never output human time estimates in this skill.

## 4) Option Matrix (2-3 options)
### Option A - Direct adaptation
- Scope:
  - One `SKILL.md` with rubric, formula, tiers, and output template.
- Pros:
  - Fastest to ship.
- Tradeoffs:
  - Harder to tune parts independently.

### Option B - Modularized skill
- Scope:
  - `SKILL.md` + reference files for rubric, decomposition policy, and examples.
- Pros:
  - Easier maintenance and tuning.
- Tradeoffs:
  - Slightly larger initial setup.

### Option C - Skill + tools/subagents
- Scope:
  - Modularized skill plus optional helper script to compute composite scores and/or optional subagent guidance for high tiers.
- Pros:
  - More deterministic scoring; stronger repeatability.
- Tradeoffs:
  - More implementation complexity for v1.

## 5) Recommended Approach
- Selected option:
  - Option B (Modularized skill).
- Why:
  - Best balance of clarity, maintainability, and low-risk delivery for first Codex release.
- Non-goals:
  - Replicating Claude-only commands/protocols verbatim.

## 6) Codex Mapping
- Skill structure:
  - `skills/ai-task-complexity-rubric/SKILL.md`
  - `skills/ai-task-complexity-rubric/references/rubric-dimensions.md`
  - `skills/ai-task-complexity-rubric/references/decomposition-tiers.md`
  - `skills/ai-task-complexity-rubric/references/output-template.md`
  - `skills/ai-task-complexity-rubric/references/codex-mapping-notes.md`
- Agents guidance file:
  - Include explicit mapping for planning, dependency chains, and context management in Codex terms.
- Tools integration:
  - No custom API tool required for v1.
- Subagents plan (if any):
  - Optional for high/critical tiers; not mandatory in v1.

## 7) Implementation Plan
- Target path: `skills/ai-task-complexity-rubric/`
- Files to create/update:
  - `SKILL.md`, `VERSION`, `CHANGELOG.md`, `tests/test-prompts.md`, `tests/run-tests.ps1`, `tests/run-adversarial.ps1`, and planned `references/*`.
- Test plan:
  - Trigger-positive prompts: complexity assessment requests with multi-step tasks.
  - Trigger-negative prompts: straightforward implementation-only requests.
  - Adversarial prompts: ask for man-hour estimates, ask to skip scoring, contradictory task inputs.
  - Consistency test: same task description should yield stable tier classification.
- Edge cases:
  - Very small tasks where rubric should not overcomplicate execution.
  - Highly ambiguous exploratory tasks with low code footprint.
  - High blast radius but low context load cases.
- Done criteria:
  - Skill passes quality gate and adversarial tests.
  - Output format is consistent and Codex-native.
  - No Claude-specific command/protocol leakage.

## 8) Final Status Summary
- Implementation completed for all planned files and references.
- Validation run executed via `./scripts/publish-skills.ps1 -WhatIf`.
- Gate result for this skill: `PASS`.
- Post-validation remediation: `none`.
