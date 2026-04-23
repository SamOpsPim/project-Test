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

variable "trusted_ingress_cidrs" {
  description = "Trusted CIDRs for SSH (22) and app (8000). Use your public IP /32 or a trusted range — never 0.0.0.0/0 in production."
  type        = list(string)
  nullable    = false

  validation {
    condition = length(var.trusted_ingress_cidrs) > 0 && !contains(var.trusted_ingress_cidrs, "0.0.0.0/0") && !contains(var.trusted_ingress_cidrs, "::/0")

    error_message = "trusted_ingress_cidrs must be non-empty and must not allow the entire Internet (0.0.0.0/0 or ::/0)."
  }
}

variable "lab_enabled" {
  description = "Set true only when you intend to deploy this stack. Keeps accidental apply from creating billable resources."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment label for cost allocation"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner label for cost allocation"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center label for cost allocation"
  type        = string
  default     = "engineering"
}

variable "application" {
  description = "Application label for cost allocation"
  type        = string
  default     = "cloud-anomaly-lab"
}
