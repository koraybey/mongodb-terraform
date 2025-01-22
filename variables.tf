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

variable "cluster_name" {
  description = "MongoDB cluster name"
  type        = string
}

variable "gcp_region" {
  description = "GCP region for the cluster"
  type        = string
  default     = "us-central1"
}

variable "whitelist_ip" {
  description = "IP address to whitelist for database access"
  type        = string
}