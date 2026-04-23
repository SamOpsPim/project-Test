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
  description = "CIDRs allowed for SSH and app port 8000. Override with your office or VPN CIDRs (e.g. 203.0.113.10/32); default is localhost-only and blocks remote access until set."
  type        = list(string)
  default     = ["127.0.0.1/32"]
}

variable "environment" {
  description = "Environment label for cost allocation (e.g. lab, staging, prod)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owning team or contact for cost allocation"
  type        = string
  default     = "platform"
}

variable "cost_center" {
  description = "Cost center for chargeback and FinOps reporting"
  type        = string
  default     = "engineering"
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
