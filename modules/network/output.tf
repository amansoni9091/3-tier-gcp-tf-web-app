output "vpc_self_link" {
  description = "Self link of the VPC network."
  value       = google_compute_network.main.self_link
}

output "web_subnet_self_link" {
  description = "Self link of the web subnet."
  value       = google_compute_subnetwork.web.self_link
}

output "app_subnet_self_link" {
  description = "Self link of the app subnet."
  value       = google_compute_subnetwork.app.self_link
}

output "db_subnet_self_link" {
  description = "Self link of the db subnet."
  value       = google_compute_subnetwork.db.self_link
}

output "cloud_nat_name" {
  description = "Name of the Cloud NAT resource."
  value       = try(google_compute_router_nat.cloud_nat[0].name, null)
}

output "cloud_router_name" {
  description = "Name of the Cloud Router resource."
  value       = google_compute_router.cloud_router.name
}

output "network_self_link" {
  description = "Self-link of the VPC network."
  value       = google_compute_network.main.self_link
}