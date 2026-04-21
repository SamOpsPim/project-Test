terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  default_tags = merge(
    {
      Project     = var.project_name
      Environment = "lab"
      ManagedBy   = "terraform"
    },
    var.extra_tags
  )
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.default_tags
  }
}
