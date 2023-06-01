terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.60.0"
    }
  }
}

provider "google" {
  credentials = file(var.google_credentials_file)
  project = var.google_project_name
  region  = var.google_region
}


module "tipg-vector-tiler" {
  source = "../../modules/cloud_run"

  prefix                = var.prefix
  env                   = var.env
  function_name         = var.function_name
  location              = var.google_region
  docker_image          = var.docker_image
  container_concurrency = "200"
  timeout_seconds       = "10"
  cpu                   = "2.0"
  memory                = "1Gi"
  execution_environment = "gen2"
  startup_cpu_boost     = "true"
  min_scale             = "0"
  max_scale             = "150"
  extra_annotations = {
  }
  extra_template_annotations = {
    "run.googleapis.com/vpc-access-egress"    = "all"
    "run.googleapis.com/vpc-access-connector" = var.vpc-access-connector
    "run.googleapis.com/cloudsql-instances"   = var.cloudsql-instance
  }
  secret_envs = {
  }
}