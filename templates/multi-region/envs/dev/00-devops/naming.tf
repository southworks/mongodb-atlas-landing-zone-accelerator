module "devops_naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = ["devops"]
}

module "infrastructure_naming" {
  for_each = local.regions

  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = ["infra", each.key]
}

module "application_naming" {
  for_each = local.regions

  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = ["app", each.key]
}