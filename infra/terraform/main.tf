terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-ai-infra-uksouth"
    storage_account_name = "sttfstateaiinfraadeeb"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project     = "azure-ai-infra-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    project     = "azure-ai-infra-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    project     = "azure-ai-infra-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_container_app_environment" "main" {
  name                       = var.container_app_environment_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = {
    project     = "azure-ai-infra-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_user_assigned_identity" "container_app" {
  name                = "id-ai-infra-containerapp-dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project     = "azure-ai-infra-platform"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}

resource "azurerm_container_app" "sample" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_app.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_app.id
  }

  template {
    container {
      name   = "sample-workload"
      image  = "${azurerm_container_registry.main.login_server}/${var.container_image_name}"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    project     = "azure-ai-infra-platform"
    environment = "dev"
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_role_assignment.acr_pull
  ]
}
