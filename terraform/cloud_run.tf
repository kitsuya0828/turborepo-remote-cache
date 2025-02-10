resource "google_cloud_run_v2_service" "default" {
  name                = "turborepo-remote-cache"
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = data.google_artifact_registry_docker_image.default.self_link

      env {
        name  = "TURBO_TOKEN"
        value = random_password.password.result
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
