# LoMIS Platform - Production Environment Backend Configuration

terraform {
  backend "gcs" {
    bucket = "lomis-prod-tfstate"
    prefix = "lomis-prod/prod"
  }
}
