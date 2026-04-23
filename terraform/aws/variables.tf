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
  description = "EC2 instance type (default is cost-efficient for light lab workloads)"
  type        = string
  default     = "t3a.nano"
}

variable "vpc_cidr" {
  description = "CIDR for the dedicated lab VPC (isolated from default VPC)"
  type        = string
  default     = "10.50.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for a single public subnet in the lab VPC"
  type        = string
  default     = "10.50.1.0/24"
}

variable "ssh_cidr_blocks" {
  description = "Trusted CIDRs for SSH (must not be 0.0.0.0/0); use your IP /32 or VPN range"
  type        = list(string)
  validation {
    condition = alltrue([
      for c in var.ssh_cidr_blocks : !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "ssh_cidr_blocks must not use 0.0.0.0/0 or ::/0; set a trusted range (e.g. 203.0.113.4/32)."
  }
}

variable "app_cidr_blocks" {
  description = "Trusted CIDRs for app port 8000 (often same as SSH); must not be open to the world"
  type        = list(string)
  validation {
    condition = alltrue([
      for c in var.app_cidr_blocks : !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "app_cidr_blocks must not use 0.0.0.0/0 or ::/0; set a trusted range."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}

variable "cost_allocation_tags" {
  description = "Standard tags for cost allocation (applied to all taggable resources)"
  type = object({
    Environment = string
    Project     = string
    Owner       = string
    CostCenter  = string
  })
  default = {
    Environment = "lab"
    Project     = "cloud-cost-lab"
    Owner       = "unset"
    CostCenter  = "finops-lab"
  }
}

variable "extra_tags" {
  description = "Optional additional tags merged into common_tags"
  type        = map(string)
  default     = {}
}
