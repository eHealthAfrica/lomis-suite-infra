# LoMIS Platform - Development Environment Variables

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

# Add additional variables as needed
# Example:
#
# variable "cloud_run_min_instances" {
#   description = "Minimum number of Cloud Run instances"
#   type        = number
#   default     = 0  # Dev can scale to zero
# }
