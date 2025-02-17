resource "google_artifact_registry_repository" "default" {
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  format        = "DOCKER"
}

# gcloud auth configure-docker asia-northeast1-docker.pkg.dev 

# docker pull ducktors/turborepo-remote-cache:latest
# docker tag ducktors/turborepo-remote-cache:latest asia-northeast1-docker.pkg.dev/PROJECT_ID/turborepo-remote-cache/app:latest
# docker push asia-northeast1-docker.pkg.dev/PROJECT_ID/turborepo-remote-cache/app:latest
data "google_artifact_registry_docker_image" "app" {
  location      = google_artifact_registry_repository.default.location
  repository_id = google_artifact_registry_repository.default.repository_id
  image_name    = "app:latest"
}

# cd nginx && docker build -t proxy:latest .
# docker tag proxy:latest asia-northeast1-docker.pkg.dev/PROJECT_ID/turborepo-remote-cache/proxy:latest
# docker push asia-northeast1-docker.pkg.dev/PROJECT_ID/turborepo-remote-cache/proxy:latest
data "google_artifact_registry_docker_image" "proxy" {
  location      = google_artifact_registry_repository.default.location
  repository_id = google_artifact_registry_repository.default.repository_id
  image_name    = "proxy:latest"
}
