module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.14.1"

  parent_id           = module.resource_group.resource_id
  name                = local.resource_names.virtual_network_name
  location            = var.location
  address_space       = [var.address_space]
  subnets             = local.subnets
  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags
}
