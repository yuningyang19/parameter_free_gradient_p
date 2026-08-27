#!/usr/bin/env python3
"""Verify the certified Lean snapshot against its extraction manifest."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "audit" / "EXTRACTION_MANIFEST.json"
PACKAGING_LEAN_FILES = {
    "Challenge.lean",
    "Solution.lean",
    "palomar/AxiomAudit.lean",
}


def fail(message: str) -> None:
    print(f"SOURCE_IDENTITY: FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    rows = data["files"]
    expected = {row["target_path"] for row in rows}
    actual = {
        path.relative_to(ROOT).as_posix()
        for path in ROOT.rglob("*.lean")
        if ".lake" not in path.parts and path.name != "lakefile.lean"
    }
    if actual != expected | PACKAGING_LEAN_FILES:
        fail(
            "Lean file set differs from the certified snapshot plus the exact "
            f"packaging allowlist: missing={sorted(expected-actual)}, "
            f"extra={sorted(actual-(expected | PACKAGING_LEAN_FILES))}"
        )

    for row in rows:
        path = ROOT / row["target_path"]
        digest = sha256(path)
        if digest != row["source_sha256"] or digest != row["target_sha256"]:
            fail(f"SHA-256 mismatch: {row['target_path']}")
        blob = subprocess.check_output(
            ["git", "hash-object", str(path)], cwd=ROOT, text=True
        ).strip()
        if blob != row["source_git_blob_sha"]:
            fail(f"Git blob mismatch: {row['target_path']}")
        if row.get("byte_identity") is not True:
            fail(f"manifest does not assert byte identity: {row['target_path']}")

    if len(rows) != 190 or data.get("all_byte_identical") is not True:
        fail("manifest count or aggregate byte-identity assertion differs")
    print("SOURCE_IDENTITY_TO_EB1B55: PASS (190/190 Lean files)")


if __name__ == "__main__":
    main()
