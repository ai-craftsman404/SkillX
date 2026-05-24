# Rubric Dimensions

Score each dimension from `1` (low) to `6` (high). Use the definitions below.

## Dimensions and Weights
- `CWL` (Context Window Load) - weight `0.25`
  - How much project context must be tracked simultaneously.
- `DCD` (Dependency Chain Depth) - weight `0.20`
  - How many ordered dependencies or coupled steps are required.
- `AL` (Ambiguity Level) - weight `0.20`
  - How incomplete or conflicting the specification is.
- `BR` (Blast Radius) - weight `0.20`
  - How broadly a mistake could affect systems, users, or interfaces.
- `VC` (Verification Complexity) - weight `0.15`
  - How difficult it is to verify correctness and non-regression.

## Score Anchors
- `1-2`: low signal; straightforward and isolated.
- `3-4`: moderate signal; non-trivial coordination or uncertainty.
- `5-6`: high signal; substantial coupling, risk, or validation burden.

## Composite Formula
`Total = (CWL * 0.25) + (DCD * 0.20) + (AL * 0.20) + (BR * 0.20) + (VC * 0.15)`

## Output Requirements
- Show raw score per dimension.
- Show one-line rationale per dimension.
- Show weighted total rounded to one decimal place.
