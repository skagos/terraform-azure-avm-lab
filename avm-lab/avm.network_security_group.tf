module "network_security_group" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.0"

  resource_group_name = module.resource_group.name
  name                = local.resource_names.network_security_group_name
  location            = var.location

  security_rules = {
    no_internet = {
      name                       = "block-internet-traffic"
      access                     = "Deny"
      direction                  = "Outbound"
      priority                   = 100
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "Internet"
      destination_port_range     = "*"
    }
  }

  diagnostic_settings = {
    for key, setting in local.diagnostic_settings : key => {
      name                  = setting.name
      workspace_resource_id = setting.workspace_resource_id
      metric_categories     = []
    }
  }

  tags = var.tags
}
