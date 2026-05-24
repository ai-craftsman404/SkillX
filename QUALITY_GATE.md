# Skill Quality Gate Standard

All skill releases must pass an enforced quality gate before publish.

## Gate Objectives
- Prevent weak or incomplete skills from being published.
- Enforce deterministic checklist compliance.
- Add adversarial evaluation as a mandatory release control.

## Required Per-Skill Files
- `SKILL.md`
- `PLAN.md`
- `VERSION` (semantic version: `MAJOR.MINOR.PATCH`)
- `CHANGELOG.md` (must include current version)
- `tests/test-prompts.md`
- `tests/run-tests.ps1`
- `tests/run-adversarial.ps1`

## Enforced Checks
- Required files exist.
- `VERSION` is valid semantic version.
- `CHANGELOG.md` references the current version.
- `PLAN.md` contains required plan sections.
- `tests/run-tests.ps1` exits successfully.
- `tests/run-adversarial.ps1` exits successfully.

## Release Flow
1. Run `.\scripts\publish-skills.ps1` (single release path).
2. Publish script calls `.\scripts\quality-gate.ps1` for every skill.
3. If gate passes: backup current release to `<skill-name>__prev`, then publish.
4. Gate report is written to `tests/results/gate-<version>-<timestamp>.json`.
5. Publish event is logged in `publish-log.csv`.

## Rule
- No manual bypass of the quality gate for normal releases.
