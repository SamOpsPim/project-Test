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
  description = "Environment label for cost allocation (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team responsible for this infrastructure (cost allocation)"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center or chargeback code for FinOps tagging"
  type        = string
  default     = "unallocated"
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

variable "os_disk_size_gb" {
  description = "OS managed disk size in GB"
  type        = number
  default     = 30
}

variable "allowed_source_addresses" {
  description = "Trusted CIDRs for SSH and port 8000 (e.g. [\"203.0.113.10/32\"]). Must not be open to the entire internet."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.allowed_source_addresses) > 0 && !contains(var.allowed_source_addresses, "0.0.0.0/0") && !contains(var.allowed_source_addresses, "::/0")
    error_message = "Set allowed_source_addresses to at least one trusted CIDR. 0.0.0.0/0 and ::/0 are not allowed."
  }
}
