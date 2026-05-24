#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
from datetime import datetime
from pathlib import Path
import shutil
import sys


def add_result(results, check, passed, detail):
    results.append({"check": check, "passed": passed, "detail": detail})


def main() -> int:
    parser = argparse.ArgumentParser(description="Run Codex skill quality gate.")
    parser.add_argument("--skill-path", required=True)
    parser.add_argument("--what-if", action="store_true")
    args = parser.parse_args()

    skill_path = Path(args.skill_path).expanduser().resolve()
    if not skill_path.is_dir():
        raise SystemExit(f"Skill path not found: {skill_path}")

    results = []
    has_failure = False

    required_files = [
        "SKILL.md",
        "PLAN.md",
        "VERSION",
        "CHANGELOG.md",
        "tests/test-prompts.md",
        "tests/contract.json",
        "tests/golden.json",
        "tests/run-tests.ps1",
        "tests/run-adversarial.ps1",
    ]
    for relative in required_files:
        full = skill_path / relative
        exists = full.is_file()
        add_result(results, f"file:{relative}", exists, "present" if exists else "missing")
        if not exists:
            has_failure = True

    version = ""
    version_file = skill_path / "VERSION"
    if version_file.is_file():
        version = version_file.read_text(encoding="utf-8").strip()
        is_semver = bool(re.match(r"^\d+\.\d+\.\d+$", version))
        add_result(results, "version:semver", is_semver, version)
        if not is_semver:
            has_failure = True

    changelog_file = skill_path / "CHANGELOG.md"
    if changelog_file.is_file() and version:
        changelog = changelog_file.read_text(encoding="utf-8")
        has_version = version in changelog
        add_result(results, "changelog:references-version", has_version, f"version {version}")
        if not has_version:
            has_failure = True

    plan_file = skill_path / "PLAN.md"
    if plan_file.is_file():
        plan = plan_file.read_text(encoding="utf-8")
        headings = [
            "Reference Intake",
            "Assumptions",
            "Verification Gate",
            "Option Matrix",
            "Recommended Approach",
            "Codex Mapping",
            "Implementation Plan",
        ]
        for heading in headings:
            found = heading in plan
            add_result(results, f"plan:{heading}", found, "found" if found else "missing")
            if not found:
                has_failure = True

    if not args.what_if:
        use_powershell = sys.platform.startswith("win") and shutil.which("powershell") is not None
        if use_powershell:
            test_runner = skill_path / "tests/run-tests.ps1"
            if test_runner.is_file():
                result = subprocess.run(["powershell", "-File", str(test_runner)], check=False)
                passed = result.returncode == 0
                add_result(results, "tests:run-tests.ps1", passed, "passed" if passed else "failed")
                if not passed:
                    has_failure = True

            adversarial_runner = skill_path / "tests/run-adversarial.ps1"
            if adversarial_runner.is_file():
                result = subprocess.run(["powershell", "-File", str(adversarial_runner)], check=False)
                passed = result.returncode == 0
                add_result(results, "tests:run-adversarial.ps1", passed, "passed" if passed else "failed")
                if not passed:
                    has_failure = True
        else:
            test_runner_py = skill_path / "tests/run-tests.py"
            if test_runner_py.is_file():
                result = subprocess.run([sys.executable, str(test_runner_py)], check=False)
                passed = result.returncode == 0
                add_result(results, "tests:run-tests.py", passed, "passed" if passed else "failed")
                if not passed:
                    has_failure = True

            adversarial_runner_py = skill_path / "tests/run-adversarial.py"
            if adversarial_runner_py.is_file():
                result = subprocess.run([sys.executable, str(adversarial_runner_py)], check=False)
                passed = result.returncode == 0
                add_result(results, "tests:run-adversarial.py", passed, "passed" if passed else "failed")
                if not passed:
                    has_failure = True
    else:
        add_result(results, "execution", True, "skipped runners due to --what-if")

    skill_eval = Path(__file__).resolve().parent / "skill-eval.py"
    if skill_eval.is_file():
        eval_cmd = [sys.executable, str(skill_eval), "--skill-path", str(skill_path), "--mode", "tests"]
        eval_result = subprocess.run(eval_cmd, check=False)
        passed = eval_result.returncode == 0
        add_result(results, "tests:skill-eval.py", passed, "passed" if passed else "failed")
        if not passed:
            has_failure = True
    else:
        add_result(results, "tests:skill-eval.py", False, "missing")
        has_failure = True

    status = "FAIL" if has_failure else "PASS"
    results_path = skill_path / "tests/results"
    results_path.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    report_file = results_path / f"gate-{version or 'unknown'}-{timestamp}.json"
    report = {
        "timestamp": datetime.now().isoformat(timespec="seconds"),
        "skillPath": str(skill_path),
        "version": version,
        "status": status,
        "checks": results,
    }
    report_file.write_text(json.dumps(report, indent=2), encoding="utf-8")

    print(f"Quality gate {status} for {skill_path}")
    print(f"Report: {report_file}")
    return 1 if has_failure else 0


if __name__ == "__main__":
    raise SystemExit(main())
