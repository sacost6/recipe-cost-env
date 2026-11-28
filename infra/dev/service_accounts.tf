resource "google_service_account" "backend" {
  project      = "recipe-515406"
  account_id   = "recipe-cost-backend-dev"
  display_name = "Recipe Cost backend (dev)"
}

resource "google_service_account" "pricing" {
  project      = "recipe-515406"
  account_id   = "recipe-cost-pricing-dev"
  display_name = "Recipe Cost pricing service (dev)"
}

resource "google_service_account" "kroger" {
  project      = "recipe-515406"
  account_id   = "recipe-cost-kroger-dev"
  display_name = "Recipe Cost Kroger service (dev)"
}
