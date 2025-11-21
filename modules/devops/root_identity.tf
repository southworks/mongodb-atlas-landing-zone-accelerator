resource "azurerm_user_assigned_identity" "identity" {
  location            = var.location
  name                = "root-identity"
  resource_group_name = azurerm_resource_group.devops_rg.name
}

resource "azurerm_federated_identity_credential" "federated_identity" {
  name                = var.federation.federated_identity_name
  subject             = var.federation.subject
  audience            = var.audiences
  issuer              = var.issuer
  resource_group_name = azurerm_resource_group.devops_rg.name
  parent_id           = azurerm_user_assigned_identity.identity.id
}

resource "azurerm_role_assignment" "devops_permission_contributor" {
  scope                = azurerm_resource_group.devops_rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "infrastructure_permission_contributor" {
  for_each = var.resource_groups_infrastructure

  scope                = azurerm_resource_group.infrastructure_rgs[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "app_permission_contributor" {
  for_each = var.resource_groups_app

  scope                = azurerm_resource_group.application_rgs[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "devops_permission_user_access_administrator" {
  scope                = azurerm_resource_group.devops_rg.id
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "infrastructure_permission_user_access_administrator" {
  for_each = var.resource_groups_infrastructure

  scope                = azurerm_resource_group.infrastructure_rgs[each.key].id
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "app_permission_user_access_administrator" {
  for_each = var.resource_groups_app

  scope                = azurerm_resource_group.application_rgs[each.key].id
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}
