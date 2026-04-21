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
  description = "CIDRs allowed for SSH (e.g. your office or VPN /32). Must not be open to the world."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.ssh_cidr_blocks) > 0
    error_message = "ssh_cidr_blocks must contain at least one CIDR (e.g. [\"203.0.113.10/32\"])."
  }

  validation {
    condition = alltrue([
      for c in var.ssh_cidr_blocks : !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "ssh_cidr_blocks must not include 0.0.0.0/0 or ::/0."
  }
}

variable "app_cidr_blocks" {
  description = "CIDRs allowed for FastAPI on port 8000. Use the same as ssh_cidr_blocks or a narrower range (e.g. internal load balancer CIDRs)."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.app_cidr_blocks) > 0
    error_message = "app_cidr_blocks must contain at least one CIDR (e.g. [\"203.0.113.10/32\"])."
  }

  validation {
    condition = alltrue([
      for c in var.app_cidr_blocks : !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "app_cidr_blocks must not include 0.0.0.0/0 or ::/0."
  }
}

variable "extra_tags" {
  description = "Optional extra tags merged with default cost-allocation tags"
  type        = map(string)
  default     = {}
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
