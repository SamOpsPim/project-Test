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

variable "environment" {
  description = "Deployment environment (cost allocation tag)"
  type        = string
  default     = "development"
}

variable "owner" {
  description = "Team or owner contact (cost allocation tag)"
  type        = string
  default     = "unassigned"
}

variable "cost_center" {
  description = "Cost center or chargeback code"
  type        = string
  default     = "unassigned"
}

variable "allowed_source_addresses" {
  description = "CIDRs allowed for SSH and port 8000. Must not be open internet; use e.g. [\"203.0.113.10/32\"] or your VPN range."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition = length(var.allowed_source_addresses) > 0 && !contains(var.allowed_source_addresses, "0.0.0.0/0") && !contains(var.allowed_source_addresses, "*") && !contains(var.allowed_source_addresses, "Internet") && !contains(var.allowed_source_addresses, "::/0")
    error_message = "allowed_source_addresses must be non-empty and must not use open internet (0.0.0.0/0, ::/0), \"*\", or \"Internet\"."
  }
}
