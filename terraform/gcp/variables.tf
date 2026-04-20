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
  description = "Trusted CIDRs for port 8000 (never use 0.0.0.0/0 for SSH; app may use LB/WAF for public access)"
  type        = list(string)

  validation {
    condition     = length(var.app_source_ranges) > 0 && !contains(var.app_source_ranges, "0.0.0.0/0") && !contains(var.app_source_ranges, "::/0")
    error_message = "app_source_ranges must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "ssh_source_ranges" {
  description = "Trusted CIDRs for SSH (never use 0.0.0.0/0; prefer IAP or OS Login)"
  type        = list(string)

  validation {
    condition     = length(var.ssh_source_ranges) > 0 && !contains(var.ssh_source_ranges, "0.0.0.0/0") && !contains(var.ssh_source_ranges, "::/0")
    error_message = "ssh_source_ranges must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "environment" {
  description = "Environment name for cost allocation labels"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner contact for cost allocation labels"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center identifier for cost allocation labels"
  type        = string
  default     = "unset"
}

variable "extra_labels" {
  description = "Additional labels merged into labelable resources"
  type        = map(string)
  default     = {}
}
