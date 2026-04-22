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

variable "environment" {
  description = "Cost allocation label (environment)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Cost allocation label (owner)"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost allocation label (cost_center)"
  type        = string
  default     = "unset"
}

variable "application" {
  description = "Cost allocation label (application)"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "ssh_public_key" {
  description = "SSH public key for instance login"
  type        = string
  sensitive   = true
}

variable "app_source_ranges" {
  description = "Non-open CIDRs for TCP 8000 (e.g. [\"203.0.113.10/32\"]). Never use 0.0.0.0/0 unless intentionally public."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.app_source_ranges) > 0 &&
      !contains(var.app_source_ranges, "0.0.0.0/0") &&
      !contains(var.app_source_ranges, "::/0")
    )
    error_message = "app_source_ranges must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}

variable "ssh_source_ranges" {
  description = "Non-open CIDRs for SSH. Never use 0.0.0.0/0."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.ssh_source_ranges) > 0 &&
      !contains(var.ssh_source_ranges, "0.0.0.0/0") &&
      !contains(var.ssh_source_ranges, "::/0")
    )
    error_message = "ssh_source_ranges must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}
