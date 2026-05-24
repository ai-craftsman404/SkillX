#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Check:
    name: str
    passed: bool
    detail: str


def parse_prompt_sections(text: str) -> dict[str, list[str]]:
    sections: dict[str, list[str]] = {}
    current = None
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if line.startswith("## "):
            current = line[3:].strip()
            sections[current] = []
        elif current and line.startswith("- "):
            sections[current].append(line[2:].strip())
    return sections


def load_skill_text(skill_path: Path) -> str:
    return (skill_path / "SKILL.md").read_text(encoding="utf-8")


def skill_name(skill_text: str) -> str:
    match = re.search(r"^name:\s*(.+)$", skill_text, re.MULTILINE)
    return match.group(1).strip() if match else ""


def skill_description(skill_text: str) -> str:
    match = re.search(r"^description:\s*(.+)$", skill_text, re.MULTILINE)
    return match.group(1).strip() if match else ""


def eval_metadata(skill_text: str, skill_dir_name: str) -> list[Check]:
    name = skill_name(skill_text)
    desc = skill_description(skill_text)
    return [
        Check("metadata:name-present", bool(name), name or "missing"),
        Check("metadata:name-suffix-x", name.endswith("x"), name),
        Check("metadata:name-matches-folder", name == skill_dir_name, f"{name} vs {skill_dir_name}"),
        Check("metadata:codex-in-description", "Codex" in desc, desc),
        Check("metadata:no-claude-branding", "Claude" not in skill_text, "Claude mentioned" if "Claude" in skill_text else "ok"),
    ]


def eval_prompts(skill_path: Path, mode: str) -> list[Check]:
    prompt_file = skill_path / "tests" / "test-prompts.md"
    text = prompt_file.read_text(encoding="utf-8")
    sections = parse_prompt_sections(text)
    for required in ["Trigger-Positive Prompts", "Trigger-Negative Prompts", "Adversarial Prompts"]:
        if required not in sections:
            return [Check(f"prompts:{required}", False, "missing section")]

    positives = sections["Trigger-Positive Prompts"]
    negatives = sections["Trigger-Negative Prompts"]
    adversarials = sections["Adversarial Prompts"]

    checks = [Check("prompts:positive-count", len(positives) >= 3, str(len(positives)))]
    checks.append(Check("prompts:negative-count", len(negatives) >= 3, str(len(negatives))))
    checks.append(Check("prompts:adversarial-count", len(adversarials) >= 3, str(len(adversarials))))
    if mode == "adversarial":
        checks.append(Check("prompts:pressure-wording", any("ignore" in p.lower() or "skip" in p.lower() for p in adversarials), "checked"))
    return checks


def eval_contract(skill_path: Path) -> list[Check]:
    contract_path = skill_path / "tests" / "contract.json"
    if not contract_path.is_file():
        return [Check("contract:file-present", False, "missing tests/contract.json")]
    try:
        data = json.loads(contract_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [Check("contract:json-valid", False, str(exc))]

    required_keys = ["skill", "purpose", "positive_triggers", "negative_triggers", "adversarial_triggers", "output_constraints"]
    checks = [Check(f"contract:key:{key}", key in data, "present" if key in data else "missing") for key in required_keys]
    if isinstance(data.get("positive_triggers"), list):
        checks.append(Check("contract:positive-count", len(data["positive_triggers"]) >= 3, str(len(data["positive_triggers"]))))
    else:
        checks.append(Check("contract:positive-count", False, "not a list"))
    if isinstance(data.get("negative_triggers"), list):
        checks.append(Check("contract:negative-count", len(data["negative_triggers"]) >= 3, str(len(data["negative_triggers"]))))
    else:
        checks.append(Check("contract:negative-count", False, "not a list"))
    if isinstance(data.get("adversarial_triggers"), list):
        checks.append(Check("contract:adversarial-count", len(data["adversarial_triggers"]) >= 3, str(len(data["adversarial_triggers"]))))
    else:
        checks.append(Check("contract:adversarial-count", False, "not a list"))
    if isinstance(data.get("output_constraints"), list):
        checks.append(Check("contract:output-constraints", len(data["output_constraints"]) >= 2, str(len(data["output_constraints"]))))
    else:
        checks.append(Check("contract:output-constraints", False, "not a list"))
    return checks


def eval_golden(skill_path: Path) -> list[Check]:
    golden_path = skill_path / "tests" / "golden.json"
    if not golden_path.is_file():
        return [Check("golden:file-present", False, "missing tests/golden.json")]
    try:
        data = json.loads(golden_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [Check("golden:json-valid", False, str(exc))]

    required_keys = ["scenario", "input", "expected_output_shape", "expected_elements", "not_expected"]
    checks = [Check(f"golden:key:{key}", key in data, "present" if key in data else "missing") for key in required_keys]
    if isinstance(data.get("expected_elements"), list):
        checks.append(Check("golden:expected-elements-count", len(data["expected_elements"]) >= 3, str(len(data["expected_elements"]))))
    else:
        checks.append(Check("golden:expected-elements-count", False, "not a list"))
    if isinstance(data.get("not_expected"), list):
        checks.append(Check("golden:not-expected-count", len(data["not_expected"]) >= 2, str(len(data["not_expected"]))))
    else:
        checks.append(Check("golden:not-expected-count", False, "not a list"))
    return checks


def main() -> int:
    parser = argparse.ArgumentParser(description="Evaluate a Codex skill package.")
    parser.add_argument("--skill-path", required=True)
    parser.add_argument("--mode", choices=["tests", "adversarial"], default="tests")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    skill_path = Path(args.skill_path).expanduser().resolve()
    skill_text = load_skill_text(skill_path)
    checks = []
    checks.extend(eval_metadata(skill_text, skill_path.name))
    checks.extend(eval_prompts(skill_path, args.mode))
    checks.extend(eval_contract(skill_path))
    checks.extend(eval_golden(skill_path))

    passed = all(c.passed for c in checks)
    report = {
        "skillPath": str(skill_path),
        "mode": args.mode,
        "status": "PASS" if passed else "FAIL",
        "checks": [c.__dict__ for c in checks],
    }
    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print(f"{report['status']}: {skill_path.name} [{args.mode}]")
        for check in checks:
            print(f" - {check.name}: {'PASS' if check.passed else 'FAIL'} ({check.detail})")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
