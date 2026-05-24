---
name: code-reviewx
description: This skill should be used when Codex needs to review a git diff, pull request, or recent changes for correctness, regressions, repo-specific standards, and actionable bugs.
---

# Code Review X

Use this skill to review changes for correctness and maintainability before merge.

## Scope
- Review changed files first.
- Focus on bugs, regressions, security issues, and clear standards violations.
- Prefer high-confidence findings over broad nitpicks.

## Workflow
1. Inspect the diff or PR scope.
2. Read repo guidance such as `CLAUDE.md`, `README.md`, or skill-specific notes if present.
3. Check changed code for correctness, edge cases, test impact, and consistency with project patterns.
4. Separate pre-existing issues from issues introduced by the change.
5. Report findings with exact file and line references.

## Output
- Short summary.
- Prioritized findings.
- Clear severity labels when useful.
- State when no issues were found.

## Boundaries
- Do not rewrite unrelated code.
- Do not invent issues without evidence.
- Do not review untouched areas unless the change clearly requires it.

