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

variable "trusted_ingress_cidrs" {
  description = "Trusted CIDRs for SSH (22) and app (8000). Use your public IP /32 or a trusted range — never 0.0.0.0/0 in production."
  type        = list(string)
  nullable    = false

  validation {
    condition = length(var.trusted_ingress_cidrs) > 0 && !contains(var.trusted_ingress_cidrs, "0.0.0.0/0") && !contains(var.trusted_ingress_cidrs, "::/0")

    error_message = "trusted_ingress_cidrs must be non-empty and must not allow the entire Internet (0.0.0.0/0 or ::/0)."
  }
}

variable "lab_enabled" {
  description = "Set true only when you intend to deploy this stack. Keeps accidental apply from creating billable resources."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment tag for cost allocation"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner tag for cost allocation"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center tag for cost allocation"
  type        = string
  default     = "engineering"
}

variable "application" {
  description = "Application tag for cost allocation"
  type        = string
  default     = "cloud-anomaly-lab"
}
