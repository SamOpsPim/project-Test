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

variable "environment" {
  description = "Cost allocation tag (Environment)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Cost allocation tag (Owner)"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost allocation tag (CostCenter)"
  type        = string
  default     = "unset"
}

variable "application" {
  description = "Cost allocation tag (Application)"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "allowed_ssh_source_addresses" {
  description = "Non-open CIDRs for SSH (e.g. [\"203.0.113.10/32\"]). Never use 0.0.0.0/0."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.allowed_ssh_source_addresses) > 0 &&
      !contains(var.allowed_ssh_source_addresses, "0.0.0.0/0") &&
      !contains(var.allowed_ssh_source_addresses, "::/0")
    )
    error_message = "allowed_ssh_source_addresses must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}

variable "allowed_app_source_addresses" {
  description = "CIDRs allowed for TCP 8000. Avoid 0.0.0.0/0 unless intentionally public."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.allowed_app_source_addresses) > 0 &&
      !contains(var.allowed_app_source_addresses, "0.0.0.0/0") &&
      !contains(var.allowed_app_source_addresses, "::/0")
    )
    error_message = "allowed_app_source_addresses must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}
