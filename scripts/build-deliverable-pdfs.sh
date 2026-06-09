#!/usr/bin/env bash
# Build client-facing PDFs for the stabilization pack from docs/*.md sources.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${ROOT}/deliverables/stabilization-pack/manifest.json"
CSS="${ROOT}/deliverables/stabilization-pack/assets/pdf.css"
BUILD_DIR="${ROOT}/.deliverables-build"

usage() {
  cat <<'EOF'
Usage: scripts/build-deliverable-pdfs.sh [options]

Build PDF deliverables listed in deliverables/stabilization-pack/manifest.json.

Options:
  --clean     Remove intermediate HTML and rebuild all PDFs
  --list      Print manifest entries and exit
  -h, --help  Show this help

Requirements:
  - pandoc (https://pandoc.org)
  - Google Chrome, Chromium, or CHROME_BIN pointing at a headless-capable browser

Environment:
  CHROME_BIN   Override browser executable for HTML → PDF
EOF
}

find_chrome() {
  if [[ -n "${CHROME_BIN:-}" && -x "${CHROME_BIN}" ]]; then
    echo "${CHROME_BIN}"
    return 0
  fi

  local candidate
  for candidate in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/usr/bin/google-chrome" \
    "/usr/bin/google-chrome-stable" \
    "/usr/bin/chromium" \
    "/usr/bin/chromium-browser"; do
    if [[ -x "${candidate}" ]]; then
      echo "${candidate}"
      return 0
    fi
  done

  return 1
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

html_to_pdf() {
  local html="$1"
  local pdf="$2"
  local chrome="$3"
  local abs_html abs_pdf

  abs_html="$(cd "$(dirname "${html}")" && pwd)/$(basename "${html}")"
  abs_pdf="$(cd "$(dirname "${pdf}")" && pwd)/$(basename "${pdf}")"

  "${chrome}" \
    --headless=new \
    --disable-gpu \
    --no-sandbox \
    --disable-dev-shm-usage \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf="${abs_pdf}" \
    "file://${abs_html}" \
    >/dev/null 2>&1
}

build_one() {
  local source="$1"
  local output="$2"
  local title="$3"
  local chrome="$4"
  local src_path out_path html_path

  src_path="${ROOT}/${source}"
  out_path="${ROOT}/${output}"
  html_path="${BUILD_DIR}/$(basename "${output}" .pdf).html"

  if [[ ! -f "${src_path}" ]]; then
    echo "error: missing source: ${source}" >&2
    return 1
  fi

  mkdir -p "$(dirname "${out_path}")" "${BUILD_DIR}"

  pandoc "${src_path}" \
    --from=gfm \
    --to=html5 \
    --standalone \
    --metadata "title=${title}" \
    --css "${CSS}" \
    --resource-path="${ROOT}/docs:${ROOT}" \
    -o "${html_path}"

  html_to_pdf "${html_path}" "${out_path}" "${chrome}"
  echo "  ✓ ${output}"
}

list_manifest() {
  python3 - "${MANIFEST}" <<'PY'
import json, sys
manifest = json.load(open(sys.argv[1]))
for item in manifest["deliverables"]:
    print(f"{item['section']}\t{item['output']}\t<- {item['source']}")
PY
}

main() {
  local clean=0
  local chrome pack_version

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --clean) clean=1; shift ;;
      --list) list_manifest; exit 0 ;;
      -h|--help) usage; exit 0 ;;
      *) echo "error: unknown option: $1" >&2; usage; exit 1 ;;
    esac
  done

  require_cmd pandoc
  require_cmd python3

  if ! chrome="$(find_chrome)"; then
    echo "error: Chrome/Chromium not found. Set CHROME_BIN or install Google Chrome." >&2
    exit 1
  fi

  if [[ ! -f "${MANIFEST}" ]]; then
    echo "error: manifest not found: ${MANIFEST}" >&2
    exit 1
  fi

  pack_version="$(python3 -c "import json; print(json.load(open('${MANIFEST}'))['version'])")"

  if [[ "${clean}" -eq 1 ]]; then
    rm -rf "${BUILD_DIR}"
    find "${ROOT}/deliverables/stabilization-pack/${pack_version}" -name '*.pdf' -delete 2>/dev/null || true
  fi

  echo "Building stabilization pack ${pack_version} PDFs..."
  echo "Browser: ${chrome}"

  while IFS=$'\x1e' read -r source output title; do
    build_one "${source}" "${output}" "${title}" "${chrome}"
  done < <(
    python3 - "${MANIFEST}" <<'PY'
import json, sys
record_sep = "\x1e"
manifest = json.load(open(sys.argv[1]))
for item in manifest["deliverables"]:
    print(record_sep.join([item["source"], item["output"], item["title"]]))
PY
  )

  echo "Done. PDFs written under deliverables/stabilization-pack/${pack_version}/"
}

main "$@"
