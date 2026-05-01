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

variable "environment" {
  description = "Environment label for cost allocation (GCP label format)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner label for cost allocation"
  type        = string
  default     = "finops-team"
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
  description = "Trusted CIDRs for port 8000 (e.g. [\"203.0.113.10/32\"]). Set in terraform.tfvars; open internet CIDRs are rejected."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.app_source_ranges) > 0 && length([
      for c in var.app_source_ranges : c
      if c == "0.0.0.0/0" || c == "::/0"
    ]) == 0
    error_message = "app_source_ranges must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}

variable "ssh_source_ranges" {
  description = "Trusted CIDRs for SSH (e.g. [\"203.0.113.10/32\"]). Set in terraform.tfvars; open internet CIDRs are rejected."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.ssh_source_ranges) > 0 && length([
      for c in var.ssh_source_ranges : c
      if c == "0.0.0.0/0" || c == "::/0"
    ]) == 0
    error_message = "ssh_source_ranges must be non-empty and must not use 0.0.0.0/0 or ::/0."
  }
}
