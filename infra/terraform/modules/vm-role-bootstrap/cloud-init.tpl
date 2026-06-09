#cloud-config
# Layer 2 role bootstrap — banking baseline (prescriptive).
# Layer 3 workload deploy is GitHub Actions after this completes.

write_files:
  - path: /etc/profile.d/layer2-role.sh
    permissions: "0644"
    content: |
      export VM_DEPLOY_LAYER=2
      export VM_ROLE=${vm_role}
      export RUNNER_UAMI_ID=${uami_resource_id}
  - path: /opt/compliance/bootstrap/layer2-vars.env
    permissions: "0640"
    content: |
      VM_ROLE=${vm_role}
      RUNNER_UAMI_ID=${uami_resource_id}
      DATA_DISK_MOUNT_POINT=${data_disk_mount_point}
      AZURE_FILES_MOUNT_SPEC=${fileshare_nfs_mount_spec}
      AZURE_FILES_MOUNT_POINT=${fileshare_mount_point}
      RUNNER_ENV_LABEL=${runner_env_label}

runcmd:
  - [ bash, -lc, "source /opt/ansible/activate && ansible-playbook /opt/compliance/ansible/layer2/playbooks/${vm_role}.yml -e runtime_data_mount_hint=${data_disk_mount_point} -e runtime_fileshare_nfs_mount_spec='${fileshare_nfs_mount_spec}' -e runtime_fileshare_mount_point=${fileshare_mount_point} -e runner_env_label=${runner_env_label}" ]
  - [ bash, -lc, "touch /opt/compliance/artifacts/layer2-bootstrap-complete" ]
