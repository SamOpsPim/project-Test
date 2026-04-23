output "public_ip_address" {
  description = "Public IP of the lab VM (null when lab_enabled is false)"
  value       = var.lab_enabled ? azurerm_public_ip.lab[0].ip_address : null
}

output "resource_group_name" {
  description = "Resource group name (null when lab_enabled is false)"
  value       = var.lab_enabled ? azurerm_resource_group.lab[0].name : null
}

output "ssh_command" {
  description = "Example SSH (null when lab_enabled is false)"
  value       = var.lab_enabled ? "ssh ${var.admin_username}@${azurerm_public_ip.lab[0].ip_address}" : null
}
