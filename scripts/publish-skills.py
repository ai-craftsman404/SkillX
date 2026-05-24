#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
from datetime import datetime
from pathlib import Path


def is_skill_dir(path: Path) -> bool:
    return path.is_dir() and (path / "SKILL.md").is_file()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Publish Codex skills.")
    parser.add_argument("--source-root", default=str(Path(__file__).resolve().parent.parent / "skills"))
    parser.add_argument("--target-root", default="")
    parser.add_argument("--log-path", default=str(Path(__file__).resolve().parent.parent / "publish-log.csv"))
    parser.add_argument("--what-if", action="store_true")
    args = parser.parse_args()

    source_root = Path(args.source_root).expanduser().resolve()
    if not source_root.is_dir():
        raise SystemExit(f"Skills source folder not found: {source_root}")

    if not args.target_root.strip():
        codex_home = os.environ.get("CODEX_HOME", "").strip()
        if codex_home:
            target_root = Path(codex_home) / "skills"
        else:
            target_root = Path.home() / ".codex" / "skills"
    else:
        target_root = Path(args.target_root).expanduser()
    target_root = target_root.resolve()
    target_root.mkdir(parents=True, exist_ok=True)

    log_path = Path(args.log_path).expanduser().resolve()
    log_path.parent.mkdir(parents=True, exist_ok=True)
    if not log_path.exists() and not args.what_if:
        write_text(log_path, "timestamp,skill,version,status\n")

    skill_dirs = [p for p in source_root.iterdir() if is_skill_dir(p)]
    if not skill_dirs:
        print(f"No skill folders found in {source_root} (expected SKILL.md in each folder).")
        return 0

    print(f"Publishing {len(skill_dirs)} skill(s) to {target_root}")

    for skill_dir in skill_dirs:
        quality_gate = Path(__file__).resolve().parent / "quality-gate.py"
        if not quality_gate.is_file():
            raise SystemExit(f"Missing quality gate script: {quality_gate}")

        print(f" - {skill_dir.name} [quality gate]")
        cmd = ["python", str(quality_gate), "--skill-path", str(skill_dir)]
        if args.what_if:
            cmd.append("--what-if")
        result = subprocess.run(cmd, check=False)
        if result.returncode != 0:
            raise SystemExit(f"Quality gate failed for skill '{skill_dir.name}'")

        version = read_text(skill_dir / "VERSION").strip()
        destination = target_root / skill_dir.name
        backup_path = Path(f"{destination}__prev")
        print(f" - {skill_dir.name} v{version}")

        if destination.is_dir() and not args.what_if:
            if backup_path.is_dir():
                shutil.rmtree(backup_path)
            shutil.copytree(destination, backup_path)

        if not args.what_if:
            if destination.is_dir():
                shutil.rmtree(destination)
            destination.mkdir(parents=True, exist_ok=True)
            for item in skill_dir.iterdir():
                dest = destination / item.name
                if item.is_dir():
                    shutil.copytree(item, dest)
                else:
                    shutil.copy2(item, dest)
            with log_path.open("a", encoding="utf-8", newline="") as f:
                f.write(f"{datetime.now().isoformat(timespec='seconds')},{skill_dir.name},{version},published\n")
        else:
            print(f"What if: would copy {skill_dir} -> {destination}")

    if args.what_if:
        print("Dry run complete. No files were changed.")
    else:
        print(f"Publish complete. Log: {log_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
