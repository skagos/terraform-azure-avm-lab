variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.location))
    error_message = "The location must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or fewer."
  }
}

variable "resource_name_location_short" {
  type        = string
  description = "The short location segment used in globally unique resource names. An empty value derives it from the AVM regions utility module."
  default     = ""

  validation {
    condition     = length(var.resource_name_location_short) == 0 || can(regex("^[a-z]+$", var.resource_name_location_short))
    error_message = "The short location segment must contain only lowercase letters."
  }

  validation {
    condition     = length(var.resource_name_location_short) <= 3
    error_message = "The short location segment must be 3 characters or fewer."
  }
}

variable "resource_name_workload" {
  type        = string
  description = "The workload segment used in resource names."
  default     = "demo"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_workload))
    error_message = "The workload segment must contain only lowercase letters and numbers."
  }

  validation {
    condition     = length(var.resource_name_workload) <= 4
    error_message = "The workload segment must be 4 characters or fewer."
  }
}

variable "resource_name_environment" {
  type        = string
  description = "The environment segment used in resource names."
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_environment))
    error_message = "The environment segment must contain only lowercase letters and numbers."
  }

  validation {
    condition     = length(var.resource_name_environment) <= 4
    error_message = "The environment segment must be 4 characters or fewer."
  }
}

variable "resource_name_sequence_start" {
  type        = number
  description = "The sequence number used in resource names."
  default     = 1

  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The sequence number must be between 1 and 999."
  }
}

variable "resource_name_templates" {
  type        = map(string)
  description = "Templates used to calculate the Azure resource names."
  default = {
    resource_group_name                 = "rg-$${workload}-$${environment}-$${location}-$${sequence}"
    log_analytics_workspace_name        = "law-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_network_name                = "vnet-$${workload}-$${environment}-$${location}-$${sequence}"
    network_security_group_name         = "nsg-$${workload}-$${environment}-$${location}-$${sequence}"
    nat_gateway_name                    = "nat-$${workload}-$${environment}-$${location}-$${sequence}"
    nat_gateway_public_ip_name          = "pip-nat-$${workload}-$${environment}-$${location}-$${sequence}"
    key_vault_name                      = "kv$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    storage_account_name                = "sto$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    user_assigned_managed_identity_name = "uami-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_machine_name                = "vm-$${workload}-$${environment}-$${location}-$${sequence}"
    network_interface_name              = "nic-$${workload}-$${environment}-$${location}-$${sequence}"
    bastion_host_public_ip_name         = "pip-bas-$${workload}-$${environment}-$${location}-$${sequence}"
    bastion_host_name                   = "bas-$${workload}-$${environment}-$${location}-$${sequence}"
  }
}

variable "address_space" {
  type        = string
  description = "The CIDR address space assigned to the virtual network."

  validation {
    condition     = can(cidrnetmask(var.address_space))
    error_message = "The address space must be a valid IPv4 CIDR block."
  }
}

variable "subnets" {
  type = map(object({
    size                       = number
    has_nat_gateway            = bool
    has_network_security_group = bool
  }))
  description = "The subnets calculated inside the virtual network address space."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all Azure resources."
}

variable "enable_encryption_at_host" {
  type        = bool
  description = "Whether to enable encryption at host for the virtual machine. This requires the subscription feature to be registered."
  default     = false
}

variable "virtual_machine_sku" {
  type        = string
  description = "The Azure VM size to deploy."
}

variable "virtual_machine_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "The source image reference for the Linux virtual machine."
}
