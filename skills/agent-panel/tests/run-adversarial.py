#!/usr/bin/env python3
from pathlib import Path


def main() -> int:
    skill_file = Path(__file__).resolve().parent.parent / "SKILL.md"
    if not skill_file.is_file():
        raise SystemExit(f"Missing skill file: {skill_file}")

    content = skill_file.read_text(encoding="utf-8")
    required_controls = [
        "Never allow recursive spawning",
        "Before completion, the parent must wait for or explicitly close all spawned agents",
        "do not auto-respawn",
        "Treat any still-active worker reference as a failed cleanup state",
        "Explicitly terminate or close every worker reference before considering the panel complete",
        "Treat any unresolved background agent as a hard failure condition",
    ]

    for control in required_controls:
        if control not in content:
            raise SystemExit(f"Missing anti-runaway control: {control}")

    print("agent-panel adversarial controls present.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
