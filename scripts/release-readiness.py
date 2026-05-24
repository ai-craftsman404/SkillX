#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str]) -> int:
    result = subprocess.run(cmd, check=False)
    return result.returncode


def main() -> int:
    parser = argparse.ArgumentParser(description="Run full release readiness checks for all skills.")
    parser.add_argument("--skills-root", default=str(Path(__file__).resolve().parent.parent / "skills"))
    args = parser.parse_args()

    skills_root = Path(args.skills_root).expanduser().resolve()
    if not skills_root.is_dir():
        raise SystemExit(f"Skills root not found: {skills_root}")

    python = sys.executable
    failed = []
    for skill_dir in sorted(p for p in skills_root.iterdir() if p.is_dir() and p.name.endswith("x")):
        print(f"== {skill_dir.name} ==")
        if run([python, str(Path(__file__).resolve().parent / "skill-eval.py"), "--skill-path", str(skill_dir), "--mode", "tests"]) != 0:
            failed.append(f"{skill_dir.name}:skill-eval-tests")
        if run([python, str(Path(__file__).resolve().parent / "skill-eval.py"), "--skill-path", str(skill_dir), "--mode", "adversarial"]) != 0:
            failed.append(f"{skill_dir.name}:skill-eval-adversarial")
        if run([python, str(Path(__file__).resolve().parent / "quality-gate.py"), "--skill-path", str(skill_dir), "--what-if"]) != 0:
            failed.append(f"{skill_dir.name}:quality-gate")

    if failed:
        print("FAILED:")
        for item in failed:
            print(f" - {item}")
        return 1

    print("Release readiness PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
