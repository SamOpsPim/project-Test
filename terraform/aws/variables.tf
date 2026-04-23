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
  description = "CIDRs allowed for SSH and app port 8000. Do not use 0.0.0.0/0 in production; use your VPN or /32 admin IPs."
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

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
