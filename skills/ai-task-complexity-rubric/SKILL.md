# AI Task Complexity Rubric

Use this skill to assess coding-task complexity with AI-relevant signals, then choose decomposition depth, sequencing discipline, and risk controls.

## Intent
- Score task complexity without using human time estimates.
- Use a consistent weighted rubric to choose execution posture.
- Improve outcomes on high-complexity tasks by matching process depth to risk.

## Scope
- Best for non-trivial coding requests with multiple moving parts, unclear boundaries, or meaningful blast radius.
- Skip full scoring for clearly trivial requests.
- This skill is Codex-native and does not rely on external protocol blocks.

## Strict Rule
- Never output human time estimates, duration guesses, or man-hour ranges.
- Express effort only through rubric scores, tiers, and decomposition guidance.

## Rubric Workflow
1. Evaluate the task across the 5 dimensions in [`references/rubric-dimensions.md`](references/rubric-dimensions.md).
2. Assign a 1-6 score per dimension with one short rationale each.
3. Compute weighted total using [`references/rubric-dimensions.md`](references/rubric-dimensions.md).
4. Map the total to a tier using [`references/decomposition-tiers.md`](references/decomposition-tiers.md).
5. Produce the fixed output format from [`references/output-template.md`](references/output-template.md).
6. Apply Codex execution mapping from [`references/codex-mapping-notes.md`](references/codex-mapping-notes.md).

## Operational Rules
- Preserve fixed tier thresholds: `5-10`, `10.1-18`, `18.1-24`, `24.1-30`.
- Keep dimension set and weights unchanged for v1.
- Include explicit sequencing and risk controls for tier 3-4 outcomes.
- Keep recommendations concrete and immediately actionable.
- If task input is contradictory, state assumptions before scoring.

## Completion Standard
- Output includes all 5 dimensions, weighted total, and tier.
- Decomposition guidance matches the computed tier.
- No human time language appears in the response.
