<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# LoMIS Platform Infrastructure - AI Assistant Guide

## Purpose

This repository contains Infrastructure as Code (Terraform) and Kubernetes manifests for the LoMIS (Logistics Management Information System) platform.

## Quick Reference

### Terraform Commands

```bash
# Initialize Terraform (run in environment directory)
cd infrastructure/environments/dev
terraform init

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Destroy (CAREFUL!)
terraform destroy
```

### Kubernetes Commands

```bash
# Set context (once GKE is provisioned)
gcloud container clusters get-credentials lomis-platform-gke-dev --region europe-west1 --project lomis-dev

# Apply manifests
kubectl apply -k kubernetes/overlays/dev/

# Check pods
kubectl get pods --all-namespaces
```

### GitHub Actions

Workflows authenticate via GCP service account key:
- PR triggers validate, security scan, cost estimate, and plan
- Push to `main` triggers apply (dev -> staging -> prod with manual approval)

### Pull Request Guidelines

When creating pull requests in this repository:

1. **Always request AI code review** - After creating a PR, add a comment tagging `@claude` to request an AI-assisted review. Example:
   ```
   @claude Please review this PR for security, Terraform best practices, and potential issues.
   ```

2. **PR descriptions should include**:
   - Summary of changes
   - Related Jira ticket (if applicable)
   - Test plan or validation steps

3. **For infrastructure changes**, ask Claude to check:
   - Security implications
   - Cost impact
   - Best practices compliance
   - Potential breaking changes

#### Example PR CLI workflow

```bash
git checkout -b feature/description
# Make changes and commit
git push -u origin feature/description
gh pr create
# After PR is created, add a comment to trigger AI review:
# @claude Please review this PR for security, Terraform best practices, and potential issues.
```

### Directory Conventions

| Directory | Purpose |
|-----------|---------|
| `infrastructure/modules/` | Reusable Terraform modules |
| `infrastructure/environments/{env}/` | Environment-specific configs |
| `kubernetes/base/` | Base Kustomize configs |
| `kubernetes/overlays/{env}/` | Environment-specific overlays |
| `docs/` | Project documentation |

### Important Files

- `infrastructure/environments/dev/main.tf` - Dev environment entry point
- `infrastructure/environments/prod/main.tf` - Prod environment entry point
- `.github/workflows/terraform.yml` - CI/CD pipeline

## GCP Project Info

| Setting | Value |
|---------|-------|
| Dev Project ID | `lomis-dev` |
| Staging Project ID | `lomis-staging` |
| Prod Project ID | `lomis-prod` |
| Region | `europe-west1` |
| TF State Bucket | `gs://lomis-prod-tfstate` |
| State Prefix | `lomis-prod/{environment}` |

## Conventions

### Naming

- GCP Resources: `lomis-platform-{component}-{env}`
  - Example: `lomis-platform-postgres-prod`
- Terraform: snake_case for resources/variables, kebab-case for module directories
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

---

## GCP-Native Architecture Preferences

When implementing new services or modifying infrastructure, follow these principles.

### Compute Selection

| Service Type | Use | Avoid |
|--------------|-----|-------|
| Stateless, bursty workloads | Cloud Run | GKE (manual scaling) |
| Stateful, persistent connections | GKE Autopilot | Cloud Run |
| Background jobs | Cloud Run Jobs | GKE CronJobs |

### Observability

| Component | Use | Avoid |
|-----------|-----|-------|
| Metrics collection | Google Managed Prometheus | Self-managed Prometheus |
| Dashboards | Cloud Monitoring Console | Grafana |
| Alerting | Cloud Monitoring Alerts | AlertManager |
| Logging | Cloud Logging | ELK/Loki |

### Networking & TLS

| Component | Use | Avoid |
|-----------|-----|-------|
| TLS Certificates | GCP Managed Certificates | cert-manager + Let's Encrypt |
| Ingress | GCE Ingress | nginx-ingress |
| Load Balancer | Cloud Load Balancer | MetalLB / self-managed |

### Data & Caching

| Component | Use | Avoid |
|-----------|-----|-------|
| Redis/Cache | Cloud Memorystore | Self-managed Redis pods |
| Task Queue | Celery + Memorystore | RabbitMQ / self-managed |
| PostgreSQL | Cloud SQL | Self-managed PostgreSQL |

### Why GCP-Native?

