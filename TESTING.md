# Skill Testing Guide

This repository validates skills in layers.

## 1) Release Gate
- `scripts/quality-gate.py` checks required files, versioning, changelog linkage, and the skill runners.
- `scripts/publish-skills.ps1` is the release path and must pass the gate first.

## 2) Shared Skill Evaluator
- `scripts/skill-eval.py` validates the skill contract.
- It is cross-platform and deterministic.
- It verifies:
  - `SKILL.md` metadata
  - naming conventions
  - prompt coverage
  - `tests/contract.json`
  - `tests/golden.json`

## 3) What The Fixtures Mean
- `tests/test-prompts.md` documents trigger scope.
- `tests/contract.json` captures the intended behavior contract.
- `tests/golden.json` captures the expected answer shape.

## 4) Current Limits
- The repo does not yet run a live Codex model session.
- The current harness validates structure and intended behavior shape, not actual model output.

## 5) Adding A New Skill
- Start with `skills/<skill-name>/PLAN.md`.
- Use a unique `x`-suffixed name if you want it to remain distinct from an external source.
- Add the required files and the three validation layers.
- Run the quality gate and the shared evaluator before publish.
