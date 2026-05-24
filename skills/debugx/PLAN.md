# Skill Build Plan: debugx

## 1) Reference Intake
- Source reference(s):
  - Public Claude Code debugging workflows and session debugging guidance.
- Intent extracted:
  - Diagnose failures from logs, traces, and reproduction steps.

## 2) Assumptions & Gaps
- Assumptions inferred:
  - Codex should prioritize root cause over broad cleanup.
- Missing inputs:
  - Preferred verification strategy by project type.

## 3) Verification Gate
- Confirmation decisions:
  - Use targeted reproduction.
  - Keep fixes minimal and evidence-based.

## 4) Option Matrix
### Option A - Single-file skill
- Scope:
  - One SKILL.md with debugging workflow.
- Pros:
  - Simple.
- Tradeoffs:
  - Less reusable structure.

## 5) Recommended Approach
- Selected option:
  - Option A.

## 6) Codex Mapping
- Skill structure:
  - `skills/debugx/SKILL.md`

## 7) Implementation Plan
- Create core skill file and release metadata.
- Add test prompts for positive, negative, and adversarial cases.

