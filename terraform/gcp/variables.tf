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

variable "app_source_ranges" {
  description = "CIDRs allowed to reach port 8000 (required; never use 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition     = length(var.app_source_ranges) > 0 && !contains(var.app_source_ranges, "0.0.0.0/0") && !contains(var.app_source_ranges, "::/0")
    error_message = "app_source_ranges must be non-empty and must not use 0.0.0.0/0 or ::/0 (open internet)."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH (required; never use 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition     = length(var.ssh_source_ranges) > 0 && !contains(var.ssh_source_ranges, "0.0.0.0/0") && !contains(var.ssh_source_ranges, "::/0")
    error_message = "ssh_source_ranges must be non-empty and must not use 0.0.0.0/0 or ::/0 (open internet)."
  }
}

variable "environment" {
  description = "Environment label for cost allocation (lowercase; GCP label rules)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner label for cost allocation"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center label for FinOps chargeback"
  type        = string
  default     = "unset"
}

variable "additional_labels" {
  description = "Extra labels merged with provider default_labels (keys must satisfy GCP label rules: lowercase, etc.)"
  type        = map(string)
  default     = {}
}
