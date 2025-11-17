resource "azurerm_log_analytics_workspace" "central" {
  name                       = var.workspace_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.sku
  retention_in_days          = var.retention_in_days
  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled     = var.internet_query_enabled

  tags = var.tags
}

# Application Insights for MongoDB metrics collection
resource "azurerm_application_insights" "monitoring_appinsights" {
  name                       = var.app_insights_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  workspace_id               = azurerm_log_analytics_workspace.central.id
  application_type           = "web"
  internet_ingestion_enabled = false

  tags = var.tags
}

# Azure Monitor Private Link Scope for secure monitoring
resource "azurerm_monitor_private_link_scope" "monitoring_pls" {
  name                  = var.private_link_scope_name
  resource_group_name   = var.resource_group_name
  ingestion_access_mode = "PrivateOnly"
  query_access_mode     = "PrivateOnly"

  tags = var.tags
}

# Link Application Insights to AMPLS
resource "azurerm_monitor_private_link_scoped_service" "appinsights_assoc" {
  name                = "${var.app_insights_name}-ampls-association"
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.monitoring_pls.name
  linked_resource_id  = azurerm_application_insights.monitoring_appinsights.id
}

# Link Log Analytics Workspace to AMPLS
resource "azurerm_monitor_private_link_scoped_service" "workspace_assoc" {
  name                = "${var.workspace_name}-ampls-association"
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.monitoring_pls.name
  linked_resource_id  = azurerm_log_analytics_workspace.central.id
}

# Private DNS Zones for Azure Monitor
resource "azurerm_private_dns_zone" "oms" {
  name                = "privatelink.oms.opinsights.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "ods" {
  name                = "privatelink.ods.opinsights.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "monitor" {
  name                = "privatelink.monitor.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "agentsvc" {
  name                = "privatelink.agentsvc.azure-automation.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link DNS zones to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "oms_link" {
  name                  = "${var.vnet_name}-oms-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.oms.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "ods_link" {
  name                  = "${var.vnet_name}-ods-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.ods.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "monitor_link" {
  name                  = "${var.vnet_name}-monitor-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.monitor.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "agentsvc_link" {
  name                  = "${var.vnet_name}-agentsvc-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.agentsvc.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

# Private Endpoint for AMPLS
resource "azurerm_private_endpoint" "monitoring_ampls_pe" {
  name                          = "${var.pe_name}-ampls"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.ampls_pe_subnet_id
  custom_network_interface_name = "${var.network_interface_name}-ampls"

  private_service_connection {
    name                           = "${var.private_service_connection_name}-ampls"
    private_connection_resource_id = azurerm_monitor_private_link_scope.monitoring_pls.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.oms.id,
      azurerm_private_dns_zone.ods.id,
      azurerm_private_dns_zone.monitor.id,
      azurerm_private_dns_zone.agentsvc.id
    ]
  }

  tags = var.tags

  depends_on = [
    azurerm_application_insights.monitoring_appinsights,
    azurerm_log_analytics_workspace.central,
    azurerm_monitor_private_link_scope.monitoring_pls,
    azurerm_monitor_private_link_scoped_service.appinsights_assoc,
    azurerm_monitor_private_link_scoped_service.workspace_assoc,
    azurerm_private_dns_zone.oms,
    azurerm_private_dns_zone.ods,
    azurerm_private_dns_zone.monitor,
    azurerm_private_dns_zone.agentsvc,
    azurerm_private_dns_zone_virtual_network_link.oms_link,
    azurerm_private_dns_zone_virtual_network_link.ods_link,
    azurerm_private_dns_zone_virtual_network_link.monitor_link,
    azurerm_private_dns_zone_virtual_network_link.agentsvc_link
  ]
}