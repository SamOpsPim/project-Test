variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Cost allocation / lifecycle tag (Environment)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Cost allocation tag (Owner); use team or individual identifier"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost allocation tag (CostCenter)"
  type        = string
  default     = "unset"
}

variable "application" {
  description = "Cost allocation tag (Application)"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "ssh_cidr_blocks" {
  description = "Non-open CIDRs allowed for SSH (e.g. [\"203.0.113.10/32\"]). Never use 0.0.0.0/0 for SSH."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.ssh_cidr_blocks) > 0 &&
      !contains(var.ssh_cidr_blocks, "0.0.0.0/0") &&
      !contains(var.ssh_cidr_blocks, "::/0")
    )
    error_message = "ssh_cidr_blocks must be non-empty and must not use 0.0.0.0/0 or ::/0. Set explicit trusted CIDRs (e.g. your public IP /32)."
  }
}

variable "app_cidr_blocks" {
  description = "CIDRs allowed to reach TCP 8000 (e.g. same as SSH or a corporate range). Avoid 0.0.0.0/0 unless you intentionally need a public app."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.app_cidr_blocks) > 0 &&
      !contains(var.app_cidr_blocks, "0.0.0.0/0") &&
      !contains(var.app_cidr_blocks, "::/0")
    )
    error_message = "app_cidr_blocks must be non-empty and must not use 0.0.0.0/0 or ::/0. Set explicit trusted CIDRs."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
