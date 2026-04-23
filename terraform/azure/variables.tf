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
  description = "CIDRs allowed for SSH and port 8000. Required; use VPN or /32 IPs—never 0.0.0.0/0 for production."
  type        = list(string)
}

variable "environment" {
  description = "Environment label for cost allocation (e.g. dev, staging, prod)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner label for cost allocation (team or contact)"
  type        = string
  default     = "platform"
}

variable "cost_center" {
  description = "Cost center for chargeback and FinOps reporting"
  type        = string
  default     = "engineering"
}
