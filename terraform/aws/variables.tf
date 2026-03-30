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
  description = "CIDRs allowed for SSH and app port – must be explicitly set to specific IP ranges (no default to prevent accidental public exposure)"
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.ssh_cidr_blocks : cidr != "0.0.0.0/0"])
    error_message = "ssh_cidr_blocks must not contain 0.0.0.0/0. Restrict access to specific IP addresses or ranges (e.g. [\"203.0.113.10/32\"])."
  }
}

variable "environment" {
  description = "Deployment environment (e.g. lab, dev, staging, production)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner of the resources for cost allocation and accountability"
  type        = string
  default     = "devops"
}

variable "cost_center" {
  description = "Cost center for billing and cost allocation"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
