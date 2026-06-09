#!/usr/bin/env bash
# Move compressed rotated logs into long-term archive and prune by retention.
# Invoked by bank-log-archive.service (systemd timer).

set -euo pipefail

LOG_ARCHIVE_DIR="${LOG_ARCHIVE_DIR:-/var/log/archive}"
LOG_ARCHIVE_RETENTION_DAYS="${LOG_ARCHIVE_RETENTION_DAYS:-365}"
LOG_ARCHIVE_SOURCES="${LOG_ARCHIVE_SOURCES:-/var/log}"

install -d -m 0750 -o root -g root "${LOG_ARCHIVE_DIR}"

for src in ${LOG_ARCHIVE_SOURCES}; do
  [[ -d "${src}" ]] || continue
  find "${src}" -maxdepth 1 -type f \( -name '*.gz' -o -name '*.xz' -o -name '*.1' -o -name '*.2' \) \
    ! -path "${LOG_ARCHIVE_DIR}/*" -print0 |
    while IFS= read -r -d '' rotated; do
      base="$(basename "${rotated}")"
      dest="${LOG_ARCHIVE_DIR}/${base}"
      if [[ ! -e "${dest}" ]]; then
        mv "${rotated}" "${dest}"
      fi
    done
done

find "${LOG_ARCHIVE_DIR}" -type f -mtime +"${LOG_ARCHIVE_RETENTION_DAYS}" -delete

echo "Log archive complete: ${LOG_ARCHIVE_DIR} (retention ${LOG_ARCHIVE_RETENTION_DAYS} days)"