- **Cost**: Managed services often have free tiers (GMP: 50GB free)
- **Operations**: Zero maintenance overhead
- **Integration**: Native IAM, VPC, audit logging
- **Support**: Google SLAs and support

---

## Infrastructure Status Commands

### Quick Health Check

```bash
# GCP Project status
gcloud projects describe lomis-prod --format="table(projectId,lifecycleState)"

# Terraform state
cd infrastructure/environments/prod
terraform state list

# All enabled APIs
gcloud services list --enabled --project=lomis-prod
```

### Enabled GCP APIs

All environments have these APIs enabled:
- `cloudresourcemanager.googleapis.com`
- `iam.googleapis.com`
- `compute.googleapis.com`
- `run.googleapis.com`
- `sqladmin.googleapis.com`
- `secretmanager.googleapis.com`
- `monitoring.googleapis.com`
- `logging.googleapis.com`

---

## Secret Management Workflow

### Add a Secret

```bash
# 1. Create in GCP
echo -n "secret-value" | gcloud secrets create SECRET_NAME \
  --data-file=- --replication-policy=user-managed \
  --locations=europe-west1 --project=lomis-prod

# 2. Verify
gcloud secrets versions access latest --secret=SECRET_NAME --project=lomis-prod
```

### Rotate a Secret

```bash
# Add new version
echo -n "new-value" | gcloud secrets versions add SECRET_NAME \
  --data-file=- --project=lomis-prod
```

---

## CI/CD Pipeline

### Workflow Overview (`.github/workflows/terraform.yml`)

| Job | Trigger | Environments | Purpose |
|-----|---------|-------------|---------|
| validate | PR + push | dev, staging, prod | Format check, init, validate |
| security-scan | PR + push | - | Checkov SARIF scan |
| cost-estimate | PR only | - | Infracost analysis + PR comment |
| plan | PR only | dev, staging, prod | Generate plan + PR comment |
| apply-dev | push to main | dev | Auto-apply |
| apply-staging | push to main | staging | Auto-apply (after dev) |
| apply-prod | push to main | prod | Manual approval required |

### Required Secrets

| Secret | Purpose |
|--------|---------|
| `GCP_SA_KEY` | GCP service account credentials |
| `INFRACOST_API_KEY` | Cost estimation API key |

---

## OpenSpec (Spec-Driven Development)

OpenSpec enables spec-driven development with Claude Code for high-quality, traceable changes.

### Quick Commands

```bash
# List specs and changes
openspec list --specs
openspec list

# Create change proposal
mkdir -p openspec/changes/DESCRIPTION/specs/capability
# ... create proposal.md, tasks.md, specs/*/spec.md

# Validate before implementation
openspec validate DESCRIPTION --strict

# Archive after merge
openspec archive DESCRIPTION --yes
```

### Workflow

1. **Create ticket** (if using Jira)
2. **Draft proposal**: `openspec/changes/DESCRIPTION/`
3. **Review & approve**: PR or async review
4. **Implement**: Follow tasks.md checklist
5. **Archive**: `openspec archive DESCRIPTION --yes`

### Directory Structure

```
openspec/
├── AGENTS.md           # AI instructions
├── project.md          # Project naming conventions & standards
├── changes/            # Proposed infrastructure changes
└── specs/              # Finalized specifications
```

See `openspec/AGENTS.md` for detailed patterns and workflow.

---

## Current Deployment Status

| Component | Status | Notes |
|-----------|--------|-------|
| GCP Projects | ✅ Created | lomis-dev, lomis-staging, lomis-prod |
| Terraform State | ✅ Configured | GCS backend in lomis-prod-tfstate |
| CI/CD Pipeline | ✅ Active | GitHub Actions with env progression |
| GCP API Enablement | ✅ Done | Core APIs enabled across all envs |
| Terraform Modules | ⏳ Pending | Placeholder directory only |
| GKE Cluster | ⏳ Pending | Not yet provisioned |
| Cloud SQL | ⏳ Pending | Not yet provisioned |
| Kubernetes Manifests | ⏳ Pending | Kustomize structure scaffolded |
| Secret Management | ⏳ Pending | No ESO or secrets configured |
| Observability | ⏳ Pending | No dashboards or alerts configured |

---

## Related Resources

- [Central Hub](https://github.com/eHealthAfrica/eha-cloud-devops) - Standards and audit
- [Standards](https://github.com/eHealthAfrica/eha-cloud-devops/tree/main/standards)

---

_Last updated: 2026-02-19_
