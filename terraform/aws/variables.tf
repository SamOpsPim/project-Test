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

variable "trusted_cidr_blocks_ssh" {
  description = "CIDRs allowed for SSH (port 22). Do not use 0.0.0.0/0; use your office or home IP with /32."
  type        = list(string)

  validation {
    condition     = length(var.trusted_cidr_blocks_ssh) > 0 && !contains(var.trusted_cidr_blocks_ssh, "0.0.0.0/0") && !contains(var.trusted_cidr_blocks_ssh, "::/0")
    error_message = "trusted_cidr_blocks_ssh must be non-empty and must not use 0.0.0.0/0 or ::/0 (open internet)."
  }
}

variable "trusted_cidr_blocks_app" {
  description = "CIDRs allowed for the lab app on port 8000. Do not use 0.0.0.0/0; use your office or home IP with /32."
  type        = list(string)

  validation {
    condition     = length(var.trusted_cidr_blocks_app) > 0 && !contains(var.trusted_cidr_blocks_app, "0.0.0.0/0") && !contains(var.trusted_cidr_blocks_app, "::/0")
    error_message = "trusted_cidr_blocks_app must be non-empty and must not use 0.0.0.0/0 or ::/0 (open internet)."
  }
}

variable "environment" {
  description = "Environment tag for cost allocation (e.g. lab, dev, prod)"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner tag for cost allocation and accountability"
  type        = string
  default     = "unset"
}

variable "cost_center" {
  description = "Cost center tag for FinOps chargeback"
  type        = string
  default     = "unset"
}

variable "additional_tags" {
  description = "Extra tags merged onto all taggable AWS resources"
  type        = map(string)
  default     = {}
}

variable "enable_instance_schedule" {
  description = "When true, EventBridge Scheduler stops the instance on weekday evenings and starts it weekday mornings (UTC) to reduce idle compute cost."
  type        = bool
  default     = true
}

variable "instance_schedule_timezone" {
  description = "IANA timezone for stop/start schedule expressions (e.g. Europe/Dublin)"
  type        = string
  default     = "UTC"
}

variable "instance_stop_schedule" {
  description = "EventBridge Scheduler expression for weekday stop (default ~end of business UTC)"
  type        = string
  default     = "cron(0 19 ? * MON-FRI *)"
}

variable "instance_start_schedule" {
  description = "EventBridge Scheduler expression for weekday start (default ~morning UTC)"
  type        = string
  default     = "cron(0 7 ? * MON-FRI *)"
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}
