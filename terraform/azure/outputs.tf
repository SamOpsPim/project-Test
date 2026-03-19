output "public_ip_address" {
  description = "Public IP of the lab VM"
  value       = azurerm_public_ip.lab.ip_address
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.lab.name
}

output "ssh_command" {
  description = "Example SSH"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.lab.ip_address}"
}
