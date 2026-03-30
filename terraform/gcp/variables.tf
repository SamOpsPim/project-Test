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
  description = "CIDRs allowed to reach port 8000 – must be explicitly set to specific IP ranges (no default to prevent accidental public exposure)"
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.app_source_ranges : cidr != "0.0.0.0/0"])
    error_message = "app_source_ranges must not contain 0.0.0.0/0. Restrict access to specific IP addresses or ranges (e.g. [\"203.0.113.10/32\"])."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH – must be explicitly set to specific IP ranges (no default to prevent accidental public exposure)"
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.ssh_source_ranges : cidr != "0.0.0.0/0"])
    error_message = "ssh_source_ranges must not contain 0.0.0.0/0. Restrict access to specific IP addresses or ranges (e.g. [\"203.0.113.10/32\"])."
  }
}

variable "environment" {
  description = "Deployment environment (e.g. lab, dev, staging, production)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner of the resources for cost allocation and accountability"
  type        = string
  default     = "devops"
}

variable "cost_center" {
  description = "Cost center for billing and cost allocation"
  type        = string
  default     = ""
}

variable "extra_labels" {
  description = "Additional labels to apply to all resources"
  type        = map(string)
  default     = {}
}
