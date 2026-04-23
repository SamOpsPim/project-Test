output "instance_external_ip" {
  description = "External IP of the lab VM"
  value       = google_compute_instance.lab.network_interface[0].access_config[0].nat_ip
}

output "instance_name" {
  description = "GCE instance name"
  value       = google_compute_instance.lab.name
}

output "ssh_command" {
  description = "Example gcloud SSH"
  value       = "gcloud compute ssh ${var.ssh_user}@${google_compute_instance.lab.name} --zone=${var.gcp_zone} --project=${var.gcp_project_id}"
}
