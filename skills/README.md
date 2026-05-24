# Local Skills Source

Author skills in subfolders under this directory, with this structure:

- `skills/<skill-name>/SKILL.md`
- `skills/<skill-name>/PLAN.md`
- `skills/<skill-name>/VERSION`
- `skills/<skill-name>/CHANGELOG.md`
- `skills/<skill-name>/tests/test-prompts.md`
- `skills/<skill-name>/tests/run-tests.ps1`
- `skills/<skill-name>/tests/run-adversarial.ps1`
- optional `references/`, `assets/`, `scripts/`

Publish into your shared Codex skills directory with:

```powershell
.\scripts\publish-skills.ps1
```

Python fallback when PowerShell is unavailable:

```bash
python scripts/publish-skills.py
```

The publish command is the single release path and enforces the required files, semantic version format, changelog version entry, backup rollback (`<skill-name>__prev`), and publish logging.
It also runs `scripts/quality-gate.ps1`, including mandatory adversarial checks before publish.

## Skill Test Layers

Each skill in this repo is expected to provide three test layers:

1. `tests/test-prompts.md`
   - Human-readable trigger coverage for positive, negative, and adversarial prompts.
2. `tests/contract.json`
   - A structured contract describing intent, expected outputs, and disallowed behavior.
3. `tests/golden.json`
   - A stable expected-shape fixture used to validate the skill's intended response form.

The shared evaluator is `scripts/skill-eval.py`.
It checks:
- skill metadata
- naming conventions
- prompt coverage
- contract completeness
- golden fixture completeness

This is deterministic and cross-platform.
It is not a live model runner.

## Contributor Rule

When adding a new skill:
- start with `PLAN.md`
- keep the skill name and folder name aligned
- add the three test layers above
- run `scripts/quality-gate.py` and `scripts/skill-eval.py` before publish
