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
  description = "Environment label for cost allocation (GCP labels are lowercase)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team responsible for this infrastructure (cost allocation)"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center or chargeback code for FinOps labeling"
  type        = string
  default     = "unallocated"
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

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "app_source_ranges" {
  description = "Trusted CIDRs allowed to reach port 8000 (e.g. [\"203.0.113.10/32\"]). Must not be open to the entire internet."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.app_source_ranges) > 0 && !contains(var.app_source_ranges, "0.0.0.0/0") && !contains(var.app_source_ranges, "::/0")
    error_message = "Set app_source_ranges to at least one trusted CIDR. 0.0.0.0/0 and ::/0 are not allowed."
  }
}

variable "ssh_source_ranges" {
  description = "Trusted CIDRs allowed for SSH (e.g. [\"203.0.113.10/32\"]). Must not be open to the entire internet."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.ssh_source_ranges) > 0 && !contains(var.ssh_source_ranges, "0.0.0.0/0") && !contains(var.ssh_source_ranges, "::/0")
    error_message = "Set ssh_source_ranges to at least one trusted CIDR. 0.0.0.0/0 and ::/0 are not allowed."
  }
}
