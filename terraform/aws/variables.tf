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

variable "environment" {
  description = "Environment label for cost allocation (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team responsible for this infrastructure (cost allocation)"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center or chargeback code for FinOps tagging"
  type        = string
  default     = "unallocated"
}

variable "instance_type" {
  description = "EC2 instance type (t3.nano is a lower-cost default for light lab workloads)"
  type        = string
  default     = "t3.nano"
}

variable "root_volume_gb" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "ssh_cidr_blocks" {
  description = "Trusted CIDRs for SSH and app port 8000 (e.g. [\"203.0.113.10/32\"]). Must not be open to the entire internet."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.ssh_cidr_blocks) > 0 && !contains(var.ssh_cidr_blocks, "0.0.0.0/0") && !contains(var.ssh_cidr_blocks, "::/0")
    error_message = "Set ssh_cidr_blocks to at least one trusted CIDR (e.g. your public IP/32). 0.0.0.0/0 and ::/0 are not allowed."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
