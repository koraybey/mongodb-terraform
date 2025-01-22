output "database_user" {
  value       = mongodbatlas_database_user.db_user.username
  description = "Database user"
}

output "database_name" {
  value       = var.database_name
  description = "Database name"
}

output "connection_string" {
  value       = mongodbatlas_serverless_instance.cluster.connection_strings_private_endpoint_srv
  description = "MongoDB Atlas connection string"
  sensitive   = true
}

output "cluster_endpoint" {
  value       = mongodbatlas_serverless_instance.cluster.connection_strings_standard_srv
  description = "MongoDB Atlas cluster endpoint (SRV)"
  sensitive   = true
}

output "mongodb_uri" {
  description = "MongoDB URI for applications"
  value       = "mongodb+srv://${mongodbatlas_database_user.db_user.username}:${mongodbatlas_database_user.db_user.password}@${trimprefix(mongodbatlas_serverless_instance.cluster.connection_strings_standard_srv, "mongodb+srv://")}/${var.database_name}?retryWrites=true&w=majority"
  sensitive   = true
}