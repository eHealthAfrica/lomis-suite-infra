project_id  = "lomis-prod"
region      = "europe-west1"
cost_center = "logistics"
environment = "prod"

gke_cluster = {
  node_count_min = 3
  node_count_max = 10
}

cloud_sql = {
  tier           = "db-custom-4-16384"
  backup_enabled = true
}

labels = {
  env         = "prod"
  project     = "lomis"
  team        = "logistics-tech"
  cost-center = "logistics"
}
