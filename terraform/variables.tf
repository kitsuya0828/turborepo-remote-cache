variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "zone" {
  type    = string
  default = "asia-northeast1-a"
}

variable "artifact_registry_repository_id" {
  type    = string
  default = "turborepo-remote-cache"
}

variable "storage_bucket_name" {
  type    = string
  default = "kitsuya0828-turborepo-remote-cache"
}
