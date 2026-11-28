resource "google_service_account" "migration" {
  project      = "recipe-515406"
  account_id   = "recipe-cost-migration-dev"
  display_name = "Recipe Cost migrations (dev)"
}

resource "google_secret_manager_secret_iam_member" "migration_secret_access" {
  for_each = toset([
    "recipe-cost-dev-database-url",
    "recipe-cost-dev-database-url-unpooled",
    "recipe-cost-dev-api-secret",
    "recipe-cost-dev-session-secret",
  ])

  project   = "recipe-515406"
  secret_id = each.key
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.migration.email}"
}

resource "google_cloud_run_v2_job" "migration" {
  name     = "recipe-cost-migrate-dev"
  location = "us-east5"

  template {
    template {
      service_account = google_service_account.migration.email
      max_retries     = 0
      timeout         = "600s"

      containers {
        image   = "us-east5-docker.pkg.dev/recipe-515406/recipe-cost-dev/backend:dev"
        command = ["/app/node_modules/.bin/typeorm"]
        args    = ["migration:run", "-d", "dist/migration-data-source.js"]

        env {
          name  = "NODE_ENV"
          value = "production"
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
          name = "DATABASE_URL"
          value_source {
            secret_key_ref {
              secret  = "recipe-cost-dev-database-url"
              version = "1"
            }
          }
        }

        env {
          name = "DATABASE_URL_UNPOOLED"
          value_source {
            secret_key_ref {
              secret  = "recipe-cost-dev-database-url-unpooled"
              version = "1"
            }
          }
        }
      }
    }
  }

  depends_on = [google_secret_manager_secret_iam_member.migration_secret_access]
}