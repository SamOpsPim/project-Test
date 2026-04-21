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
  description = "Compute Engine machine type (override after monitoring if you need more capacity)"
  type        = string
  default     = "f1-micro"
}

variable "environment" {
  description = "Environment label for cost allocation"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner label for cost allocation"
  type        = string
  default     = "FinOpsTeam"
}

variable "cost_center" {
  description = "Cost center label for cost allocation"
  type        = string
  default     = "lab"
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

variable "app_source_ranges" {
  description = "Trusted CIDRs allowed to reach port 8000"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.app_source_ranges) > 0
    error_message = "Set app_source_ranges to at least one trusted CIDR (e.g. 203.0.113.10/32)."
  }

  validation {
    condition = alltrue([
      for c in var.app_source_ranges : c != "0.0.0.0/0" && c != "::/0"
    ])
    error_message = "Do not use 0.0.0.0/0 or ::/0; specify trusted source CIDRs only."
  }
}

variable "ssh_source_ranges" {
  description = "Trusted CIDRs allowed for SSH"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.ssh_source_ranges) > 0
    error_message = "Set ssh_source_ranges to at least one trusted CIDR (e.g. 203.0.113.10/32)."
  }

  validation {
    condition = alltrue([
      for c in var.ssh_source_ranges : c != "0.0.0.0/0" && c != "::/0"
    ])
    error_message = "Do not use 0.0.0.0/0 or ::/0; specify trusted source CIDRs only."
  }
}
