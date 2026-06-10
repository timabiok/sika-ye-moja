#!/usr/bin/env python3
"""Replace personal names with role labels in stabilization-pack source docs."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "deliverables/stabilization-pack/manifest.json"

# Order: longest / most specific phrases first, then single names (word boundaries).
PHRASE_REPLACEMENTS: list[tuple[str, str]] = [
    (r"Patrick / platform", "Client platform"),
    (r"Patrick / Anatoliy", "Client platform / Client dev lead"),
    (r"Patrick network", "Network team"),
    (r"Patrick team", "Network team"),
    (r"Anatoliy's team", "App team"),
    (r"Anatoliy team", "App team"),
    (r"Patrick/Kirk", "Client platform / Client security"),
    (r"Tim \+ client network", "Consultant + client network"),
    (r"Client \(Patrick\)", "Client platform"),
    (r"Client \(Anatoliy\)", "Client dev lead"),
    (r"Patrick—", "Client platform—"),
    (r"Patrick-owned", "Client platform-owned"),
    (r"Patrick stack", "Client platform stack"),
    (r"Vaco lead", "Consultant lead"),
    (r"Vaco consultant", "Consultant"),
    (r"Vaco draft", "Consultant draft"),
    (r"Vaco SOW", "Consultant SOW"),
    (r"for Tim", "for consultant"),
    (r"Tim has", "Consultant has"),
    (r"with Anatoliy", "with client dev lead"),
    (r"loop in Patrick", "loop in client platform"),
    (r"Anatoliy agrees", "Client dev lead agrees"),
    (r"Anatoliy offered", "Client dev lead offered"),
    (r"weekly with Anatoliy \+ Patrick", "weekly with client dev lead + client platform"),
    (r"PM \+ Kirk \+ Platform", "PM + Client security + Client platform"),
    (r"break-glass; Kirk", "break-glass; Client security"),
    (r"Approver\*\* \| _\[Anatoliy / platform\]_", "Approver** | _[Client dev lead / platform]_"),
    (r"\(Anatoliy\)", "(Client dev lead)"),
    (r"\(Patrick\)", "(Client platform)"),
    (r"\(Kirk\)", "(Client security)"),
    (r"\(Tim\)", "(Consultant)"),
]

NAME_REPLACEMENTS: list[tuple[str, str]] = [
    (r"Anatoliy", "Client dev lead"),
    (r"Patrick", "Client platform"),
    (r"Kirk", "Client security"),
    (r"Letron", "Client PM"),
    (r"Vaco", "Consultant"),
    (r"Tim", "Consultant"),
]


def anonymize(text: str) -> str:
    for pattern, replacement in PHRASE_REPLACEMENTS:
        text = re.sub(pattern, replacement, text)
    for pattern, replacement in NAME_REPLACEMENTS:
        text = re.sub(rf"\b{pattern}\b", replacement, text)
    # Titles / headings
    text = re.sub(
        r"# Clarifications with dev / platform team \(Client dev lead\)",
        "# Clarifications with dev / platform team",
        text,
    )
    text = re.sub(
        r"## 6\. Access for consultant \(Consultant\)",
        "## 6. Consultant access",
        text,
    )
    text = re.sub(
        r"\*\*Parties:\*\* Client PM \+ Consultant consultant",
        "**Parties:** Client PM + Consultant",
        text,
    )
    text = re.sub(r"Consultant consultant", "Consultant", text)
    text = re.sub(r"Client dev lead / Client dev lead", "Client dev lead", text)
    text = re.sub(r"Client platform/platform", "client platform", text)
    text = re.sub(r"Client platform \(Client platform\)", "Client platform", text)
    text = re.sub(r"Consultant \(Consultant\)", "Consultant", text)
    return text


def main() -> int:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    sources = sorted({item["source"] for item in manifest["deliverables"]})
    changed = 0

    for rel in sources:
        path = ROOT / rel
        if not path.exists():
            print(f"skip missing: {rel}", file=sys.stderr)
            continue
        original = path.read_text(encoding="utf-8")
        updated = anonymize(original)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            print(f"updated {rel}")
            changed += 1
        else:
            print(f"unchanged {rel}")

    print(f"Done. {changed} file(s) updated.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
