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
  description = "CIDRs allowed to reach port 8000 — must be explicitly set to a restricted range"
  type        = list(string)

  validation {
    condition     = !contains(var.app_source_ranges, "0.0.0.0/0")
    error_message = "Unrestricted access (0.0.0.0/0) is not allowed. Specify trusted CIDR blocks, e.g. [\"203.0.113.10/32\"]."
  }
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH — must be explicitly set to a restricted range"
  type        = list(string)

  validation {
    condition     = !contains(var.ssh_source_ranges, "0.0.0.0/0")
    error_message = "Unrestricted access (0.0.0.0/0) is not allowed. Specify trusted CIDR blocks, e.g. [\"203.0.113.10/32\"]."
  }
}

variable "common_labels" {
  description = "Common labels applied to all GCP resources for cost allocation and management"
  type        = map(string)
  default = {
    project     = "cloud-anomaly-lab"
    environment = "lab"
    owner       = "devops-team"
    cost_center = "engineering"
    managed_by  = "terraform"
  }
}
