#!/usr/bin/env python3
"""Generate a local client review email draft (not committed — see .gitignore)."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "deliverables/stabilization-pack/manifest.json"
DEFAULT_OUTPUT = ROOT / ".deliverables-build/review-email.md"


def github_blob_link(repo: str, branch: str, path: str) -> str:
    return f"https://github.com/{repo}/blob/{branch}/{path}"


def build_email(manifest: dict) -> str:
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
        source = item["source"]
        link = github_blob_link(repo, branch, source)
        label = Path(source).name
        lines.append(f"| {item['section']} | {item['title']} | [{label}]({link}) |")

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
        ]
    )

    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate local review email draft with GitHub doc links.")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT,
        help=f"Output path (default: {DEFAULT_OUTPUT.relative_to(ROOT)})",
    )
    parser.add_argument(
        "--stdout",
        action="store_true",
        help="Print to stdout instead of writing a file",
    )
    args = parser.parse_args()

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    content = build_email(manifest)

    if args.stdout:
        sys.stdout.write(content)
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(content, encoding="utf-8")
    print(f"Wrote {args.output.relative_to(ROOT)} (local only — not committed)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
