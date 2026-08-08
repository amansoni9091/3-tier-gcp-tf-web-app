output "lb_ip_address" {
  description = "IP address of the global HTTP load balancer."
  value       = google_compute_global_forwarding_rule.web_forwarding_rule.ip_address
}

output "backend_service_name" {
  description = "Name of the backend service used by the load balancer."
  value       = google_compute_backend_service.web_backend.name
}