variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-ai-infra-dev-uksouth"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "uksouth"
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry. Must be globally unique and contain only letters and numbers."
  type        = string
  default     = "acraiinfraadeebdev"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  default     = "log-ai-infra-dev-uksouth"
}

variable "container_app_environment_name" {
  description = "Name of the Azure Container Apps Environment"
  type        = string
  default     = "cae-ai-infra-dev-uksouth"
}

variable "container_app_name" {
  description = "Name of the Azure Container App"
  type        = string
  default     = "ca-ai-infra-sample-dev"
}

variable "container_image_name" {
  description = "Container image name and tag"
  type        = string
  default     = "azure-ai-infra-platform:v1"
}
