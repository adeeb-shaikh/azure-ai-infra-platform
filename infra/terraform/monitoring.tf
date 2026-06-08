resource "azurerm_monitor_action_group" "platform_alerts" {
  name                = "ag-ai-infra-platform-dev"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "aiinfra"

  tags = local.common_tags
}

