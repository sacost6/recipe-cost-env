resource "google_cloud_run_v2_service" "pricing" {
  name                = "recipe-cost-pricing-dev"
  location            = "us-east5"
  deletion_protection = false

  template {
    service_account = google_service_account.pricing.email
    scaling {
      max_instance_count = 2
    }

    containers {
      image = "us-east5-docker.pkg.dev/recipe-515406/recipe-cost-dev/pricing-service:dev"

      env {
        name = "PRICING_SERVICE_TOKEN"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-pricing-token"
            version = "1"
          }
        }
      }

      env {
        name = "USDA_FDC_API_KEY"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-usda-fdc-api-key"
            version = "1"
          }
        }
      }

    }
  }
}

resource "google_cloud_run_v2_service" "kroger" {
  name                = "recipe-cost-kroger-dev"
  location            = "us-east5"
  deletion_protection = false

  template {
    service_account = google_service_account.kroger.email
    scaling {
      max_instance_count = 2
    }

    containers {
      image = "us-east5-docker.pkg.dev/recipe-515406/recipe-cost-dev/kroger-service:dev"

      env {
        name = "KROGER_SERVICE_TOKEN"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-kroger-token"
            version = "1"
          }
        }
      }

      env {
        name = "KROGER_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-kroger-client-id"
            version = "1"
          }
        }
      }

      env {
        name = "KROGER_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-kroger-client-secret"
            version = "1"
          }
        }
      }
    }
  }
}

resource "google_cloud_run_v2_service" "backend" {
  name                = "recipe-cost-backend-dev"
  location            = "us-east5"
  deletion_protection = false

  template {
    service_account = google_service_account.backend.email
    scaling {
      max_instance_count = 2
    }

    containers {
      image = "us-east5-docker.pkg.dev/recipe-515406/recipe-cost-dev/backend:session-cookie-v1"

      env {
        name  = "NODE_ENV"
        value = "production"
      }

      env {
        name = "DATABASE_URL"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-database-url"
            version = "1"
          }
        }
      }

      env {
        name = "API_SECRET"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-api-secret"
            version = "1"
          }
        }
      }

      env {
        name = "SESSION_SECRET"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-session-secret"
            version = "3"
          }
        }
      }

      env {
        name  = "PRICING_SERVICE_URL"
        value = google_cloud_run_v2_service.pricing.uri
      }

      env {
        name = "PRICING_SERVICE_TOKEN"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-pricing-token"
            version = "1"
          }
        }
      }

      env {
        name  = "KROGER_SERVICE_URL"
        value = google_cloud_run_v2_service.kroger.uri
      }

      env {
        name = "KROGER_SERVICE_TOKEN"
        value_source {
          secret_key_ref {
            secret  = "recipe-cost-dev-kroger-token"
            version = "1"
          }
        }
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "pricing_public" {
  project  = "recipe-515406"
  location = google_cloud_run_v2_service.pricing.location
  name     = google_cloud_run_v2_service.pricing.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "kroger_public" {
  project  = "recipe-515406"
  location = google_cloud_run_v2_service.kroger.location
  name     = google_cloud_run_v2_service.kroger.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "backend_public" {
  project  = "recipe-515406"
  location = google_cloud_run_v2_service.backend.location
  name     = google_cloud_run_v2_service.backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}