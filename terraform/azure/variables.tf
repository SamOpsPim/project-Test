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
  description = "Trusted CIDRs for SSH (never use 0.0.0.0/0; prefer Bastion or az vm ssh with AAD)"
  type        = list(string)

  validation {
    condition     = length(var.allowed_source_addresses) > 0 && !contains(var.allowed_source_addresses, "0.0.0.0/0") && !contains(var.allowed_source_addresses, "::/0")
    error_message = "allowed_source_addresses must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "allowed_app_source_addresses" {
  description = "Trusted CIDRs for port 8000; if null, uses allowed_source_addresses"
  type        = list(string)
  default     = null

  validation {
    condition = var.allowed_app_source_addresses == null || (
      length(var.allowed_app_source_addresses) > 0 &&
      !contains(var.allowed_app_source_addresses, "0.0.0.0/0") &&
      !contains(var.allowed_app_source_addresses, "::/0")
    )
    error_message = "When set, allowed_app_source_addresses must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "environment" {
  description = "Environment name for cost allocation tags"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner contact for cost allocation tags"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center identifier for cost allocation tags"
  type        = string
  default     = "unset"
}

variable "extra_tags" {
  description = "Additional tags merged into all taggable resources"
  type        = map(string)
  default     = {}
}
