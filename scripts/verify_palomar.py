#!/usr/bin/env python3
"""Verify the narrow three-result Palomar-facing package."""

from __future__ import annotations

import json
import hashlib
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHALLENGE = ROOT / "Challenge.lean"
SOLUTION = ROOT / "Solution.lean"
CONFIG = ROOT / "comparator.json"
METADATA = ROOT / "formalization.yaml"
LICENSE = ROOT / "LICENSE"
METADATA_VALIDATOR = ROOT / "scripts" / "validate-formalization.rb"
AUDIT = ROOT / "palomar" / "AxiomAudit.lean"
PUBLIC_AUDIT = ROOT / "palomar" / "PUBLIC_SURFACE_AUDIT.md"
THEOREMS = [
    "V7.scaleIdentificationImpossibility",
    "V7.knownParameterAboveTwoOptimality",
    "V7.main",
]
SOLUTION_IMPORTS = [
    "V7.Proofs.Stage5AboveTwoLowerS5F.Closure",
    "V7.Proofs.Stage7StrictRandomizedExpected.Closure",
    "V7.Proofs.Stage8Main.Closure",
]
ACCEPTED_AXIOMS = ["propext", "Classical.choice", "Quot.sound"]
LICENSE_SHA256 = "b40930bbcf80744c86c46a12bc9da056641d722716c378f5659b9e555ef833e1"
MAIN_RESULT_FILES = [
    "V7/Proofs/Stage7StrictRandomizedExpected/Closure.lean",
    "V7/Proofs/Stage5AboveTwoLowerS5F/Optimality.lean",
    "V7/Proofs/Stage8Main/Main.lean",
]


