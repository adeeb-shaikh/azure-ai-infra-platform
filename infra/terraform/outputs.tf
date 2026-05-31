output "resource_group_name" {
  description = "The name of the created Resource Group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The Azure region of the Resource Group"
  value       = azurerm_resource_group.main.location
}

output "container_registry_name" {
  description = "The name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}

output "container_registry_login_server" {
  description = "The login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "container_app_environment_name" {
  description = "The name of the Container Apps Environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_app_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_name" {
  description = "Name of the deployed Container App"
  value       = azurerm_container_app.sample.name
}

output "container_app_url" {
  description = "Public URL of the Container App"
  value       = "https://${azurerm_container_app.sample.latest_revision_fqdn}"
}
