#!/usr/bin/env bash
# Layer-2: format and mount first unattached data disk (LUN 0) by UUID in fstab.
# Banking baseline — survives reboot; no manual mount.
#
#   DATA_DISK_MOUNT_POINT=/var/lib/containers \
#     /opt/compliance/bootstrap/mount-data-disk.sh

set -euo pipefail

MOUNT_POINT="${DATA_DISK_MOUNT_POINT:-/var/lib/containers}"
FSTYPE="${DATA_DISK_FSTYPE:-xfs}"
LABEL="${DATA_DISK_LABEL:-podman-data}"

mkdir -p "${MOUNT_POINT}"

# Azure data disk on RHEL is typically the second block device (LUN 0).
DISK=""
for candidate in /dev/disk/azure/scsi1/lun0 /dev/sdc /dev/nvme1n1; do
  if [[ -b "${candidate}" ]]; then
    DISK="${candidate}"
    break
  fi
done

if [[ -z "${DISK}" ]]; then
  echo "No data disk found — skip if VM has no data disk." >&2
  exit 0
fi

if ! blkid "${DISK}" >/dev/null 2>&1; then
  mkfs -t "${FSTYPE}" -L "${LABEL}" "${DISK}"
fi

UUID="$(blkid -s UUID -o value "${DISK}")"
if ! grep -q "${UUID}" /etc/fstab; then
  echo "UUID=${UUID}  ${MOUNT_POINT}  ${FSTYPE}  defaults,nofail  0  2" >> /etc/fstab
fi

mount "${MOUNT_POINT}"
echo "Data disk ${DISK} (UUID=${UUID}) mounted at ${MOUNT_POINT}."
