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
  description = "Trusted IPv4 CIDRs for port 8000. Required in terraform.tfvars; 0.0.0.0/0 is not allowed."
  type        = list(string)

  validation {
    condition = alltrue([
      length(var.app_source_ranges) > 0,
      !contains(var.app_source_ranges, "0.0.0.0/0"),
    ])
    error_message = "Set app_source_ranges to trusted CIDRs only; 0.0.0.0/0 is not allowed."
  }
}

variable "ssh_source_ranges" {
  description = "Trusted IPv4 CIDRs for SSH. Required in terraform.tfvars; 0.0.0.0/0 is not allowed."
  type        = list(string)

  validation {
    condition = alltrue([
      length(var.ssh_source_ranges) > 0,
      !contains(var.ssh_source_ranges, "0.0.0.0/0"),
    ])
    error_message = "Set ssh_source_ranges to trusted CIDRs only; 0.0.0.0/0 is not allowed."
  }
}

variable "tag_environment" {
  description = "environment label for cost allocation"
  type        = string
  default     = "dev"
}

variable "tag_project" {
  description = "project label (empty uses project_name)"
  type        = string
  default     = ""
}

variable "tag_owner" {
  description = "owner label for cost allocation"
  type        = string
  default     = "finops-lab"
}
