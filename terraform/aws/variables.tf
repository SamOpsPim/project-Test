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

variable "environment" {
  description = "Deployment environment (cost allocation / governance tag)"
  type        = string
  default     = "development"
}

variable "owner" {
  description = "Team or owner contact (cost allocation tag)"
  type        = string
  default     = "unassigned"
}

variable "cost_center" {
  description = "Cost center or chargeback code"
  type        = string
  default     = "unassigned"
}

variable "root_volume_size_gb" {
  description = "Root gp3 volume size in GB (rightsizing: set to expected usage plus headroom)"
  type        = number
  default     = 16

  validation {
    condition     = var.root_volume_size_gb >= 8 && var.root_volume_size_gb <= 16384
    error_message = "root_volume_size_gb must be between 8 and 16384."
  }
}

variable "ssh_cidr_blocks" {
  description = "CIDRs allowed for SSH and app port 8000. Must not be open internet; use e.g. [\"203.0.113.10/32\"] or your office/VPN range."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition = length(var.ssh_cidr_blocks) > 0 && !contains(var.ssh_cidr_blocks, "0.0.0.0/0") && !contains(var.ssh_cidr_blocks, "::/0")
    error_message = "ssh_cidr_blocks must be non-empty and must not include 0.0.0.0/0 or ::/0 (use specific CIDRs)."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
