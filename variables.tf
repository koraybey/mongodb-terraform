variable "environment_configs" {
  description = "Environment-specific configuration settings"
  type = map(object({
    instance_size = string
  }))
  default = {
    development = {
      instance_size = "SERVERLESS"
    }
    staging = {
      instance_size = "SERVERLESS"
    }
    production = {
      instance_size = "SERVERLESS"
    }
  }
}
resource "random_string" "cluster_name_suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  cluster_name = random_string.cluster_name_suffix.result
}

variable "mongodbatlas_public_key" {
  description = "MongoDB Atlas API public key"
  type        = string
  sensitive   = true
}

variable "mongodbatlas_private_key" {
  description = "MongoDB Atlas API private key"
  type        = string
  sensitive   = true
}

variable "atlas_org_id" {
  description = "MongoDB Atlas organization ID"
  type        = string
}

variable "project_name" {
  description = "MongoDB Atlas project name"
  type        = string
}

variable "database_username" {
  description = "MongoDB database user username"
  type        = string
}

variable "database_password" {
  description = "MongoDB database user password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "MongoDB database name"
  type        = string
}

variable "provider_name" {
  description = "Provider name"
  type        = string
  default     = "GCP"
}

variable "region_name" {
  description = "Reegion for the cluster"
  type        = string
  default     = "WESTERN_EUROPE"
}

variable "allowed_ips" {
  description = "Comma-separated list of IP addresses to whitelist"
  type        = string
}
