output "instance_template_self_link" {
  description = "Self link of the instance template used by the MIG."
  value       = google_compute_instance_template.app.self_link
}

output "mig_self_link" {
  description = "Self link of the managed instance group."
  value       = google_compute_region_instance_group_manager.app_mig.self_link
}

output "mig_instance_group" {
  description = "Instance group URL of the managed instance group (used by backend services)."
  value       = google_compute_region_instance_group_manager.app_mig.instance_group
}

output "health_check_self_link" {
  description = "Self link of the health check resource used for auto-healing and load balancing."
  value       = google_compute_health_check.app_health.self_link
}