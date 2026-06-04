# Runbook

## Purpose

This runbook describes how to operate, verify, and troubleshoot the Level 1 Azure Cloud-Native Infrastructure Platform.

The goal is to provide enough information for another engineer to deploy, validate, and troubleshoot the platform.

## Scope

This runbook applies to Level 1 of the platform engineering project.

Current scope includes:

- Terraform-managed Azure infrastructure
- Azure Container Apps
- Azure Container Registry
- Remote Terraform state
- GitHub Actions CI/CD
- Azure OIDC authentication
- Log Analytics integration

Observability extensions and AI infrastructure components are intentionally excluded from this runbook and will be documented in later project levels.
---

# Prerequisites

Required tools:

- Azure CLI
- Terraform
- Docker
- Git
- GitHub account access
- WSL/Linux shell

---

# Verify Azure Authentication

Confirm Azure authentication:

```bash
az account show
```

Expected result:

```text
Subscription information displayed
```

---

# Verify Terraform State

Move into Terraform directory:

```bash
cd infra/terraform
```

Initialize Terraform:

```bash
terraform init
```

Verify state:

```bash
terraform state list
```

Verify infrastructure matches configuration:

```bash
terraform plan
```

Expected result:

```text
No changes. Infrastructure matches configuration.
```

---

# Deploy Infrastructure

Review execution plan:

```bash
terraform plan
```

Apply changes:

```bash
terraform apply
```

---

# Verify Container App

Check deployment:

```bash
az containerapp show \
  --name ca-ai-infra-sample-dev \
  --resource-group rg-ai-infra-dev-uksouth \
  --output table
```

Expected result:

```text
ProvisioningState = Succeeded
RunningStatus = Running
```

---

# Get Application URL

```bash
terraform output -raw container_app_url
```

---

# Verify Application Health

Root endpoint:

```bash
curl $(terraform output -raw container_app_url)
```

Health endpoint:

```bash
curl $(terraform output -raw container_app_url)/health
```

Expected response:

```json
{
  "status": "healthy"
}
```

---

# Verify GitHub Actions

Required workflows:

- Terraform Validate
- Terraform Plan
- Terraform Apply
- Docker Build

Verify latest runs:

GitHub → Actions

Expected:

```text
Successful workflow executions
```

---

# Query Container App Logs

Retrieve workspace ID:

```bash
az monitor log-analytics workspace show \
  --resource-group rg-ai-infra-dev-uksouth \
  --workspace-name log-ai-infra-dev-uksouth \
  --query customerId \
  --output tsv
```

Query system logs:

```bash
az monitor log-analytics query \
  --workspace <WORKSPACE_ID> \
  --analytics-query "ContainerAppSystemLogs_CL | take 20" \
  --output table
```

Query application logs:

```bash
az monitor log-analytics query \
  --workspace <WORKSPACE_ID> \
  --analytics-query "ContainerAppConsoleLogs_CL | take 20" \
  --output table
```

---

# Rollback Procedure

Terraform changes:

```bash
git revert <commit>
git push
```

Run:

```bash
terraform plan
terraform apply
```

Container image rollback:

Update image version in Terraform configuration and redeploy.

---

# Cost Control

For long periods of inactivity:

```bash
terraform destroy
```

Keep:

- GitHub repository
- Terraform code
- Documentation

Destroy:

- Container App
- Container Apps Environment
- Log Analytics
- ACR (optional)

---

# Common Issues

## Terraform attempts to recreate existing resources

Cause:

Terraform is not reading the correct remote state.

Check:

```bash
terraform state list
```

---

## GitHub OIDC authentication failure

Verify:

- AZURE_CLIENT_ID
- AZURE_TENANT_ID
- AZURE_SUBSCRIPTION_ID

exist in GitHub Secrets.

---

## Terraform backend access failure

Verify GitHub identity has:

- Reader
- Storage Blob Data Contributor

on the Terraform state storage account.

---

## Docker push failure

Verify ACR login:

```bash
az acr login --name acraiinfraadeebdev
```

Verify repository:

```bash
az acr repository list \
  --name acraiinfraadeebdev \
  --output table
```
