resource "azurerm_monitor_action_group" "platform_alerts" {
  name                = "ag-ai-infra-platform-dev"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "aiinfra"

  tags = local.common_tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "container_app_revision_failure" {
  name                = "alert-container-app-revision-failure-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  scopes               = [azurerm_log_analytics_workspace.main.id]
  description          = "Alert when Azure Container Apps system logs indicate a revision or platform failure."
  severity             = 2
  enabled              = true
  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"

  criteria {
    query = <<-KQL
      ContainerAppSystemLogs_CL
      | where ContainerAppName_s == "${azurerm_container_app.sample.name}"
      | where Reason_s in ("FailedMount", "ReplicaUnhealthy")
      | summarize FailureCount = count()
    KQL

    time_aggregation_method = "Total"
    metric_measure_column   = "FailureCount"
    operator                = "GreaterThan"
    threshold               = 0
  }

  action {
    action_groups = [azurerm_monitor_action_group.platform_alerts.id]
  }

  tags = local.common_tags
}
