terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "recipe-cost-calculator-dev-tfstate-515406"
    prefix = "terraform/dev"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}
