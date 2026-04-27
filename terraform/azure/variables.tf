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
  description = "CIDRs allowed for SSH and port 8000. Replace the default documentation placeholder (203.0.113.10/32) with your trusted IPs or ranges before apply."
  type        = list(string)
  default     = ["203.0.113.10/32"]

  validation {
    condition     = length([for c in var.allowed_source_addresses : c if c == "0.0.0.0/0"]) == 0
    error_message = "allowed_source_addresses must not include 0.0.0.0/0; use specific trusted CIDRs only."
  }
}

variable "cost_allocation_tags" {
  description = "Tags on Azure resources for cost allocation (FinOps)."
  type        = map(string)
  default = {
    Environment = "lab"
    Owner       = "unset"
    Project     = "cloud-anomaly-lab"
    CostCenter  = "unset"
  }
}
