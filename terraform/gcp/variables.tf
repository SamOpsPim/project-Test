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
  description = "CIDRs allowed to reach port 8000 (never use 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition = alltrue([
      for c in var.app_source_ranges :
      !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "app_source_ranges must not use open CIDRs 0.0.0.0/0 or ::/0. Set explicit trusted CIDRs (e.g. your public IP /32)."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH (never use 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition = alltrue([
      for c in var.ssh_source_ranges :
      !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "ssh_source_ranges must not use open CIDRs 0.0.0.0/0 or ::/0. Set explicit trusted CIDRs (e.g. your public IP /32)."
  }
}

variable "common_tags" {
  description = "Cost allocation metadata; applied as Compute Engine labels (lowercased keys/values)"
  type        = map(string)
  default = {
    Environment = "lab"
    CostCenter  = "devops"
    Owner       = "platform"
  }
}