def fail(message: str) -> None:
    print(f"PALOMAR_AUDIT: FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def strip_lean(text: str) -> str:
    """Blank nested comments, line comments, and strings while preserving lines."""
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


def run_lean(path: Path) -> str:
    completed = subprocess.run(
        ["lake", "env", "lean", str(path.relative_to(ROOT))],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    output = completed.stdout + completed.stderr
    if completed.returncode:
        print(output, file=sys.stderr)
        fail(f"Lean elaboration failed for {path.relative_to(ROOT)}")
    return output


def load_metadata() -> dict[str, object]:
    validation = subprocess.run(
        ["ruby", str(METADATA_VALIDATOR.relative_to(ROOT)), str(METADATA.relative_to(ROOT))],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    if validation.returncode:
        print(validation.stdout + validation.stderr, file=sys.stderr)
        fail("formalization.yaml validation failed")

    conversion = subprocess.run(
        [
            "ruby",
            "-rjson",
            "-ryaml",
            "-e",
            (
                "doc = YAML.safe_load(File.read(ARGV.fetch(0)), "
                "permitted_classes: [], permitted_symbols: [], aliases: false); "
                "STDOUT.write(JSON.generate(doc))"
            ),
            str(METADATA.relative_to(ROOT)),
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    if conversion.returncode:
        print(conversion.stdout + conversion.stderr, file=sys.stderr)
        fail("could not convert formalization.yaml to JSON for the package audit")
    document = json.loads(conversion.stdout)
    if not isinstance(document, dict):
        fail("formalization.yaml is not a top-level mapping")
    return document


def imports(clean: str) -> list[str]:
    result: list[str] = []
    for line in clean.splitlines():
        match = re.match(r"^\s*import\s+(.+?)\s*$", line)
        if match:
            result.extend(match.group(1).split())
    return result


def token_hits(clean: str, token: str) -> list[int]:
    pattern = re.compile(rf"(?<![A-Za-z0-9_]){re.escape(token)}(?![A-Za-z0-9_])")
    return [clean.count("\n", 0, hit.start()) + 1 for hit in pattern.finditer(clean)]


def main() -> None:
    metadata = load_metadata()
    if "repository" in metadata:
        fail("ordinary substantive repository must omit the thin-wrapper repository mapping")
    project = metadata.get("project", {})
    if not isinstance(project, dict):
        fail("formalization.yaml project section is invalid")
    if project.get("license") != "Apache-2.0":
        fail("formalization.yaml root license is not Apache-2.0")
    if project.get("authors") != ["Yuning Yang"] or project.get("responsible_maintainers") != ["Yuning Yang"]:
        fail("formalization authors or responsible maintainers differ from the release decision")
    classification = metadata.get("classification", {})
    if classification != {"arxiv": ["math.OC"], "msc2020": ["90C25"]}:
        fail("formalization subject classifications differ from the audited codes")
    sources = metadata.get("sources", [])
    if not isinstance(sources, list) or len(sources) != 1 or sources[0].get("relationship") != "formalizes":
        fail("formalization source provenance is not the single source-based manuscript binding")
    status = metadata.get("status", {})
    if not isinstance(status, dict):
        fail("formalization status section is invalid")
    if status.get("sorry_count") != 0 or status.get("sorry_in_definitions") != 0:
        fail("proof-development sorry counts are not zero")
    if status.get("axioms") != ACCEPTED_AXIOMS:
        fail("formalization axiom list differs from the certified set")
    main_results = status.get("main_results", [])
    if [result.get("declaration") for result in main_results] != THEOREMS:
        fail("formalization main results differ from the frozen public surface")
    if [result.get("file") for result in main_results] != MAIN_RESULT_FILES:
        fail("formalization main-result file bindings differ from the audited proof files")
    if any(result.get("comparator_config") != "comparator.json" for result in main_results):
        fail("formalization main result is not bound to root comparator.json")
    alignments = metadata.get("alignment", {}).get("statements", [])
    if [row.get("lean") for row in alignments] != THEOREMS:
        fail("formalization alignment table differs from the frozen public surface")

    conventional_licenses = [
        path.name
        for path in ROOT.iterdir()
        if path.is_file()
        and re.fullmatch(r"(?i)(LICENSE|LICENCE|COPYING|UNLICENSE|OFL)(\.(md|markdown|txt))?", path.name)
    ]
    if conventional_licenses != ["LICENSE"]:
        fail(f"expected exactly root LICENSE, found {conventional_licenses}")
    if hashlib.sha256(LICENSE.read_bytes()).hexdigest() != LICENSE_SHA256:
        fail("root LICENSE is not the authorized canonical Apache-2.0 text")

    config = json.loads(CONFIG.read_text(encoding="utf-8"))
    if config.get("challenge_module") != "Challenge" or config.get("solution_module") != "Solution":
        fail("comparator module names differ from Challenge/Solution")
    if config.get("theorem_names") != THEOREMS or config.get("definition_names") != []:
        fail("public comparator surface is not exactly the frozen three theorems")
    if set(config.get("permitted_axioms", [])) != set(ACCEPTED_AXIOMS):
        fail("comparator permitted axioms differ from the certified set")

    challenge_bytes = CHALLENGE.read_bytes()
    challenge_text = challenge_bytes.decode("utf-8")
    challenge_clean = strip_lean(challenge_text)
    if len(challenge_bytes) > 100 * 1024 or len(challenge_text.splitlines()) > 1000:
        fail("Challenge.lean exceeds the Palomar hard size limit")
    public_audit = PUBLIC_AUDIT.read_text(encoding="utf-8")
    if len(challenge_text.splitlines()) > 300 and "300-line warning threshold" not in public_audit:
        fail("Challenge line-count warning is not documented in the public audit")
    if imports(challenge_clean) != ["Mathlib"]:
        fail("Challenge.lean must import exactly Mathlib and no local proof module")

    expected_short = [name.rsplit(".", 1)[1] for name in THEOREMS]
    declared = re.findall(r"^\s*theorem\s+([A-Za-z0-9_']+)\s*:", challenge_clean, re.MULTILINE)
    if declared != expected_short:
        fail(f"Challenge theorem declarations differ: {declared}")
    if len(token_hits(challenge_clean, "sorry")) != 3:
        fail("Challenge.lean must contain exactly the three expected theorem placeholders")
    for token in ["admit", "axiom", "unsafe", "native_decide"]:
        if token_hits(challenge_clean, token):
            fail(f"Challenge.lean contains forbidden token {token}")

    solution_clean = strip_lean(SOLUTION.read_text(encoding="utf-8"))
    if imports(solution_clean) != SOLUTION_IMPORTS:
        fail("Solution.lean imports differ from the three frozen proof closures")
    for token in ["sorry", "admit", "axiom", "unsafe", "native_decide"]:
        if token_hits(solution_clean, token):
            fail(f"Solution.lean contains forbidden token {token}")
    checks = re.findall(r"^\s*#check\s+([^\s]+)\s*$", solution_clean, re.MULTILINE)
    if checks != THEOREMS:
        fail("Solution.lean does not check exactly the frozen three exports")

    challenge_output = run_lean(CHALLENGE)
    sorry_warnings = re.findall(r"warning: declaration uses [`']sorry['`]", challenge_output)
    if len(sorry_warnings) != 3:
        fail("Challenge elaboration did not report exactly three expected sorry warnings")
    run_lean(SOLUTION)
    axiom_output = run_lean(AUDIT)
    reported = {
        name: [part.strip() for part in body.split(",") if part.strip()]
        for name, body in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", axiom_output)
    }
    if list(reported) != THEOREMS:
        fail("axiom audit did not report exactly the three public exports")
    if any(reported[name] != ACCEPTED_AXIOMS for name in THEOREMS):
        fail("one or more public exports has an unexpected axiom dependency")

    print("PALOMAR_PUBLIC_SURFACE_GATE: PASS")
    print("FORMALIZATION_YAML: PASS (v0.4)")
    print("ROOT_LICENSE: Apache-2.0")
    print("PUBLIC_HEADLINE_RESULTS: 3")
    print("CHALLENGE_IMPORTS: Mathlib only")
    print(f"CHALLENGE_SIZE: {len(challenge_text.splitlines())} lines; {len(challenge_bytes)} bytes")
    print("CHALLENGE_PLACEHOLDERS: 3/3 expected")
    print("CHALLENGE_LEAKAGE_AUDIT: PASS")
    print("SOLUTION_BUILD: PASS")
    print("PUBLIC_EXPORT_AXIOM_AUDIT: PASS")


if __name__ == "__main__":
    main()
