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

variable "vpc_cidr" {
  description = "CIDR for the dedicated lab VPC (isolated from the account default VPC)"
  type        = string
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet in the first availability zone"
  type        = string
  default     = "10.42.1.0/24"
}

variable "ssh_cidr_blocks" {
  description = "CIDRs allowed for SSH (set to your IP /32 or VPN range; never use 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition = alltrue([
      for c in var.ssh_cidr_blocks :
      !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "ssh_cidr_blocks must not use open CIDRs 0.0.0.0/0 or ::/0. Set explicit trusted CIDRs (e.g. your public IP /32)."
  }
}

variable "app_cidr_blocks" {
  description = "CIDRs allowed for TCP port 8000 (set to your IP /32 or VPN range; never use 0.0.0.0/0)"
  type        = list(string)

  validation {
    condition = alltrue([
      for c in var.app_cidr_blocks :
      !contains(["0.0.0.0/0", "::/0"], c)
    ])
    error_message = "app_cidr_blocks must not use open CIDRs 0.0.0.0/0 or ::/0. Set explicit trusted CIDRs (e.g. your public IP /32)."
  }
}

variable "common_tags" {
  description = "Cost allocation and governance tags applied to all supported resources (Project is set automatically from project_name)"
  type        = map(string)
  default = {
    Environment = "lab"
    CostCenter  = "devops"
    Owner       = "platform"
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
