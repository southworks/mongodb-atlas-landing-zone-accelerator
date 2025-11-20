locals {
  app_service_plan_name    = module.naming.app_service_plan.name
  app_service_plan_sku     = "B1" # Minimum SKU for VNet integration is B1
  app_web_app_name         = module.naming.app_service.name_unique
  virtual_network_name     = data.terraform_remote_state.common.outputs.vnet.name
  vnet_resource_group_name = data.terraform_remote_state.common.outputs.vnet.resource_group_name
  subnet_name              = module.naming.subnet.name

  region_definition = data.terraform_remote_state.devops.outputs.region_definition["unique"]

  tags = {
    environment = "dev"
    app_name    = local.app_web_app_name
  }
}
