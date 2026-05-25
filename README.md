# SkillX

SkillX is a curated set of Codex-native skills for repeatable engineering workflows, validation, and repo operations. Each skill ships with a clear contract, test fixtures, and a release gate so it can be reused with confidence.

Use this repo as a public reference for building, testing, and organizing focused skills that stay narrow, portable, and publishable.

![SkillX Badge](assets/skillx-badge.png)

## Quick Start

1. Inspect the skill catalog in [`skills/INDEX.md`](skills/INDEX.md).
2. Run the release readiness sweep:
   ```bash
   python scripts/release-readiness.py
   ```
3. Review the package root in [`packages/skills/`](packages/skills/).
4. Add or update a skill under [`skills/`](skills/).
5. Re-run the validation before publishing.

## What Ships

- `packages/skills/` is the public package root for remote distribution and documentation.
- `skills/` is the validated source tree used by the local release gate.

## Skills at a Glance

| Skill | What it does |
|---|---|
| `code-reviewx` | Reviews diffs and PRs for bugs, regressions, and standards issues. |
| `debugx` | Diagnoses failures from symptoms, logs, or traces and applies the smallest safe fix. |
| `verifyx` | Confirms a change works in the running app or user-facing workflow. |
| `simplifyx` | Reduces duplication and complexity without changing behavior. |
| `batchx` | Coordinates large changes by splitting them into independent units. |
| `openai-apix` | Helps build or migrate code that uses the OpenAI API or SDKs. |
| `loopx` | Repeats checks or tasks until a stop condition is met. |
| `runx` | Runs the app or service and verifies a real user-facing flow. |
| `permissions-tuningx` | Reduces repeated permission prompts safely. |

## Skill Groups

- Review and cleanup: `code-reviewx`, `simplifyx`
- Diagnosis and verification: `debugx`, `verifyx`, `runx`
- Orchestration and repetition: `batchx`, `loopx`
- API integration: `openai-apix`
- Permission policy: `permissions-tuningx`

## Repository Layout

The repo is organized as a package root plus a validated skill source tree:

```text
SkillX/
├── README.md
├── CONTRIBUTING.md
├── TESTING.md
├── RELEASE_CHECKLIST.md
├── packages/
│   └── skills/
│       ├── README.md
│       ├── INDEX.md
│       └── MANIFEST.json
├── scripts/
├── skills/
│   ├── INDEX.md
│   ├── MANIFEST.json
│   ├── code-reviewx/
│   ├── debugx/
│   ├── verifyx/
│   ├── simplifyx/
│   ├── batchx/
│   ├── openai-apix/
│   ├── loopx/
│   ├── runx/
│   └── permissions-tuningx/
└── publish-log.csv
```

## Validation

- Run `python scripts/release-readiness.py` to validate the full set.
- Run `python scripts/quality-gate.py --skill-path <skill> --what-if` for a single skill.
- Run `python scripts/skill-eval.py --skill-path <skill> --mode tests` for the shared contract checks.
- Run `python scripts/skill-eval.py --skill-path <skill> --mode adversarial` for the adversarial contract checks.

## Development Due Diligence

These skills were developed with a layered validation harness and public-release discipline:

- skill-specific `PLAN.md` files before implementation
- per-skill `test-prompts.md` trigger coverage
- structured `contract.json` checks for intent and output boundaries
- `golden.json` fixtures for expected response shape
- cross-platform Python-based evaluator support
- release-gate enforcement through `scripts/quality-gate.py`
- repo-wide readiness checks through `scripts/release-readiness.py`
- public-repo guidance aligned to Codex-native skill organization and repeatable workflow design

This harness is intentionally deterministic and repeatable. It validates packaging, scope, and expected behavior shape; it does not replace live model execution in a production environment.

## Contributing

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) before changing or adding a skill.

## Release Rule

All skills should remain public-safe, Codex-native, narrowly scoped, and cross-platform in test execution.

## Publishing Flow

The intended public release workflow is:

1. Build and verify the skill under `skills/`.
2. Mirror the validated content into `packages/skills/` for the remote package view.
3. Run `python scripts/release-readiness.py`.
4. Publish only when the full sweep passes.

## Repository Notes

- The `x` suffix is deliberate and keeps the skill names distinct.
- The package root is intentionally separate from the source tree so the repo can evolve safely.
- The badge area is reserved for your generated image asset or a future GitHub badge.
