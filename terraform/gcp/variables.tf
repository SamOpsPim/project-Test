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
  description = "CIDRs allowed to reach port 8000. Replace default placeholder with your trusted CIDRs before apply."
  type        = list(string)
  default     = ["203.0.113.10/32"]

  validation {
    condition     = length([for c in var.app_source_ranges : c if c == "0.0.0.0/0"]) == 0
    error_message = "app_source_ranges must not include 0.0.0.0/0; use specific trusted CIDRs only."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH. Replace default placeholder with your trusted CIDRs before apply."
  type        = list(string)
  default     = ["203.0.113.10/32"]

  validation {
    condition     = length([for c in var.ssh_source_ranges : c if c == "0.0.0.0/0"]) == 0
    error_message = "ssh_source_ranges must not include 0.0.0.0/0; use specific trusted CIDRs only."
  }
}

variable "cost_allocation_labels" {
  description = "Labels on GCP resources for cost allocation (FinOps). Keys must be lowercase letters, digits, or underscores."
  type        = map(string)
  default = {
    environment = "lab"
    owner       = "unset"
    project     = "cloud-anomaly-lab"
    cost_center = "unset"
  }
}
