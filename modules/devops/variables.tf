variable "tags" {
  type        = map(string)
  description = "A map of tags to be applied to resources"
}

variable "resource_group_name_devops" {
  type        = string
  description = "The name of the DevOps resource group"
}
variable "resource_groups_app" {
  type = map(object({
    name     = string
    location = string
  }))
  default     = {}
  description = "(Optional) Map of application resource groups with their locations. Key is the region identifier (e.g., 'zoneA', 'zoneB', 'zoneC')."
}

variable "resource_groups_infrastructure" {
  type = map(object({
    name     = string
    location = string
  }))
  default     = {}
  description = "(Optional) Map of infrastructure resource groups with their locations. Key is the region identifier (e.g., 'zoneA', 'zoneB', 'zoneC')."
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "replication_type" {
  type    = string
  default = "LRS"
}

variable "container_name" {
  type = string
}

variable "container_access_type" {
  type    = string
  default = "private"
}

# Identity

variable "audiences" {
  type = list(string)
}

variable "issuer" {
  type = string
}

variable "federation" {
  type = map(string)
}
