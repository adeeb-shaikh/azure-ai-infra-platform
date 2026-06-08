# Observability Signals

## Purpose

This document defines the operational signals used to observe the Azure Cloud-Native Infrastructure Platform.

A signal should only become an alert when it represents an actionable condition that requires investigation or response.

The goal is to ensure monitoring remains useful, low-noise, and operationally relevant.

---

## Ownership

Current owner:

```text
Platform Maintainer
(single-operator portfolio environment)
```

Future team-based environments should assign ownership to the responsible platform or operations team.

---

## Alerting Principles

Alerts should be:

* Actionable
* User-impacting, or a leading indicator of user impact
* Low-noise
* Documented in the runbook
* Owned by an operator or team
* Backed by a repeatable investigation process

Alerts should not be created simply because a metric or log source exists.

---

## Current Signals

| Signal                    | Source                         | Query / Investigation Method                     | Purpose                                                                  | Alert Candidate | Initial Threshold                          | Owner               |
| ------------------------- | ------------------------------ | ------------------------------------------------ | ------------------------------------------------------------------------ | --------------- | ------------------------------------------ | ------------------- |
| Application Console Logs  | ContainerAppConsoleLogs_CL     | observability/kql/container-app-console-logs.kql | Investigate application behavior, startup messages, requests, and errors | No              | N/A                                        | Platform Maintainer |
| Container App System Logs | ContainerAppSystemLogs_CL      | observability/kql/container-app-system-logs.kql  | Investigate revisions, platform events, scaling activity, and failures   | Yes             | Any failed revision event                  | Platform Maintainer |
| Health Endpoint           | Application `/health` endpoint | HTTP health check (future synthetic monitoring)  | Verify application availability                                          | Yes             | 3 consecutive failures                     | Platform Maintainer |
| Replica Count             | Azure Monitor Metrics          | Azure Monitor metric query                       | Understand runtime capacity and scaling behavior                         | Maybe           | To be determined after baseline collection | Platform Maintainer |
| CPU Usage                 | Azure Monitor Metrics          | Azure Monitor metric query                       | Detect resource pressure                                                 | Future          | To be determined after baseline collection | Platform Maintainer |
| Memory Usage              | Azure Monitor Metrics          | Azure Monitor metric query                       | Detect memory pressure or leaks                                          | Future          | To be determined after baseline collection | Platform Maintainer |

---

## Alert Candidates

### 1. Container App Availability Failure

#### Why

The application is unavailable to users.

#### Signal Source

* Health endpoint
* Future synthetic availability check

#### Initial Threshold

```text
3 consecutive failed health checks
```

#### Investigation

1. Verify Container App status.
2. Review application console logs.
3. Review Container App system logs.
4. Verify active revision health.

#### Status

Planned.

---

### 2. Container App Revision Failure

#### Why

A deployment or revision failed to become healthy.

#### Signal Source

```text
ContainerAppSystemLogs_CL
```

#### Investigation Query

```text
observability/kql/container-app-system-logs.kql
```

#### Initial Threshold

Observed failure indicators:

- FailedMount
- ReplicaUnhealthy

Alert criteria are based on validated Container Apps system log events observed in Log Analytics.

#### Investigation

1. Review revision events.
2. Review startup failures.
3. Review image pull failures.
4. Verify Container App revision status.

#### Status

Planned.

---

### 3. Excessive Restarts

#### Why

Frequent restarts may indicate instability, crash loops, or configuration problems.

#### Signal Source

```text
Container App system logs
```

#### Investigation Query

```text
observability/kql/container-app-system-logs.kql
```

#### Initial Threshold

```text
More than 3 restarts within 10 minutes.

Threshold subject to tuning after baseline observation.
```

#### Investigation

1. Review restart events.
2. Review application logs.
3. Check recent deployments.
4. Verify resource consumption.

#### Status

Planned.

---

## Investigation Workflow

When an alert fires:

```text
Alert
↓
Identify affected resource
↓
Review corresponding signal
↓
Run investigation query
↓
Determine root cause
↓
Follow runbook recovery procedure
↓
Document findings
```

---

## Deferred Signals

The following capabilities are intentionally deferred until justified by operational requirements:

* Distributed tracing
* OpenTelemetry
* Prometheus
* Grafana
* Application Insights

The platform currently uses Azure-native observability services because they satisfy current monitoring requirements with lower operational complexity.

---

## Design Decisions

### Why Azure-Native Monitoring First

The platform already includes:

* Azure Monitor
* Log Analytics
* Azure Container Apps telemetry

A mature engineering team should fully utilize existing platform capabilities before introducing additional observability tooling.

### Why Thresholds Are Provisional

Alert thresholds should be based on observed platform behavior.

Initial thresholds are starting points and should be refined after baseline operational data is collected.

### Why Ownership Matters

An alert without an owner is not operationally useful.

Every alert must have a responsible operator or team capable of investigating and resolving the issue.

Revision Failure Alert Status:
Experimental

Alert criteria based on assumed failure indicators.
Requires validation against observed Container App system log events.
