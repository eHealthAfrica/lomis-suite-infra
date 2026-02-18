# LoMIS Platform - Development Environment Backend Configuration

terraform {
  backend "gcs" {
    bucket = "lomis-prod-tfstate"
    prefix = "lomis-prod/dev"
  }
}
