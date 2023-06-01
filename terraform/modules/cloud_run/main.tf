resource "google_cloud_run_service" "tiler_cloud_run_instance" {
  name                        = "${var.prefix}-${var.env}-${var.function_name}"
  autogenerate_revision_name  = true
  location                    = var.location
  metadata {
    annotations = local.annotations
  }

  template {
    metadata {
      annotations = local.template_annotations
    }
    spec {
      container_concurrency = var.container_concurrency
      timeout_seconds       = var.timeout_seconds

      containers {
        image = var.docker_image

        ports {
          container_port = var.port
        }

        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }
        dynamic "env" {
          for_each = var.envs
          content {
            name  = env.key
            value = env.value
          }
        }

        dynamic "env" {
          for_each = var.secret_envs
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value.name
                key  = env.value.key
              }
            }
          }
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image
    ]
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
