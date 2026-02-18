# LoMIS Platform - Production Environment Variables

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "cost_center" {
  description = "Cost center for billing attribution"
  type        = string
  default     = "logistics"
}
