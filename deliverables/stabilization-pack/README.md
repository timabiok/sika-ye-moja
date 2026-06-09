# Stabilization pack (client deliverables)

Client-facing PDFs built from `docs/*.md` sources. Markdown in `docs/` remains the **source of truth**; PDFs are regenerated when drafts change.

## Build

**Requirements:** [pandoc](https://pandoc.org) and Google Chrome (or Chromium). On macOS, Chrome is usually already installed.

```bash
# Build all PDFs for the current pack version
./scripts/build-deliverable-pdfs.sh

# Clean rebuild
./scripts/build-deliverable-pdfs.sh --clean

# List mapped sources → outputs
./scripts/build-deliverable-pdfs.sh --list

# Generate a local review email draft (links → source docs on GitHub)
python3 scripts/generate-review-email.py
# → .deliverables-build/review-email.md (gitignored; copy into your mail client)
```

PDFs are written to `deliverables/stabilization-pack/v0.1/` per [`manifest.json`](manifest.json).

Intermediate HTML and review email drafts live in `.deliverables-build/` (gitignored).

## Pack layout (`v0.1`)

| Folder | Contents |
|--------|----------|
| `program/` | Strategy, gap list, backlog, risk register, KT plan |
| `standards/` | RHEL/Podman, banking, network/IAM, registry, egress, VM design, ingress, dev CLI |
| `operations/` | Podman session pre-read (clarifications) |
| `runbooks/` | Promotion and operations |
| `network/` | Discovery questionnaire, network cutover template |
| `grc/` | Compliance mapping (informational) |

## Client review email

Run `python3 scripts/generate-review-email.py` to write `.deliverables-build/review-email.md`. The table links to each **source document** on GitHub (`docs/*.md`). Do not commit the generated email.

## Adding or renaming a deliverable

1. Add or update the markdown source under `docs/`.
2. Add an entry to [`manifest.json`](manifest.json) (`source`, `output`, `title`, `section`).
3. Run `./scripts/build-deliverable-pdfs.sh --clean`.
4. Run `python3 scripts/generate-review-email.py`.
