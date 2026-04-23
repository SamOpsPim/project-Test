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

variable "trusted_ingress_cidrs" {
  description = "Trusted CIDRs for SSH (22) and app (8000). Use your public IP /32, VPN, or office range — never 0.0.0.0/0 or ::/0 in production."
  type        = list(string)
  nullable    = false

  validation {
    condition = length(var.trusted_ingress_cidrs) > 0 && !contains(var.trusted_ingress_cidrs, "0.0.0.0/0") && !contains(var.trusted_ingress_cidrs, "::/0")

    error_message = "trusted_ingress_cidrs must be non-empty and must not allow the entire Internet (0.0.0.0/0 or ::/0)."
  }
}

variable "vpc_cidr" {
  description = "CIDR for the dedicated lab VPC (no NAT Gateway — public subnet + IGW only)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet hosting the lab instance"
  type        = string
  default     = "10.0.1.0/24"
}

variable "environment" {
  description = "Environment tag for cost allocation"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner tag for cost allocation"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center tag for cost allocation"
  type        = string
  default     = "engineering"
}

variable "application" {
  description = "Application tag for cost allocation"
  type        = string
  default     = "cloud-anomaly-lab"
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
