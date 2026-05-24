#!/usr/bin/env python3
from pathlib import Path
import subprocess
import sys


def main() -> int:
    script = Path(__file__).resolve().parents[3] / "scripts" / "skill-eval.py"
    result = subprocess.run([sys.executable, str(script), "--skill-path", str(Path(__file__).resolve().parent.parent), "--mode", "tests"], check=False)
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
