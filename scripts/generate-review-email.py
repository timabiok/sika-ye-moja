#!/usr/bin/env python3
"""Generate the client review email from deliverables/stabilization-pack/manifest.json."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "deliverables/stabilization-pack/manifest.json"
OUTPUT = ROOT / "deliverables/stabilization-pack/v0.1/REVIEW-EMAIL.md"


def github_blob_link(repo: str, branch: str, output_path: str) -> str:
    return f"https://github.com/{repo}/blob/{branch}/{output_path}"


def main() -> int:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    repo = manifest.get("repo", "{org}/{repo}")
    branch = manifest.get("branch", "main")
    version = manifest["version"]

    lines: list[str] = [
        f"# Draft RHEL + Podman Standards Pack — Review ({version})",
        "",
        "**Subject:** Draft RHEL + Podman Standards Pack — Review",
        "",
        "Hi all,",
        "",
        "Following Workshop 2 and the architecture diagram review, I'm sharing our draft stabilization and standards pack for review.",
        "These materials align with the engagement scope (planning, standards, risks, environment recommendations, and knowledge transfer).",
        "They are working drafts for discussion and will be finalized after platform review and closure of the open items identified during the assessment phase.",
        "",
        "## Materials for Review",
        "",
        "| Section | Item (email) | Link |",
        "|---------|--------------|------|",
    ]

    for item in manifest["deliverables"]:
        link = github_blob_link(repo, branch, item["output"])
        lines.append(f"| {item['section']} | {item['title']} | [{Path(item['output']).name}]({link}) |")

    lines.extend(
        [
            "",
            "## Opinionated Defaults (Please Confirm)",
            "",
            "Unless advised otherwise, the following assumptions are in place:",
            "",
            "- ACR Premium (in place before UAT)",
            "- CIS RHEL 9 Level 1 baseline (not STIG unless mandated)",
            "- Separate runner and runtime VMs per environment",
            "- nginx sidecar for ingress (until APIM is introduced)",
            "- Entra ID–based SSH access (retiring shared Linux admin accounts)",
            "- P0 security findings remediated in dev prior to UAT promotion",
            "",
            "All defaults are documented in the standards pack with decision IDs for formal sign-off.",
            "",
            "## Next Deliverables (Post-Review)",
            "",
            "Following the ongoing sessions and inputs:",
            "",
            "- Completed dev Podman assessment",
            "- Terraform tfvars bridge (subnet / ACR / Key Vault IDs)",
            "- Reference IaC walkthrough (KT Session 1)",
            "",
            "## Out of Scope (Unchanged)",
            "",
            "- Application remediation",
            "- Firewall implementation",
            "- Terraform execution within your tenant",
            "- Penetration testing",
            "- APIM delivery",
            "- RHEL licensing",
            "",
            "(Available separately if needed.)",
            "",
            "---",
            "",
            f"_Generated from `{MANIFEST.relative_to(ROOT)}`. Re-run: `python3 scripts/generate-review-email.py`_",
            "",
        ]
    )

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUTPUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
