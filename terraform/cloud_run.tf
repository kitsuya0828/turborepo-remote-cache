resource "google_service_account" "cloud_run" {
  account_id = "cloud-run"
}

resource "google_cloud_run_v2_service" "default" {
  name                = "turborepo-remote-cache"
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.cloud_run.email

    containers {
      name  = "app"
      image = data.google_artifact_registry_docker_image.app.self_link

      env {
        name  = "TURBO_TOKEN"
        value = random_password.password.result
      }

      env {
        name  = "STORAGE_PROVIDER"
        value = "google-cloud-storage"
      }

      env {
        name  = "STORAGE_PATH"
        value = google_storage_bucket.default.name
      }

      env {
        name  = "PORT"
        value = "3000"
      }

      startup_probe {
        tcp_socket {
          port = 3000
        }
      }
    }

    containers {
      name  = "proxy"
      image = data.google_artifact_registry_docker_image.proxy.self_link

      ports {
        container_port = 8080
      }
      depends_on = ["app"]

      env {
        name  = "TURBO_API"
        value = "http://localhost:3000"
      }
      env {
        name  = "TURBO_TOKEN"
        value = random_password.password.result
      }
      startup_probe {
        tcp_socket {
          port = 8080
        }
      }
    }
  }
}

data "google_iam_policy" "cloud_run" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.github_actions.email}"
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "policy" {
  project     = google_cloud_run_v2_service.default.project
  location    = google_cloud_run_v2_service.default.location
  name        = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.cloud_run.policy_data
}
