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
  description = "Trusted IPv4 CIDRs for SSH and port 8000. Required in terraform.tfvars; 0.0.0.0/0 is not allowed."
  type        = list(string)

  validation {
    condition = alltrue([
      length(var.allowed_source_addresses) > 0,
      !contains(var.allowed_source_addresses, "0.0.0.0/0"),
    ])
    error_message = "Set allowed_source_addresses to at least one trusted CIDR (e.g. your public IP /32). 0.0.0.0/0 is not allowed."
  }
}

variable "tag_environment" {
  description = "Environment tag for cost allocation"
  type        = string
  default     = "dev"
}

variable "tag_project" {
  description = "Project tag (empty uses project_name)"
  type        = string
  default     = ""
}

variable "tag_owner" {
  description = "Owner tag for cost allocation"
  type        = string
  default     = "finops-lab"
}
