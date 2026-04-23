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
  description = "CIDRs allowed to reach port 8000. Required; avoid 0.0.0.0/0 in production."
  type        = list(string)
}

variable "ssh_source_ranges" {
  description = "CIDRs allowed for SSH. Required; avoid 0.0.0.0/0 in production."
  type        = list(string)
}

variable "environment" {
  description = "Environment label for cost allocation (e.g. dev, staging, prod)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner label for cost allocation (team or contact)"
  type        = string
  default     = "platform"
}

variable "cost_center" {
  description = "Cost center for chargeback and FinOps reporting"
  type        = string
  default     = "engineering"
}
