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
  description = "CIDRs allowed for SSH and port 8000 (use /32 for your IP). Must not be open to the world."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.allowed_source_addresses) > 0
    error_message = "allowed_source_addresses must contain at least one CIDR (e.g. [\"203.0.113.10/32\"])."
  }

  validation {
    condition = alltrue([
      for c in var.allowed_source_addresses : !contains(["0.0.0.0/0", "::/0", "*"], c)
    ])
    error_message = "allowed_source_addresses must not use 0.0.0.0/0, ::/0, or *."
  }
}

variable "extra_tags" {
  description = "Optional extra tags merged with default cost-allocation tags"
  type        = map(string)
  default     = {}
}
