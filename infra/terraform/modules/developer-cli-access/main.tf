locals {
  reader_scope = coalesce(var.dev_resource_group_id, "/subscriptions/${var.dev_subscription_id}")
  common_tags  = merge(var.tags, { Purpose = "developer-cli-pim" })
}

data "azurerm_role_definition" "reader" {
  count = var.enable_reader ? 1 : 0
  name  = "Reader"
  scope = local.reader_scope
}

data "azurerm_role_definition" "acr_push" {
  count = var.enable_acr_push && var.acr_id != null ? 1 : 0
  name  = "AcrPush"
  scope = var.acr_id
}

data "azurerm_role_definition" "kv_secrets" {
  count = var.enable_key_vault_secrets && var.key_vault_id != null ? 1 : 0
  name  = "Key Vault Secrets User"
  scope = var.key_vault_id
}

# PIM eligible — developers activate JIT, then az login with Entra user (temp CLI token).
resource "azurerm_pim_eligible_role_assignment" "developer_reader" {
  count              = var.enable_reader ? 1 : 0
  principal_id       = var.developer_group_object_id
  role_definition_id = data.azurerm_role_definition.reader[0].role_definition_id
  scope              = local.reader_scope
}

resource "azurerm_pim_eligible_role_assignment" "developer_acr_push" {
  count              = var.enable_acr_push && var.acr_id != null ? 1 : 0
  principal_id       = var.developer_group_object_id
  role_definition_id = data.azurerm_role_definition.acr_push[0].role_definition_id
  scope              = var.acr_id
}

resource "azurerm_pim_eligible_role_assignment" "developer_kv_secrets" {
  count              = var.enable_key_vault_secrets && var.key_vault_id != null ? 1 : 0
  principal_id       = var.developer_group_object_id
  role_definition_id = data.azurerm_role_definition.kv_secrets[0].role_definition_id
  scope              = var.key_vault_id
}
