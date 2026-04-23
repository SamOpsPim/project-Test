output "instance_external_ip" {
  description = "External IP of the lab VM (null when lab_enabled is false)"
  value       = var.lab_enabled ? google_compute_instance.lab[0].network_interface[0].access_config[0].nat_ip : null
}

output "instance_name" {
  description = "GCE instance name (null when lab_enabled is false)"
  value       = var.lab_enabled ? google_compute_instance.lab[0].name : null
}

output "ssh_command" {
  description = "Example gcloud SSH (null when lab_enabled is false)"
  value       = var.lab_enabled ? "gcloud compute ssh ${var.ssh_user}@${google_compute_instance.lab[0].name} --zone=${var.gcp_zone} --project=${var.gcp_project_id}" : null
}
