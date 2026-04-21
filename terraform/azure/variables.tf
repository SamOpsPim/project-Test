variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Linux admin user"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "allowed_source_addresses" {
  description = "CIDRs allowed for SSH and port 8000 (set to your IP /32 or VPN range; never use * or 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition = alltrue([
      for a in var.allowed_source_addresses :
      a != "*" && a != "0.0.0.0/0" && a != "Internet" && a != "::/0"
    ])
    error_message = "allowed_source_addresses must list explicit CIDRs (e.g. 203.0.113.10/32). Wildcard / Internet sources are not allowed."
  }
}

variable "common_tags" {
  description = "Cost allocation and governance tags applied to supported resources (also merged into provider default_tags)"
  type        = map(string)
  default = {
    Environment = "lab"
    CostCenter  = "devops"
    Owner       = "platform"
  }
}
