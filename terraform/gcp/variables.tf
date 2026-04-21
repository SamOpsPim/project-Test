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
  description = "CIDRs allowed to reach port 8000. Must not be open to the world."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.app_source_ranges) > 0
    error_message = "app_source_ranges must contain at least one CIDR (e.g. [\"203.0.113.10/32\"])."
  }

  validation {
    condition = alltrue([
      for c in var.app_source_ranges : !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "app_source_ranges must not include 0.0.0.0/0 or ::/0."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH. Must not be open to the world."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.ssh_source_ranges) > 0
    error_message = "ssh_source_ranges must contain at least one CIDR (e.g. [\"203.0.113.10/32\"])."
  }

  validation {
    condition = alltrue([
      for c in var.ssh_source_ranges : !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "ssh_source_ranges must not include 0.0.0.0/0 or ::/0."
  }
}

variable "extra_labels" {
  description = "Optional extra labels merged with default cost-allocation labels"
  type        = map(string)
  default     = {}
}
