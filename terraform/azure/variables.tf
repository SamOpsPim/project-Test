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
  description = "CIDRs allowed for SSH and port 8000 (required; use /32 for a single IP, never 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition     = length(var.allowed_source_addresses) > 0 && !contains(var.allowed_source_addresses, "0.0.0.0/0") && !contains(var.allowed_source_addresses, "::/0")
    error_message = "allowed_source_addresses must be non-empty and must not use 0.0.0.0/0 or ::/0 (open internet)."
  }
}

variable "environment" {
  description = "Environment tag for cost allocation (e.g. lab, dev, prod)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner tag for cost allocation and accountability"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center tag for FinOps chargeback"
  type        = string
  default     = "unset"
}

variable "additional_tags" {
  description = "Extra tags merged with default_tags on the provider"
  type        = map(string)
  default     = {}
}
