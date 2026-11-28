resource "google_artifact_registry_repository" "dev" {
  location      = "us-east5"
  repository_id = "recipe-cost-dev"
  description   = "Development container images for Recipe Cost Calculator"
  format        = "DOCKER"
}
