variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west1-b"
}

variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
  default     = "e2-micro"
}

variable "ssh_user" {
  description = "Linux user for SSH (metadata ssh-keys)"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key for instance login"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment (cost allocation label)"
  type        = string
  default     = "development"
}

variable "owner" {
  description = "Team or owner contact (cost allocation label)"
  type        = string
  default     = "unassigned"
}

variable "cost_center" {
  description = "Cost center or chargeback code"
  type        = string
  default     = "unassigned"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB (rightsizing: align with workload needs)"
  type        = number
  default     = 16

  validation {
    condition     = var.boot_disk_size_gb >= 10 && var.boot_disk_size_gb <= 65536
    error_message = "boot_disk_size_gb must be between 10 and 65536."
  }
}

variable "app_source_ranges" {
  description = "CIDRs allowed to reach port 8000. Must not be open internet; use IAP or known ranges."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition = length(var.app_source_ranges) > 0 && !contains(var.app_source_ranges, "0.0.0.0/0") && !contains(var.app_source_ranges, "::/0")
    error_message = "app_source_ranges must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH. Must not be open internet; prefer IAP TCP forwarding ranges or known admin CIDRs."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition = length(var.ssh_source_ranges) > 0 && !contains(var.ssh_source_ranges, "0.0.0.0/0") && !contains(var.ssh_source_ranges, "::/0")
    error_message = "ssh_source_ranges must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}
