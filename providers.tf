terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"  # This is the correct source
      version = "~> 1.10.0"
    }
  }
}

provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}