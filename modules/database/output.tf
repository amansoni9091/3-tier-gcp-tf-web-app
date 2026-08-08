output "instance_name" {
  description = "Cloud SQL instance name."
  value       = google_sql_database_instance.main.name
}

output "private_ip_address" {
  description = "Private IP address of the Cloud SQL instance."
  value       = google_sql_database_instance.main.private_ip_address
}

output "connection_name" {
  description = "Cloud SQL connection name."
  value       = google_sql_database_instance.main.connection_name
}