locals {
  environment = terraform.workspace
  current_env_config = var.environment_configs[local.environment]
  ip_list = split(",", var.allowed_ips)  # No need for trim since we'll have no spaces
}

resource "mongodbatlas_project" "atlas_project" {
  name   = "${var.project_name}-${local.environment}"
  org_id = var.atlas_org_id
}

resource "mongodbatlas_database_user" "db_user" {
  username           = var.database_username
  password           = var.database_password
  project_id         = mongodbatlas_project.atlas_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  scopes {
    name = "${local.cluster_name}-${local.environment}"
    type = "CLUSTER"
  }
}

resource "mongodbatlas_serverless_instance" "cluster" {
  project_id = mongodbatlas_project.atlas_project.id
  name       = "${local.cluster_name}-${local.environment}"

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name         = local.current_env_config.instance_size
  provider_settings_region_name           = var.gcp_region
}

resource "mongodbatlas_project_ip_access_list" "ip_access_list" {
  count      = length(local.ip_list)
  project_id = mongodbatlas_project.atlas_project.id
  ip_address = local.ip_list[count.index]
  comment    = "IP whitelist for ${local.environment} environment - Entry ${count.index + 1}"
}
