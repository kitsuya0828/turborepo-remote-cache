resource "google_artifact_registry_repository" "default" {
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  format        = "DOCKER"
}

# gcloud auth configure-docker asia-northeast1-docker.pkg.dev 
# docker pull ducktors/turborepo-remote-cache:latest
# docker tag ducktors/turborepo-remote-cache:latest asia-northeast1-docker.pkg.dev/PROJECT_ID/turborepo-remote-cache/turborepo-remote-cache:latest
# docker push asia-northeast1-docker.pkg.dev/PROJECT_ID/turborepo-remote-cache/turborepo-remote-cache:latest
data "google_artifact_registry_docker_image" "default" {
  location      = google_artifact_registry_repository.default.location
  repository_id = google_artifact_registry_repository.default.repository_id
  image_name    = "turborepo-remote-cache:latest"
}

