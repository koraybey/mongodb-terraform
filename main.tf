resource "mongodbatlas_project" "atlas_project" {
  name   = var.project_name
  org_id = var.atlas_org_id
}

resource "mongodbatlas_database_user" "db_user" {
  username           = var.database_username
  password          = var.database_password
  project_id        = mongodbatlas_project.atlas_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  scopes {
    name = var.cluster_name
    type = "CLUSTER"
  }
}

resource "mongodbatlas_serverless_instance" "cluster" {
  project_id = mongodbatlas_project.atlas_project.id
  name       = var.cluster_name

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name        = "SERVERLESS"
  provider_settings_region_name          = var.gcp_region
}

resource "mongodbatlas_project_ip_access_list" "ip_access_list" {
  project_id = mongodbatlas_project.atlas_project.id
  ip_address = var.whitelist_ip
  comment    = "Allowed IP address"
}