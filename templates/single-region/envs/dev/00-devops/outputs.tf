output "identity_info" {
  value = module.devops.identity_info
}

output "resource_group_names" {
  value = {
    devops         = module.devops.resource_group_names.devops
    infrastructure = module.devops.resource_group_names.infrastructure
    app            = module.devops.resource_group_names.app
  }
}

output "region_definition" {
  value = local.region_definition
}