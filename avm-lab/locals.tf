locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    location_short = var.resource_name_location_short == "" ? module.regions.regions_by_name[var.location].geo_code : var.resource_name_location_short
    uniqueness     = random_string.unique_name.id
    sequence       = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = {
    for key, template in var.resource_name_templates :
    key => templatestring(template, local.name_replacements)
  }
}

locals {
  subnets = {
    for key, subnet in var.subnets : key => {
      name             = key
      address_prefixes = [module.ip_addresses.address_prefixes[key]]

      network_security_group = subnet.has_network_security_group ? {
        id = module.network_security_group.resource_id
      } : null

      nat_gateway = subnet.has_nat_gateway ? {
        id = module.nat_gateway.resource_id
      } : null
    }
  }
}

locals {
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                  = "custom"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }
}

locals {
  my_ip_address_split = split(".", data.http.ip.response_body)
  my_cidr_slash_24    = "${join(".", slice(local.my_ip_address_split, 0, 3))}.0/24"
}
