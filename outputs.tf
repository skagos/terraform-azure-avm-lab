output "resource_names" {
  description = "The calculated names of the Azure resources."
  value       = local.resource_names
}

output "resource_ids" {
  description = "The Azure resource IDs created by this root module."
  value = {
    resource_group                 = module.resource_group.resource_id
    log_analytics_workspace        = module.log_analytics_workspace.resource_id
    virtual_network                = module.virtual_network.resource_id
    network_security_group         = module.network_security_group.resource_id
    nat_gateway                    = module.nat_gateway.resource_id
    nat_gateway_public_ip          = module.nat_gateway.public_ip_resource["default"].id
    key_vault                      = module.key_vault.resource_id
    storage_account                = module.storage_account.resource_id
    user_assigned_managed_identity = module.user_assigned_managed_identity.resource_id
    virtual_machine                = module.virtual_machine.resource_id
    network_interface              = module.virtual_machine.network_interfaces["private"].id
    bastion_host_public_ip         = module.bastion_host_public_ip.resource_id
    bastion_host                   = module.bastion_host.resource_id
  }
}

output "subnets" {
  description = "The calculated subnet configuration and Azure resource IDs."
  value       = local.subnets
}
