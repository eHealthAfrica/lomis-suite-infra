# LoMIS Platform Infrastructure - Claude Code Configuration

## Project Overview

This repository manages the GCP infrastructure for LoMIS Platform.

- **GCP Project**: `lomis-prod`
- **Primary Region**: `europe-west1`
- **Team**: logistics-tech
- **Cost Center**: logistics

## Key Skills

The following Claude skills from `eha-cloud-devops` are useful for this repo:

| Skill | Use Case |
|-------|----------|
| `terraform-deploy` | Safe Terraform deployment workflows |
| `cost-optimization` | Find cost savings opportunities |
| `cloud-sql-ops` | Database operations (if using Cloud SQL) |
| `observability-gcp` | Monitoring and alerting |
| `secret-management` | Secret rotation and access auditing |

## Project Structure

```
infrastructure/
├── environments/
│   ├── dev/        # Development - safe to experiment
│   ├── staging/    # Staging - production-like
│   └── prod/       # Production - requires approval
└── modules/        # Shared Terraform modules
```

## Common Tasks

### Deploy to Dev
```bash
cd infrastructure/environments/dev
terraform plan -out=tfplan
terraform apply tfplan
```

### Check Costs
Ask: "Run a cost analysis for lomis-prod"

### Validate Security
Ask: "Run a security check for this infrastructure"

## Conventions

### Naming
- Resources: `lomis-platform-{component}-{env}`
- Modules: `modules/{resource-type}`

### Labels
All resources must have:
- `environment`: dev | staging | prod
- `service`: lomis-platform
- `managed-by`: terraform
- `cost-center`: logistics

### Terraform
- Use `terraform fmt` before committing
- Run `terraform validate` in CI
- Require plan approval for prod changes

## OpenSpec Workflow

For infrastructure changes:
1. Create proposal in `openspec/changes/`
2. Get team approval
3. Implement via PR
4. Apply via CI/CD

See [openspec/AGENTS.md](openspec/AGENTS.md) for details.

## Related Resources

- [Central Hub](https://github.com/eHealthAfrica/eha-cloud-devops) - Standards and audit
- [Standards](https://github.com/eHealthAfrica/eha-cloud-devops/tree/main/standards)
