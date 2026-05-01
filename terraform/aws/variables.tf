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
  description = "Environment tag for cost allocation"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag for cost allocation"
  type        = string
  default     = "finops-team"
}

variable "ssh_cidr_blocks" {
  description = "Trusted CIDRs for SSH and app port 8000 (e.g. [\"203.0.113.10/32\"]). Must be set in terraform.tfvars; open internet CIDRs are rejected."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.ssh_cidr_blocks) > 0 && length([
      for c in var.ssh_cidr_blocks : c
      if c == "0.0.0.0/0" || c == "::/0"
    ]) == 0
    error_message = "ssh_cidr_blocks must be non-empty and must not use 0.0.0.0/0 or ::/0. Set trusted ranges in terraform.tfvars (e.g. your public IP /32)."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
