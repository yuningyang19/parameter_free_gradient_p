#!/usr/bin/env python3
"""Run deterministic closure, escape-hatch, coverage, and axiom audits."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ACCEPTED_AXIOMS = ["propext", "Classical.choice", "Quot.sound"]
AUDIT_FILE = ROOT / "V7" / "Proofs" / "Stage8Main" / "WholePaperAudit.lean"
SOURCE_SNAPSHOT = "f5094d1ab0cf53c2a56067604513a6bfbea26086"


def fail(message: str) -> None:
    print(f"CERTIFICATION: FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def strip_lean(text: str) -> str:
    """Replace nested comments, line comments, and strings while preserving lines."""
    out: list[str] = []
    i = 0
    block = 0
    line = False
    string = False
    while i < len(text):
        if line:
            if text[i] == "\n":
                line = False
                out.append("\n")
            else:
                out.append(" ")
            i += 1
        elif block:
            if text.startswith("/-", i):
                block += 1
                out.extend("  ")
                i += 2
            elif text.startswith("-/", i):
                block -= 1
                out.extend("  ")
                i += 2
            else:
                out.append("\n" if text[i] == "\n" else " ")
                i += 1
        elif string:
            if text[i] == "\\" and i + 1 < len(text):
                out.extend("  ")
                i += 2
            elif text[i] == '"':
                string = False
                out.append(" ")
                i += 1
            else:
                out.append("\n" if text[i] == "\n" else " ")
                i += 1
        elif text.startswith("--", i):
            line = True
            out.extend("  ")
            i += 2
        elif text.startswith("/-", i):
            block = 1
            out.extend("  ")
            i += 2
        elif text[i] == '"':
            string = True
            out.append(" ")
            i += 1
        else:
            out.append(text[i])
            i += 1
    if block or string:
        fail("unterminated Lean block comment or string")
    return "".join(out)


def module_for(path: Path) -> str:
    relative = path.relative_to(ROOT).with_suffix("")
    return ".".join(relative.parts)


def local_imports(path: Path, modules: set[str]) -> list[str]:
    clean = strip_lean(path.read_text(encoding="utf-8"))
    imports: list[str] = []
    for line in clean.splitlines():
        match = re.match(r"^\s*import\s+(.+?)\s*$", line)
        if match:
            imports.extend(token for token in match.group(1).split() if token in modules)
    return imports


def proof_hole_scan(paths: list[Path]) -> None:
    patterns = ["sorry", "admit", "axiom", "unsafe", "native_decide"]
    hits: list[str] = []
    for path in paths:
        clean = strip_lean(path.read_text(encoding="utf-8"))
        for token in patterns:
            regex = re.compile(rf"(?<![A-Za-z0-9_]){re.escape(token)}(?![A-Za-z0-9_])")
            for match in regex.finditer(clean):
                line = clean.count("\n", 0, match.start()) + 1
                hits.append(f"{path.relative_to(ROOT)}:{line}:{token}")
    if hits:
        fail("escape hatch found: " + ", ".join(hits[:20]))


def main() -> None:
    subprocess.run([sys.executable, str(ROOT / "scripts" / "verify_source_identity.py")], check=True)

    extraction = json.loads((ROOT / "audit" / "EXTRACTION_MANIFEST.json").read_text())
    closure = json.loads((ROOT / "audit" / "DEPENDENCY_CLOSURE.json").read_text())
    certification = json.loads((ROOT / "audit" / "CERTIFICATION_MANIFEST.json").read_text())
    paths = [ROOT / row["target_path"] for row in extraction["files"]]
    modules = {row["module"] for row in extraction["files"]}

    recomputed = {module_for(path): local_imports(path, modules) for path in paths}
    if recomputed != closure["local_import_edges"]:
        fail("recomputed local import edges differ from the frozen closure manifest")

    reached: set[str] = set()
    stack = list(closure["proof_roots"])
    while stack:
        module = stack.pop()
        if module in reached:
            continue
        if module not in recomputed:
            fail(f"closure root/import absent from package: {module}")
        reached.add(module)
        stack.extend(recomputed[module])
    # `V7.lean` is the convenience public aggregation root.  The eleven audit
    # roots reach all 189 load-bearing statement/proof modules; adding this
    # public root yields the exact 190-file packaged surface.
    if modules - reached != {"V7"} or reached | {"V7"} != modules:
        fail(f"transitive closure mismatch: reached={len(reached)}, manifest={len(modules)}")

    categories = {row["module"]: row["category"] for row in extraction["files"]}
    proof_count = sum(
        categories[module] in {"V7_CURRENT_PROOF", "AUDIT_ENTRY_POINT"}
        for module in modules
    )
    if proof_count != 144 or closure["v7_statement_and_root_module_count"] != 13:
        fail("V7 proof/statement counts differ from 144/13")
    if closure["o3_load_bearing_module_count"] != 33:
        fail("O3 load-bearing count differs from 33")

    sentinel_hits: set[str] = set()
    for row in closure["negative_sentinels"]:
        sentinel_hits.update(set(row["forbidden_modules"]) & reached)
    if sentinel_hits or len(closure["negative_sentinels"]) != 9:
        fail(f"negative sentinel closure contamination: {sorted(sentinel_hits)}")

    proof_hole_scan(paths)

    if (ROOT / "lean-toolchain").read_text().strip() != "leanprover/lean4:v4.33.0":
        fail("Lean toolchain pin differs")
    lake_manifest = json.loads((ROOT / "lake-manifest.json").read_text())
    mathlib = [row for row in lake_manifest["packages"] if row["name"] == "mathlib"]
    if len(mathlib) != 1 or mathlib[0]["rev"] != "db584cd6d46c92f209a44c0f1c829460d327499d":
        fail("Mathlib revision differs")

    rows = [
        line for line in (ROOT / "audit" / "INTERFACE_COVERAGE.md").read_text().splitlines()
        if re.match(r"^\| (?:U|B|E|A|L|G)\d{2} \|", line)
    ]
    if len(rows) != 63 or any("| PASS |" not in row for row in rows):
        fail("the theorem-strength interface ledger is not 63/63 PASS")

    audit_source = AUDIT_FILE.read_text(encoding="utf-8").splitlines()
    check_names = [line.strip().split(maxsplit=1)[1] for line in audit_source if line.strip().startswith("#check ")]
    axiom_names = [line.strip().split(maxsplit=2)[2] for line in audit_source if line.strip().startswith("#print axioms ")]
    expected_names = certification["certified_exports"]
    if check_names != expected_names or axiom_names != expected_names or len(expected_names) != 22:
        fail("whole-paper audit entry point does not enumerate the exact 22 exports")

    completed = subprocess.run(
        ["lake", "env", "lean", str(AUDIT_FILE.relative_to(ROOT))],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    output = completed.stdout + completed.stderr
    if completed.returncode:
        print(output, file=sys.stderr)
        fail("whole-paper Lean audit failed to elaborate")
    reported = {
        name: [part.strip() for part in body.split(",") if part.strip()]
        for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", output)
    }
    if set(reported) != set(expected_names):
        fail(f"axiom output names differ: got {len(reported)}/22")
    extra = [name for name in expected_names if reported[name] != ACCEPTED_AXIOMS]
    if extra:
        fail(f"extra/different axioms in exports: {extra}")

    diff = subprocess.run(
        ["git", "diff", "--quiet", SOURCE_SNAPSHOT, "HEAD", "--", "O3", "V7", "V7.lean"],
        cwd=ROOT,
    )
    if diff.returncode:
        fail("mathematical Lean bytes changed after Commit A")

    print("CURRENT_PROOF_MODULES: PASS (144 V7 proof modules; 190 local modules total)")
    print("NAMED_RESULTS: 22/22")
    print("THEOREM_STRENGTH_INTERFACES: 63/63")
    print("EXTRA_AXIOMS: 0/22")
    print("NEGATIVE_SENTINELS_IN_CURRENT_CLOSURE: 0/9")
    print("PROOF_HOLE_SCAN: PASS")
    print("MATHEMATICAL_LEAN_BYTES_CHANGED_DURING_PACKAGING: NO")
    print("CERTIFICATION: PASS")


if __name__ == "__main__":
    main()
