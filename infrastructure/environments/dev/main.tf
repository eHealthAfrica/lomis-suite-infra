# LoMIS Platform - Development Environment
# Terraform configuration for dev environment

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Local values for common configurations
locals {
  environment = "dev"
  service     = "lomis-platform"

  # Common labels for all resources
  common_labels = {
    environment = local.environment
    service     = local.service
    managed-by  = "terraform"
    cost-center = var.cost_center
  }
}

# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# Add your infrastructure resources below
# Example:
#
# module "cloud_run" {
#   source = "../../modules/cloud-run"
#
#   name        = "${local.service}-${local.environment}"
#   project_id  = var.project_id
#   region      = var.region
#   labels      = local.common_labels
# }
