locals {
  # GCP label values: lowercase letters, numerals, hyphens, underscores; max 63 chars.
  gcp_label_value = {
    project_name = substr(replace(replace(replace(lower(var.project_name), " ", "-"), ".", "-"), "/", "-"), 0, 63)
    environment  = substr(replace(replace(replace(lower(var.environment), " ", "-"), ".", "-"), "/", "-"), 0, 63)
    owner        = substr(replace(replace(replace(replace(lower(var.owner), " ", "-"), ".", "-"), "@", "-"), "/", "-"), 0, 63)
    cost_center  = substr(replace(replace(replace(lower(var.cost_center), " ", "-"), ".", "-"), "/", "-"), 0, 63)
    application  = substr(replace(replace(replace(lower(var.application), " ", "-"), ".", "-"), "/", "-"), 0, 63)
  }
}

resource "google_compute_network" "lab" {
  count                   = var.lab_enabled ? 1 : 0
  name                    = "${var.project_name}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "ssh" {
  count   = var.lab_enabled ? 1 : 0
  name    = "${var.project_name}-allow-ssh"
  network = google_compute_network.lab[0].name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.trusted_ingress_cidrs
  target_tags   = [var.project_name]
}

resource "google_compute_firewall" "app" {
  count   = var.lab_enabled ? 1 : 0
  name    = "${var.project_name}-allow-8000"
  network = google_compute_network.lab[0].name

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = var.trusted_ingress_cidrs
  target_tags   = [var.project_name]
}

resource "google_compute_instance" "lab" {
  count        = var.lab_enabled ? 1 : 0
  name         = "${var.project_name}-vm"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  tags = [var.project_name]

  labels = {
    project_name = local.gcp_label_value.project_name
    environment  = local.gcp_label_value.environment
    owner        = local.gcp_label_value.owner
    cost_center  = local.gcp_label_value.cost_center
    application  = local.gcp_label_value.application
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.lab[0].name
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
