terraform {
  backend "gcs" {
    bucket = "terraform-gcp-three-tier-web-state"
    prefix = "three-tier/dev"
  }
}

