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
  description = "EC2 instance type. Terraform keeps the instance running when applied; if you only need it intermittently, stop it between sessions or use AWS Instance Scheduler so usage matches intent."
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr_blocks" {
  description = "CIDRs allowed for SSH and app port 8000. Replace the default documentation placeholder (203.0.113.10/32) with your office IP, VPN range, or /32 of your public IP before apply."
  type        = list(string)
  default     = ["203.0.113.10/32"]

  validation {
    condition     = length([for c in var.ssh_cidr_blocks : c if c == "0.0.0.0/0"]) == 0
    error_message = "ssh_cidr_blocks must not include 0.0.0.0/0; use specific trusted CIDRs only."
  }
}

variable "cost_allocation_tags" {
  description = "Tags applied to billable resources for cost allocation (FinOps). Keys are lowercase for compatibility with GCP labels when mirrored."
  type        = map(string)
  default = {
    environment = "lab"
    owner       = "unset"
    project     = "cloud-anomaly-lab"
    cost_center = "unset"
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
