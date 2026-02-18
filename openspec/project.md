# LoMIS Platform Infrastructure - Project Conventions

## Overview

This repository manages the GCP infrastructure for LoMIS Platform.

## Platform

| Attribute | Value |
|-----------|-------|
| Cloud Provider | GCP |
| Primary Region | europe-west1 |
| Production Project | lomis-prod |
| IaC Tool | Terraform |

## Naming Conventions

### GCP Resources
- Pattern: `lomis-platform-{component}-{env}`
- Example: `lomis-platform-postgres-prod`

### Terraform
- Resources: snake_case
- Variables: snake_case
- Modules: kebab-case directories

## Directory Structure

```
infrastructure/
├── environments/
│   ├── dev/        # Development environment
│   ├── staging/    # Staging environment
│   └── prod/       # Production environment
└── modules/        # Shared modules
```

## Required Labels

All GCP resources must have:

| Label | Description | Example |
|-------|-------------|---------|
| `environment` | Environment tier | `dev`, `staging`, `prod` |
| `service` | Service name | `lomis-platform` |
| `managed-by` | Management tool | `terraform` |
| `cost-center` | Billing attribution | `logistics` |

## Change Workflow

1. **Propose**: Create change in `openspec/changes/`
2. **Review**: Get approval from logistics-tech
3. **Implement**: Follow tasks.md
4. **Deploy**: Via CI/CD pipeline

## Related

- [OpenSpec Workflow](AGENTS.md)
- [EHA Standards](https://github.com/eHealthAfrica/eha-cloud-devops/tree/main/standards)
