#!/usr/bin/env bash
# Layer-2 bootstrap: mount Azure Files on RHEL (NFS or SMB).
#
# NFS example:
#   AZURE_FILES_PROTOCOL=NFS \
#   AZURE_FILES_MOUNT_SPEC='account.file.core.windows.net:/account/share' \
#   AZURE_FILES_MOUNT_POINT=/mnt/ingestion \
#     /opt/compliance/bootstrap/mount-azure-fileshare.sh
#
# SMB example (Entra Kerberos — client must configure host auth separately):
#   AZURE_FILES_PROTOCOL=SMB \
#   AZURE_FILES_UNC='//account.file.core.windows.net/share' \
#   AZURE_FILES_MOUNT_POINT=/mnt/ingestion \
#     /opt/compliance/bootstrap/mount-azure-fileshare.sh

set -euo pipefail

PROTOCOL="${AZURE_FILES_PROTOCOL:-NFS}"
MOUNT_POINT="${AZURE_FILES_MOUNT_POINT:-/mnt/ingestion}"
FSTAB_OPTS_NFS="${AZURE_FILES_FSTAB_OPTS:-sec=sys,vers=4,minorversion=1,nconnect=4,_netdev}"

mkdir -p "${MOUNT_POINT}"

case "${PROTOCOL}" in
  NFS)
    SOURCE="${AZURE_FILES_MOUNT_SPEC:?Set AZURE_FILES_MOUNT_SPEC for NFS}"
    if ! grep -q "${MOUNT_POINT}" /etc/fstab; then
      echo "${SOURCE}  ${MOUNT_POINT}  nfs  ${FSTAB_OPTS_NFS}  0  0" >> /etc/fstab
    fi
    mount "${MOUNT_POINT}"
    ;;
  SMB)
    command -v mount.cifs >/dev/null 2>&1 || dnf install -y cifs-utils
    SOURCE="${AZURE_FILES_UNC:?Set AZURE_FILES_UNC for SMB}"
    if ! grep -q "${MOUNT_POINT}" /etc/fstab; then
      echo "${SOURCE}  ${MOUNT_POINT}  cifs  _netdev,x-systemd.automount  0  0" >> /etc/fstab
    fi
    mount "${MOUNT_POINT}"
    ;;
  *)
    echo "AZURE_FILES_PROTOCOL must be NFS or SMB." >&2
    exit 1
    ;;
esac

echo "Azure Files mounted at ${MOUNT_POINT} (${PROTOCOL})."
