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
  description = "Azure VM size (override after monitoring if you need more capacity)"
  type        = string
  default     = "Standard_B1ls"
}

variable "environment" {
  description = "Environment label for cost allocation"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner label for cost allocation"
  type        = string
  default     = "FinOpsTeam"
}

variable "cost_center" {
  description = "Cost center label for cost allocation"
  type        = string
  default     = "lab"
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
  description = "Trusted source address prefixes for SSH and port 8000 (use explicit CIDRs such as 203.0.113.10/32, not Internet-wide rules)"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.allowed_source_addresses) > 0
    error_message = "Set allowed_source_addresses to at least one trusted CIDR (e.g. 203.0.113.10/32)."
  }

  validation {
    condition = alltrue([
      for a in var.allowed_source_addresses :
      a != "0.0.0.0/0" && a != "::/0" && lower(a) != "internet" && a != "*"
    ])
    error_message = "Do not allow the full internet; use specific CIDRs (not 0.0.0.0/0, Internet, or *)."
  }
}
