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
  description = "CIDRs allowed for SSH and port 8000 – must be explicitly set to specific IP ranges (no default to prevent accidental public exposure)"
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.allowed_source_addresses : cidr != "0.0.0.0/0"])
    error_message = "allowed_source_addresses must not contain 0.0.0.0/0. Restrict access to specific IP addresses or ranges (e.g. [\"203.0.113.10/32\"])."
  }
}

variable "environment" {
  description = "Deployment environment (e.g. lab, dev, staging, production)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner of the resources for cost allocation and accountability"
  type        = string
  default     = "devops"
}

variable "cost_center" {
  description = "Cost center for billing and cost allocation"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
