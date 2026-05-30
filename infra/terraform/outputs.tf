output "resource_group_name" {
  description = "The name of the created Resource Group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The Azure region of the Resource Group"
  value       = azurerm_resource_group.main.location
}

