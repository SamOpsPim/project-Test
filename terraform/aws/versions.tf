terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.tag_environment
      Project     = var.tag_project != "" ? var.tag_project : var.project_name
      Owner       = var.tag_owner
    }
  }
}
