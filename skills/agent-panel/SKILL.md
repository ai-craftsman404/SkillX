# Agent Panel

Use this skill when the user wants Codex to split a complex decision into a small panel of subagents, compare their findings, and return one best recommendation per point.

## Intent
- Generate a few independent perspectives on a bounded problem.
- Compare top options, risks, and tradeoffs without endless debate.
- Produce a concise consensus recommendation with justification.

## Scope
- Best for design review, tradeoff analysis, planning choices, research synthesis, and multi-step decisions.
- Skip for trivial one-step tasks or direct implementation requests unless the user explicitly asks for panel review.

## Operating Rules
- Use the cheapest capable model for subagents.
- Prefer 2 subagents by default; use 3 only when the problem has clearly independent slices and the extra branch materially improves coverage.
- Never allow recursive spawning.
- Keep the parent agent as the only planner and final decision authority.
- Do not spawn extra agents unless each one owns an independently verifiable slice of work.
- Do not continue spawning once the answer is clear enough to decide.
- Do not spawn a helper just to "double-check" the same branch unless there is a distinct risk, contradiction, or missing perspective.
- If the panel does not materially improve confidence after the first pass, collapse back to a direct single-agent answer.

## Anti-Runaway Controls
- Every spawned agent must have:
  - one bounded task
  - one clear deadline
  - one expected output
  - one terminal state
- Allowed terminal states:
  - `done`
  - `blocked`
  - `partial`
- Before completion, the parent must wait for or explicitly close all spawned agents.
- If any agent times out or stops making progress, mark that branch stale, do not auto-respawn, and proceed with the safest reversible path.
- Never finish while a spawned agent is still running, unaccounted for, or waiting on an unresolved parent decision.
- Treat any still-active worker reference as a failed cleanup state until explicitly closed or confirmed finished.
- Treat any unresolved background agent as a hard failure condition that blocks completion until cleanup is verified.

## Panel Workflow
1. Split the user request into 1-3 discrete points.
2. Assign one subagent per point or one subagent per independent slice.
3. Each subagent returns:
   - top 3 ideas
   - main risk or objection
   - recommended choice if forced to pick
   - brief evidence or rationale
4. Synthesize the results centrally.
5. For each point, select one best idea and explain why in one short paragraph.
6. Before final response, confirm no spawned agents remain unaccounted for.
7. Explicitly terminate or close every worker reference before considering the panel complete.

## Output Format
- For each point:
  - `Point`
  - `Top 3 ideas`
  - `Selected best idea`
  - `Brief justification`
- End with:
  - `Residual risks`
  - `Agent cleanup status`

## Completion Standard
- The final answer is short, structured, and decisive.
- No spawned agent remains running or unaccounted for.
- No worker reference is left active, pending, or ambiguous.
- Any unresolved background agent blocks completion until explicitly closed or confirmed finished.
- The recommendation is clearly tied to the user's original request.
- If the panel does not improve confidence, collapse back to a direct single-agent answer.
- Before finishing, perform a final cleanup audit: every spawned agent must be finished, blocked, or explicitly closed.
