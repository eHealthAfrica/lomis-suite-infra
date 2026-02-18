# LoMIS Platform Infrastructure

Infrastructure as Code for LoMIS Platform on Google Cloud Platform.

## Overview

This repository manages the infrastructure for LoMIS Platform using Terraform. It follows the [EHA Infrastructure Standards](https://github.com/eHealthAfrica/eha-cloud-devops/tree/main/standards).

## Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Access to GCP project `lomis-prod`

### Setup

1. Authenticate with GCP:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   gcloud config set project lomis-prod
   ```

2. Initialize Terraform (for dev environment):
   ```bash
   cd infrastructure/environments/dev
   terraform init
   ```

3. Plan changes:
   ```bash
   terraform plan -out=tfplan
   ```

4. Apply changes:
   ```bash
   terraform apply tfplan
   ```

## Repository Structure

```
lomis-platform-infra/
├── infrastructure/
│   ├── environments/
│   │   ├── dev/           # Development environment
│   │   ├── staging/       # Staging environment
│   │   └── prod/          # Production environment
│   └── modules/           # Reusable Terraform modules
├── openspec/
│   ├── AGENTS.md          # OpenSpec workflow guide
│   ├── project.md         # Project conventions
│   ├── specs/             # Infrastructure specifications
│   └── changes/           # Active change proposals
├── docs/                  # Additional documentation
├── .github/
│   └── workflows/         # CI/CD pipelines
├── CLAUDE.md              # Claude Code configuration
└── README.md              # This file
```

## Environments

| Environment | GCP Project | Region | Purpose |
|-------------|-------------|--------|---------|
| dev | lomis-dev | europe-west1 | Development and testing |
| staging | lomis-staging | europe-west1 | Pre-production validation |
| prod | lomis-prod | europe-west1 | Production workloads |

## Terraform State

State is stored in GCS bucket `lomis-prod-tfstate` with the following structure:
- `lomis-prod/dev/terraform.tfstate`
- `lomis-prod/staging/terraform.tfstate`
- `lomis-prod/prod/terraform.tfstate`

## CI/CD

GitHub Actions workflows:
- **terraform.yml**: Runs on PRs and pushes
  - `terraform fmt -check` - Format validation
  - `terraform validate` - Configuration validation
  - `terraform plan` - Preview changes (PRs)
  - `terraform apply` - Apply changes (main branch, prod requires approval)

## Making Changes

Follow the OpenSpec workflow for infrastructure changes:

1. **Propose**: Create change proposal in `openspec/changes/`
2. **Review**: Get approval from logistics-tech team
3. **Implement**: Create PR with changes
4. **Deploy**: Merge to main, apply via CI/CD

See [openspec/AGENTS.md](openspec/AGENTS.md) for details.

## Related Resources

- [EHA Cloud DevOps](https://github.com/eHealthAfrica/eha-cloud-devops) - Central standards and audit hub
- [EHA Infrastructure Standards](https://github.com/eHealthAfrica/eha-cloud-devops/tree/main/standards)

## Team

- **Owner**: logistics-tech
- **Cost Center**: logistics

## License

Proprietary - eHealth Africa
