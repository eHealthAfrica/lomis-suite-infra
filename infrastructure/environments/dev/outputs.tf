# LoMIS Platform - Development Environment Outputs

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP region"
  value       = var.region
}

output "environment" {
  description = "Environment name"
  value       = "dev"
}

# Add additional outputs as needed
# Example:
#
# output "cloud_run_url" {
#   description = "Cloud Run service URL"
#   value       = module.cloud_run.url
# }
