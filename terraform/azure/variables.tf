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

variable "environment" {
  description = "Environment tag for cost allocation"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag for cost allocation"
  type        = string
  default     = "finops-team"
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
  description = "Trusted CIDRs for SSH and port 8000 (e.g. [\"203.0.113.10/32\"]). Set in terraform.tfvars; open internet CIDRs are rejected."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.allowed_source_addresses) > 0 && length([
      for c in var.allowed_source_addresses : c
      if c == "0.0.0.0/0" || c == "::/0"
    ]) == 0
    error_message = "allowed_source_addresses must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}
