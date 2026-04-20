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

variable "ssh_cidr_blocks" {
  description = "Trusted CIDRs for SSH (never use 0.0.0.0/0; prefer Session Manager for broad access)"
  type        = list(string)

  validation {
    condition     = length(var.ssh_cidr_blocks) > 0 && !contains(var.ssh_cidr_blocks, "0.0.0.0/0") && !contains(var.ssh_cidr_blocks, "::/0")
    error_message = "ssh_cidr_blocks must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "app_cidr_blocks" {
  description = "Trusted CIDRs for app port 8000; if null, uses ssh_cidr_blocks"
  type        = list(string)
  default     = null

  validation {
    condition = var.app_cidr_blocks == null || (
      length(var.app_cidr_blocks) > 0 &&
      !contains(var.app_cidr_blocks, "0.0.0.0/0") &&
      !contains(var.app_cidr_blocks, "::/0")
    )
    error_message = "When set, app_cidr_blocks must be non-empty and must not include 0.0.0.0/0 or ::/0."
  }
}

variable "environment" {
  description = "Environment name for cost allocation tags"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner contact for cost allocation tags"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center identifier for cost allocation tags"
  type        = string
  default     = "unset"
}

variable "extra_tags" {
  description = "Additional tags merged into all taggable resources"
  type        = map(string)
  default     = {}
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
