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
  description = "EC2 instance type (default t3.nano for low steady-state cost when the lab is running)"
  type        = string
  default     = "t3.nano"
}

variable "ssh_cidr_blocks" {
  description = "Trusted IPv4 CIDRs for SSH and app port 8000. Must not be open internet (0.0.0.0/0); use your /32 or office/VPN range. Required — set in terraform.tfvars."
  type        = list(string)

  validation {
    condition = alltrue([
      length(var.ssh_cidr_blocks) > 0,
      !contains(var.ssh_cidr_blocks, "0.0.0.0/0"),
      !contains(var.ssh_cidr_blocks, "::/0"),
    ])
    error_message = "Set ssh_cidr_blocks to at least one trusted CIDR (e.g. your public IP /32). Inbound 0.0.0.0/0 and ::/0 are not allowed."
  }
}

variable "public_key" {
  description = "SSH public key material for EC2 access"
  type        = string
  sensitive   = true
}

variable "tag_environment" {
  description = "Value for the Environment cost allocation tag"
  type        = string
  default     = "dev"
}

variable "tag_project" {
  description = "Value for the Project cost allocation tag (empty uses project_name)"
  type        = string
  default     = ""
}

variable "tag_owner" {
  description = "Value for the Owner cost allocation tag"
  type        = string
  default     = "finops-lab"
}

variable "enable_instance_schedule" {
  description = "When true, EventBridge Scheduler stops and starts the lab instance on cron (reduces compute cost for intermittent use)"
  type        = bool
  default     = false
}

variable "instance_stop_schedule" {
  description = "Cron when to stop the instance (schedule timezone). Example: stop weekday evenings UTC."
  type        = string
  default     = "cron(0 20 * * ? *)" # 20:00 daily
}

variable "instance_start_schedule" {
  description = "Cron when to start the instance (schedule timezone). Example: start weekday mornings UTC."
  type        = string
  default     = "cron(0 8 * * ? *)" # 08:00 daily
}

variable "instance_schedule_timezone" {
  description = "IANA timezone for schedule expressions (e.g. Europe/Dublin)"
  type        = string
  default     = "UTC"
}
