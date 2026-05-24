# Skills Index

| Skill | Purpose |
|---|---|
| `code-reviewx` | Review diffs and PRs for bugs, regressions, and standards issues. |
| `debugx` | Diagnose failures from symptoms, logs, or traces and apply the smallest safe fix. |
| `verifyx` | Confirm a change works in the running app or user-facing workflow. |
| `simplifyx` | Reduce duplication and complexity without changing behavior. |
| `batchx` | Coordinate large changes by splitting them into independent units. |
| `openai-apix` | Build or migrate code that uses the OpenAI API or SDKs. |
| `loopx` | Repeat checks or tasks until a stop condition is met. |
| `runx` | Run the app or service and verify a real user-facing flow. |
| `permissions-tuningx` | Reduce repeated permission prompts safely. |

## Package Layout

Each skill uses the same package structure:

- `SKILL.md`
- `PLAN.md`
- `VERSION`
- `CHANGELOG.md`
- `tests/test-prompts.md`
- `tests/contract.json`
- `tests/golden.json`
- `tests/run-tests.ps1`
- `tests/run-adversarial.ps1`
- optional Python runners for cross-platform execution

## Notes

- Skill names intentionally use the `x` suffix to keep the public repo identity distinct.
- The shared evaluator is in `scripts/skill-eval.py`.
- The release readiness entrypoint is `scripts/release-readiness.py`.
- The mirrored public package root is `packages/skills/`.
