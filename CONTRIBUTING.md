# Contributing To SkillX

Thanks for contributing to SkillX.

## Principles

- Keep each skill narrowly scoped.
- Write public-safe descriptions and prompts.
- Prefer reusable, cross-platform test fixtures.
- Keep the package tree and source tree in sync.

## Before You Add Or Change A Skill

1. Update `skills/<skill-name>/PLAN.md`.
2. Update the skill implementation and fixtures.
3. Update `skills/INDEX.md` and `packages/skills/INDEX.md`.
4. Update `skills/MANIFEST.json` and `packages/skills/MANIFEST.json` if the published set changes.
5. Run:
   - `python scripts/skill-eval.py --skill-path skills/<skill-name> --mode tests`
   - `python scripts/skill-eval.py --skill-path skills/<skill-name> --mode adversarial`
   - `python scripts/quality-gate.py --skill-path skills/<skill-name> --what-if`
   - `python scripts/release-readiness.py`

## What Reviewers Will Check

- Skill name matches the folder name.
- `x` suffix is intentional and consistent.
- Contracts and golden fixtures are present.
- No Claude-specific branding remains in public skill text.
- The package index reflects the published set.

## Package Layout

The public distribution tree lives under `packages/skills/`.
Keep it aligned with the validated source tree under `skills/`.

