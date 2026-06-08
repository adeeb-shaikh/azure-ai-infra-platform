# Observability

## Purpose

This document describes the current observability capabilities of the Azure Cloud-Native Infrastructure Platform.

Current focus:

- Log collection
- Log investigation
- Operational troubleshooting

Future phases will add:

- Alerting
- Dashboards
- Metrics
- Incident response workflows

---

## Current Observability Components

### Log Analytics Workspace

Purpose:

Centralized collection of:

- Container application logs
- Container platform logs

### Azure Container Apps

Produces:

- Application console logs
- Platform/system logs

---

## Available Queries

### Container App Console Logs

File:

observability/kql/container-app-console-logs.kql

Purpose:

Investigate application behavior, startup messages, requests, and errors.

### Container App System Logs

File:

observability/kql/container-app-system-logs.kql

Purpose:

Investigate revisions, platform events, scaling activity, and failures.

---

## Current Limitations

The following observability capabilities are not yet implemented:

- Alerting
- Dashboards
- Metrics
- Distributed tracing
- SLOs
- Incident workflows

These are planned for future Level 2 phases.
