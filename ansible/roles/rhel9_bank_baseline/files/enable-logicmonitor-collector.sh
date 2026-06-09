#!/usr/bin/env bash
# Layer-2 bootstrap: LogicMonitor Linux collector silent install.
# No portal credentials are stored in the golden image.
#
# Usage (from cloud-init, Ansible, or runbook after VM deploy):
#   LOGICMONITOR_INSTALLER_URL='https://<portal>/.../LogicMonitorSetup.bin' \
#     /opt/compliance/bootstrap/enable-logicmonitor-collector.sh
#
# Or copy installer to the host:
#   LOGICMONITOR_INSTALLER_PATH=/tmp/LogicMonitorSetup.bin \
#     /opt/compliance/bootstrap/enable-logicmonitor-collector.sh
#
# Optional:
#   LOGICMONITOR_INSTALL_DIR=/usr/local/logicmonitor
#   LOGICMONITOR_COLLECTOR_SIZE=small
#   LOGICMONITOR_INSTALL_USER=logicmonitor

set -euo pipefail

INSTALL_DIR="${LOGICMONITOR_INSTALL_DIR:-/usr/local/logicmonitor}"
INSTALL_USER="${LOGICMONITOR_INSTALL_USER:-logicmonitor}"
COLLECTOR_SIZE="${LOGICMONITOR_COLLECTOR_SIZE:-}"
WORK_DIR="$(mktemp -d)"
INSTALLER_PATH=""

cleanup() {
  rm -rf "${WORK_DIR}"
}
trap cleanup EXIT

if [[ -n "${LOGICMONITOR_INSTALLER_PATH:-}" ]]; then
  INSTALLER_PATH="${LOGICMONITOR_INSTALLER_PATH}"
elif [[ -n "${LOGICMONITOR_INSTALLER_URL:-}" ]]; then
  INSTALLER_PATH="${WORK_DIR}/LogicMonitorSetup.bin"
  curl -fsSL "${LOGICMONITOR_INSTALLER_URL}" -o "${INSTALLER_PATH}"
else
  echo "Set LOGICMONITOR_INSTALLER_URL or LOGICMONITOR_INSTALLER_PATH." >&2
  exit 1
fi

if [[ ! -f "${INSTALLER_PATH}" ]]; then
  echo "Installer not found: ${INSTALLER_PATH}" >&2
  exit 1
fi

chmod +x "${INSTALLER_PATH}"

ARGS=(-y -d "${INSTALL_DIR}" -u "${INSTALL_USER}")
if [[ -n "${COLLECTOR_SIZE}" ]]; then
  ARGS+=(-s "${COLLECTOR_SIZE}")
fi

"${INSTALLER_PATH}" "${ARGS[@]}"

echo "LogicMonitor collector install completed under ${INSTALL_DIR}."
