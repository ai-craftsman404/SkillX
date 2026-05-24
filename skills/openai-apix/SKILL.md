---
name: openai-apix
description: This skill should be used when Codex needs help building, debugging, or migrating code that uses the OpenAI API or OpenAI SDKs.
---

# OpenAI API X

Use this skill for OpenAI API and SDK work.

## Scope
- Help implement OpenAI-based features in the project language.
- Prefer official SDK patterns and current model guidance.
- Support migration, tool calling, structured outputs, streaming, and batch workflows.

## Workflow
1. Detect the project language and existing API usage.
2. Confirm the target OpenAI surface.
3. Read the relevant docs before coding.
4. Implement the smallest correct integration.
5. Verify the result against the repo's conventions.

## Output
- Code changes.
- Integration rationale.
- Migration notes when relevant.

## Boundaries
- Do not mix providers accidentally.
- Do not guess SDK signatures.

