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

output "cloudwatch_cpu_high_alarm" {
  description = "CloudWatch alarm name for high CPU utilization"
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}

output "cloudwatch_cpu_low_alarm" {
  description = "CloudWatch alarm name for low CPU utilization (rightsizing opportunity)"
  value       = aws_cloudwatch_metric_alarm.cpu_low.alarm_name
}
