locals {
  environment = "dev"

  project_name = var.project_name

  tags = {
    environment = local.environment
    project     = local.project_name
  }

  org_id                   = var.org_id
  cluster_name             = var.cluster_name
  cluster_type             = "REPLICASET"
  backup_enabled           = true
  reference_hour_of_day    = 3
  reference_minute_of_hour = 45
  restore_window_days      = 4

  naming_suffix_base = "inframulregion"

  region_definitions = data.terraform_remote_state.devops.outputs.region_definitions

  # For Atlas cluster
  # Disclaimer: Ensure that the `instance_size` is consistent across all regions specified in `region_configs`. Refer to the official documentation for more details: https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster#electable_specs-1
  region_configs = {
    for k, v in local.region_definitions : k => {
      atlas_region = v.atlas_region
      azure_region = v.azure_region
      priority     = v.priority
      electable_specs = {
        instance_size = "M10"
        node_count    = v.node_count
      }
    }
  }

  # For Azure resources
  regions = {
    for k, v in local.region_definitions : k => {
      location                                      = v.azure_region
      address_space                                 = v.address_space
      private_subnet_prefixes                       = v.private_subnet_prefixes
      private_subnet_name                           = v.private_subnet_name
      manual_connection                             = true
      deploy_observability_subnets                  = v.deploy_observability_subnets
      has_keyvault_private_endpoint                 = v.has_keyvault_private_endpoint
      has_observability_storage_account             = v.has_observability_storage_account
      observability_function_app_subnet_prefixes    = v.deploy_observability_subnets ? v.observability_function_app_subnet_prefixes : null
      monitoring_ampls_subnet_prefixes              = v.deploy_observability_subnets ? v.monitoring_ampls_subnet_prefixes : null
      observability_function_app_subnet_name        = v.deploy_observability_subnets ? v.observability_function_app_subnet_name : null
      monitoring_ampls_subnet_name                  = v.deploy_observability_subnets ? v.monitoring_ampls_subnet_name : null
      keyvault_private_endpoint_subnet_prefixes     = v.has_keyvault_private_endpoint ? v.keyvault_private_endpoint_subnet_prefixes : null
      keyvault_private_endpoint_subnet_name         = v.has_keyvault_private_endpoint ? v.keyvault_private_endpoint_subnet_name : null
      observability_storage_account_subnet_prefixes = v.has_observability_storage_account ? v.observability_storage_account_subnet_prefixes : null
      observability_storage_account_subnet_name     = v.has_observability_storage_account ? v.observability_storage_account_subnet_name : null
    }
  }

  vnet_keys  = sort(keys(module.network))
  pair_list  = flatten([for i, a in local.vnet_keys : [for j, b in local.vnet_keys : { key = "${a}|${b}", a = a, b = b } if i < j]])
  vnet_pairs = { for p in local.pair_list : p.key => { a = p.a, b = p.b } }

  mongo_atlas_client_id                = var.mongo_atlas_client_id
  mongo_atlas_client_secret            = var.mongo_atlas_client_secret
  mongo_atlas_client_secret_expiration = timeadd(time_static.build_time.rfc3339, "8760h")
  purge_protection_enabled             = true
  soft_delete_retention_days           = 7

  # Log Analytics Workspace configuration
  log_analytics_workspace_sku                        = "PerGB2018"
  log_analytics_workspace_retention_in_days          = 30
  log_analytics_workspace_internet_ingestion_enabled = false
}
