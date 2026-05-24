#!/usr/bin/env python3
from pathlib import Path


def main() -> int:
    test_prompts = Path(__file__).resolve().parent / "test-prompts.md"
    if not test_prompts.is_file():
        raise SystemExit(f"Missing test prompts file: {test_prompts}")

    content = test_prompts.read_text(encoding="utf-8")
    required_phrases = [
        "Review these three approaches",
        "Split the problem into a small panel of agents",
        "Just implement this directly",
    ]

    for phrase in required_phrases:
        if phrase not in content:
            raise SystemExit(f"Missing expected test prompt phrase: {phrase}")

    print("agent-panel test prompts present.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
