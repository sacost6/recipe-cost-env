resource "google_secret_manager_secret_iam_member" "backend_database_url" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-database-url"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_secret_manager_secret_iam_member" "backend_api_secret" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-api-secret"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_secret_manager_secret_iam_member" "backend_session_secret" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-session-secret"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_secret_manager_secret_iam_member" "backend_pricing_token" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-pricing-token"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_secret_manager_secret_iam_member" "backend_kroger_token" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-kroger-token"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_secret_manager_secret_iam_member" "pricing_token" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-pricing-token"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.pricing.email}"
}

resource "google_secret_manager_secret_iam_member" "kroger_token" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-kroger-token"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.kroger.email}"
}

resource "google_secret_manager_secret_iam_member" "pricing_usda_key" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-usda-fdc-api-key"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.pricing.email}"
}

resource "google_secret_manager_secret_iam_member" "kroger_client_id" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-kroger-client-id"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.kroger.email}"
}

resource "google_secret_manager_secret_iam_member" "kroger_client_secret" {
  project   = "recipe-515406"
  secret_id = "recipe-cost-dev-kroger-client-secret"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.kroger.email}"
}