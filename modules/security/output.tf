output "app_service_account_email" {
  description = "Service account used by application VMs."
  value       = google_service_account.app.email
}

output "db_password_secret_id" {
  description = "Secret Manager ID containing the database password."
  value       = google_secret_manager_secret.db_password.secret_id
}