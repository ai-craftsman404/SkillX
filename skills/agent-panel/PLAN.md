# Skill Build Plan: agent-panel

## 1) Reference Intake
- Source reference(s):
  - User request: create a Codex skill for a panel of subagents that researches and agrees on the best idea per point.
  - Repo conventions from `skills/ai-task-complexity-rubric/SKILL.md` and `skills/advisor-checkpoint/SKILL.md`.
- Intent extracted:
  - Build a Codex-native skill for multi-agent review, consensus selection, and bounded orchestration.
- Existing structure/workflow extracted:
  - Use a small subagent panel, compare top 3 ideas per point, and return a concise selected recommendation.
  - Add explicit anti-runaway rules for spawn limits, deadlines, and cleanup.

## 2) Assumptions & Gaps
- Assumptions inferred:
  - The skill should be globally reusable across projects after publish.
  - The default panel size should stay small to control cost and coordination overhead.
  - The user wants practical orchestration rules, not a generic brainstorming skill.
- Missing inputs:
  - Whether the default panel size should be 2 or 3.
  - Whether to add reference files for scoring or keep v1 self-contained.
  - Whether to include explicit model names in the skill or keep model choice abstract.
- Ambiguities:
  - How aggressive to be in stopping at the first sufficiently good recommendation.
  - Whether a final cleanup audit should be stated as a hard requirement or a best practice.
- Risks:
  - Over-triggering on simple tasks if the scope is too broad.
  - Runaway or zombie subagents if cleanup rules are not explicit.
  - Excess coordination overhead if the panel size is too large.

## 3) Verification Gate
- Confirmation questions:
  - Confirm the default panel size should be `2-3` subagents, not more.
  - Confirm anti-runaway rules should be strict: no recursion, no auto-respawn, mandatory cleanup.
  - Confirm the skill should prioritize concise consensus over extended debate.
- User decisions:
  - Default panel size confirmed as small and cost-effective.
  - Anti-runaway constraints confirmed as required.
  - Concise consensus output confirmed as the goal.

## 4) Option Matrix
### Option A - Minimal self-contained skill
- Scope:
  - One `SKILL.md` plus required release files.
- Pros:
  - Fastest to ship.
  - Lowest maintenance overhead.
- Tradeoffs:
  - Less reusable structure for future refinements.

### Option B - Skill with reference files
- Scope:
  - `SKILL.md` plus references for panel roles, output format, and safety policy.
- Pros:
  - Easier to expand later.
  - Better separation of core rules and details.
- Tradeoffs:
  - Slightly more file overhead.

### Option C - Skill plus helper automation
- Scope:
  - Skill plus scripts for spawn budgets and panel formatting.
- Pros:
  - More deterministic.
- Tradeoffs:
  - Not necessary for v1 and adds complexity.

## 5) Recommended Approach
- Selected option:
  - Option A, with strong operational rules inside `SKILL.md`.
- Why:
  - The workflow is simple enough to keep in one file for v1.
  - The main requirement is reliable behavior, not a large framework.
- Non-goals:
  - Building a generic debate framework.
  - Adding external tool dependencies.

## 6) Codex Mapping
- Skill structure:
  - `skills/agent-panel/SKILL.md`
  - `skills/agent-panel/PLAN.md`
  - `skills/agent-panel/VERSION`
  - `skills/agent-panel/CHANGELOG.md`
  - `skills/agent-panel/tests/test-prompts.md`
  - `skills/agent-panel/tests/run-tests.ps1`
  - `skills/agent-panel/tests/run-adversarial.ps1`
- Agents guidance:
  - Parent agent retains ownership of synthesis and completion.
  - Subagents are bounded contributors only.
- Tools integration:
  - No custom script required for v1.

## 7) Implementation Plan
- Target path: `skills/agent-panel/`
- Files to create:
  - `SKILL.md`, `PLAN.md`, `VERSION`, `CHANGELOG.md`, `tests/test-prompts.md`, `tests/run-tests.ps1`, `tests/run-adversarial.ps1`
- Test plan:
  - Positive prompts: requests for panel review, option comparison, and consensus selection.
  - Negative prompts: one-step implementation requests and trivial fixes.
  - Adversarial prompts: prompts that encourage unlimited agents, recursive spawning, or no cleanup.
- Done criteria:
  - Skill passes quality gate.
  - Anti-runaway rules are explicit.
  - The skill is concise and reusable.
