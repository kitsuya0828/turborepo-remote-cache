variable "project_id" {
  type = string
}

variable "service_account_id" {
  type    = string
  default = "github-actions"
}

variable "workload_identity_pool_id" {
  type    = string
  default = "github-actions-pool"
}

variable "workload_identity_pool_provider_id" {
  type    = string
  default = "github-actions-provider"
}

variable "github_repository_owner_id" {
  type    = string
  default = "60843722"
}

variable "github_repository" {
  type    = string
  default = "kitsuya0828/turborepo-remote-cache"
}

variable "github_ref" {
  type    = string
  default = "refs/heads/main"
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
