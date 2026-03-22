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
  description = "CIDRs allowed for SSH and app port — must be explicitly set to a restricted range"
  type        = list(string)

  validation {
    condition     = !contains(var.ssh_cidr_blocks, "0.0.0.0/0")
    error_message = "Unrestricted access (0.0.0.0/0) is not allowed. Specify trusted CIDR blocks, e.g. [\"203.0.113.10/32\"]."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags applied to all AWS resources for cost allocation and management"
  type        = map(string)
  default = {
    Project     = "cloud-anomaly-lab"
    Environment = "lab"
    Owner       = "devops-team"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}
