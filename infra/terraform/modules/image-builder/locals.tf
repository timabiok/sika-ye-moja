locals {
  rhsm_key_vault_name = var.enable_rhsm ? element(split("/", var.rhsm_key_vault_id), 8) : ""

  shell_rhsm = var.enable_rhsm ? [
    "set -euo pipefail",
    "dnf -y install subscription-manager jq",
    "ACCESS_TOKEN=$$(curl -sf -H Metadata:true 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' | jq -r .access_token)",
    "ACTIVATION_KEY=$$(curl -sf -H \"Authorization: Bearer $$ACCESS_TOKEN\" 'https://${local.rhsm_key_vault_name}.vault.azure.net/secrets/${var.rhsm_secret_name}?api-version=7.4' | jq -r .value)",
    "subscription-manager register --activationkey=\"$$ACTIVATION_KEY\" --org=\"${var.rhsm_organization}\" --force",
    "subscription-manager status",
    "unset ACTIVATION_KEY ACCESS_TOKEN",
  ] : []

  shell_prep = [
    "set -euo pipefail",
    "dnf -y update --security",
    "dnf -y install openscap-scanner scap-security-guide aide audit audispd-plugins chrony rsyslog logrotate dnf-automatic policycoreutils-python-utils",
    "systemctl enable auditd chronyd rsyslog dnf-automatic-install.timer",
    "fips-mode-setup --enable || true",
    "sed -i 's/^#\\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config",
    "sed -i 's/^#\\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config",
    "sed -i 's/^#\\?ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config",
    "sed -i 's/^#\\?ClientAliveCountMax.*/ClientAliveCountMax 0/' /etc/ssh/sshd_config",
    "useradd -r -s /sbin/nologin -c 'Break-glass emergency' breakglass || true",
    "passwd -l breakglass || true",
    "passwd -l root",
    "dnf -y remove telnet rsh talk || true",
    "dnf clean all",
    "rm -rf /var/cache/dnf/* /tmp/* /var/tmp/*",
  ]

  shell_openscap = [
    "set -euo pipefail",
    "PROFILE=xccdf_org.ssgproject.content_profile_cis",
    "DATASTREAM=/usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml",
    "oscap xccdf eval --profile \"$PROFILE\" --remediate --results /tmp/cis-remediate-results.xml \"$DATASTREAM\"",
    "oscap xccdf eval --profile \"$PROFILE\" --results /tmp/cis-verify-results.xml --report /tmp/cis-verify-report.html \"$DATASTREAM\" || true",
    "mkdir -p /opt/compliance/artifacts",
    "cp /tmp/cis-verify-results.xml /tmp/cis-verify-report.html /opt/compliance/artifacts/ 2>/dev/null || true",
    "chmod 640 /opt/compliance/artifacts/*",
  ]

  shell_finalize = [
    "set -euo pipefail",
    "aide --init || true",
    "mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz 2>/dev/null || true",
    "sestatus",
    "getenforce | grep -E 'Enforcing|Permissive'",
    "systemctl disable kdump || true",
    "echo 'Golden image build completed' > /etc/motd.d/golden-image",
    "truncate -s 0 /var/log/wtmp /var/log/btmp /var/log/lastlog 2>/dev/null || true",
    "history -c 2>/dev/null || true",
    "rm -f /root/.bash_history",
    "cloud-init clean --logs || true",
    "waagent -force -deprovision+user && export HISTSIZE=0 && sync",
  ]

  customize_steps = concat(
    length(local.shell_rhsm) > 0 ? [
      {
        type   = "Shell"
        name   = "RedHatSubscription"
        inline = local.shell_rhsm
      },
    ] : [],
    [
      {
        type = "Shell"
        name = "BankBaselinePrep"
        inline = local.shell_prep
      },
      {
        type = "Shell"
        name = "OpenScapCisLevel1"
        inline = local.shell_openscap
      },
    ],
    var.enable_ansible_customization ? [
      {
        type         = "Ansible"
        name         = "BankAnsibleBaseline"
        playbookUri  = "https://${azurerm_storage_account.scripts.name}.blob.core.windows.net/${azurerm_storage_container.scripts.name}/${azurerm_storage_blob.ansible_archive[0].name}"
        inventoryUri = null
      }
    ] : [],
    [
      {
        type = "Shell"
        name = "FinalizeGoldenImage"
        inline = local.shell_finalize
      },
    ]
  )

  target_regions = length(var.replication_regions) > 0 ? [
    for region in var.replication_regions : {
      name                   = region
      replicaCount           = var.replica_count
      storageAccountType     = "Standard_LRS"
    }
  ] : [
    {
      name                 = var.location
      replicaCount       = var.replica_count
      storageAccountType   = "Standard_LRS"
    }
  ]

  version_parts = split(".", var.image_version)
  version_major = tonumber(local.version_parts[0])
  version_minor = length(local.version_parts) > 1 ? tonumber(local.version_parts[1]) : 0
  version_patch = length(local.version_parts) > 2 ? tonumber(local.version_parts[2]) : 0
}
