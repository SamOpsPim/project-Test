terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone

  default_labels = merge(
    {
      environment = var.environment
      owner       = var.owner
      cost_center = var.cost_center
      project     = var.project_name
    },
    var.additional_labels,
  )
}
