###############################################################################
# Dedicated service account for application VMs
###############################################################################

resource "google_service_account" "app" {
  project      = var.project_id
  account_id   = "app-runtime-sa"
  display_name = "Application VM runtime service account"
}

###############################################################################
# Database password stored in Secret Manager
###############################################################################

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "app-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}

###############################################################################
# Allow only the application service account to read this secret
###############################################################################

resource "google_secret_manager_secret_iam_member" "app_reader" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}