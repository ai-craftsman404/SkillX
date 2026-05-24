# Agent Panel Contract

## Roles
- Parent: owns task framing, synthesis, and completion.
- Subagent: owns one bounded slice and returns evidence, risks, and a recommendation.

## Standard Return Shape
- `Point`
- `Top 3 ideas`
- `Main risk`
- `Selected best idea`
- `Brief justification`

## Spawn Rules
- Default panel size: `2`.
- Maximum panel size: `3`.
- Spawn only when the slice is independently verifiable.
- Never recurse or respawn automatically.

## Cleanup Rules
- Each spawned agent must return `done`, `blocked`, or `partial`.
- Parent must wait for or explicitly close every spawned agent before finishing.
- If the panel stops improving confidence, stop spawning and return the best direct answer.
