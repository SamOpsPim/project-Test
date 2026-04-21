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
  description = "EC2 instance type (override after monitoring if you need more capacity)"
  type        = string
  default     = "t3.nano"
}

variable "environment" {
  description = "Environment label for cost allocation"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner label for cost allocation"
  type        = string
  default     = "FinOpsTeam"
}

variable "cost_center" {
  description = "Cost center label for cost allocation"
  type        = string
  default     = "lab"
}

variable "ssh_cidr_blocks" {
  description = "Trusted CIDRs allowed for SSH and app port 8000 (must not be open internet)"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.ssh_cidr_blocks) > 0
    error_message = "Set ssh_cidr_blocks to at least one trusted CIDR (e.g. your office or home /32)."
  }

  validation {
    condition = alltrue([
      for c in var.ssh_cidr_blocks : c != "0.0.0.0/0" && c != "::/0"
    ])
    error_message = "Do not use 0.0.0.0/0 or ::/0; specify trusted source CIDRs only."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
