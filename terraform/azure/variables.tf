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
  description = "CIDRs allowed for SSH and port 8000 — must be explicitly set to a restricted range"
  type        = list(string)

  validation {
    condition     = !contains(var.allowed_source_addresses, "0.0.0.0/0")
    error_message = "Unrestricted access (0.0.0.0/0) is not allowed. Specify trusted CIDR blocks, e.g. [\"203.0.113.10/32\"]."
  }
}

variable "common_tags" {
  description = "Common tags applied to all Azure resources for cost allocation and management"
  type        = map(string)
  default = {
    Project     = "cloud-anomaly-lab"
    Environment = "lab"
    Owner       = "devops-team"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}
