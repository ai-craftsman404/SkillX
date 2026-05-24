# Skill Build Plan: code-reviewx

## 1) Reference Intake
- Source reference(s):
  - Public Claude Code code review workflow documentation and plugin behavior.
- Intent extracted:
  - Review diffs and PRs with a multi-pass, high-confidence bias.
- Existing structure/workflow extracted:
  - Diff-first review.
  - Project-guideline compliance checks.
  - Findings grounded in exact line references.

## 2) Assumptions & Gaps
- Assumptions inferred:
  - Codex-native skill should review repo changes, not mirror Claude prompts verbatim.
  - Public repo wording should be generic and brand-safe.
- Missing inputs:
  - Desired severity taxonomy.
  - Whether GitHub comment formatting is needed in v1.

## 3) Verification Gate
- Confirmation decisions:
  - Use diff-first review and high-confidence filtering.
  - Keep findings narrow and actionable.

## 4) Option Matrix
### Option A - Minimal review skill
- Scope:
  - One SKILL.md with review checklist and output rules.
- Pros:
  - Simple and easy to maintain.
- Tradeoffs:
  - Less structured validation.

### Option B - Review skill with references
- Scope:
  - SKILL.md plus reference files for severity and output format.
- Pros:
  - Better consistency and easier expansion.
- Tradeoffs:
  - Slightly more file overhead.

## 5) Recommended Approach
- Selected option:
  - Option A for v1.
- Why:
  - The public repo can start small and expand after usage feedback.

## 6) Codex Mapping
- Skill structure:
  - `skills/code-reviewx/SKILL.md`
- Future extensions:
  - Add reference files for review rubric, comment templates, and confidence rules.

## 7) Implementation Plan
- Create core skill file.
- Add required release metadata.
- Add test prompts for positive, negative, and adversarial cases.

