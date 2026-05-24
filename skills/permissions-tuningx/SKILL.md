---
name: permissions-tuningx
description: This skill should be used when Codex needs to reduce repeated permission prompts by identifying safe, recurring read-only commands or low-risk patterns that can be allowlisted.
---

# Permissions Tuning X

Use this skill to reduce avoidable prompts without weakening safety.

## Scope
- Analyze repeated safe command patterns.
- Suggest narrow allowlist additions.
- Preserve clear boundaries around write and destructive actions.

## Workflow
1. Inspect recent prompts or command patterns.
2. Identify repeated read-only or low-risk operations.
3. Propose the smallest safe permission adjustment.
4. Explain the tradeoff.

## Output
- Suggested allowlist entries.
- Risk tradeoff notes.

## Boundaries
- Do not auto-approve writes or destructive commands.
- Do not weaken policy for convenience alone.

