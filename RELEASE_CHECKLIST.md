# Release Checklist

Use this before publishing skills to a public repo.

## Repo Hygiene
- [ ] Skill names are unique and intentionally branded.
- [ ] Skill folders match `name:` in `SKILL.md`.
- [ ] Descriptions are public-safe and Codex-specific.
- [ ] No Claude branding remains in public skill text.

## Required Files
- [ ] `SKILL.md`
- [ ] `PLAN.md`
- [ ] `VERSION`
- [ ] `CHANGELOG.md`
- [ ] `tests/test-prompts.md`
- [ ] `tests/contract.json`
- [ ] `tests/golden.json`
- [ ] `tests/run-tests.ps1`
- [ ] `tests/run-adversarial.ps1`

## Validation
- [ ] `python scripts/quality-gate.py --skill-path <skill> --what-if`
- [ ] `python scripts/skill-eval.py --skill-path <skill> --mode tests`
- [ ] `python scripts/skill-eval.py --skill-path <skill> --mode adversarial`
- [ ] `.\scripts\publish-skills.ps1` dry run

## Public-Repo Readiness
- [ ] README explains the testing layers.
- [ ] Contributor docs explain how to add a new skill.
- [ ] Golden fixtures exist for every skill.
- [ ] Integration fixtures exist for runtime-oriented skills.
- [ ] A clean machine can run the full validation flow.
