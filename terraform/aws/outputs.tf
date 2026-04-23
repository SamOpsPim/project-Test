output "instance_public_ip" {
  description = "Public IPv4 of the lab instance"
  value       = aws_instance.lab.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.lab.id
}

output "ssh_command" {
  description = "Example SSH (user: ubuntu on official Ubuntu AMI)"
  value       = "ssh -i <your-private-key.pem> ubuntu@${aws_instance.lab.public_ip}"
}

output "instance_schedule_enabled" {
  description = "Whether EventBridge Scheduler stop/start is enabled for this instance"
  value       = var.enable_instance_schedule
}
