locals {
  # GCP label values: lowercase letters, numerals, hyphens; max 63 chars
  finops_labels = {
    environment = lower(replace(var.environment, "_", "-"))
    project     = lower(replace(var.project_name, "_", "-"))
    owner       = lower(replace(var.owner, "_", "-"))
    cost_center = lower(replace(var.cost_center, "_", "-"))
  }
}

resource "google_compute_network" "lab" {
  name                    = "${var.project_name}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.project_name}-allow-ssh"
  network = google_compute_network.lab.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = [var.project_name]
}

resource "google_compute_firewall" "app" {
  name    = "${var.project_name}-allow-8000"
  network = google_compute_network.lab.name

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = var.app_source_ranges
  target_tags   = [var.project_name]
}

resource "google_compute_instance" "lab" {
  name         = "${var.project_name}-vm"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  tags = [var.project_name]

  labels = local.finops_labels

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.boot_disk_size_gb
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.lab.name
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }

  scheduling {
    preemptible       = false
    automatic_restart = true
  }
}
