# Global IP address for the load balancer (optional but clearer)
resource "google_compute_global_address" "web_ip" {
  name    = "${var.lb_name}-ip"
  project = var.project_id
}

resource "google_compute_backend_service" "web_backend" {
  # Backend service that represents the app MIG to the load balancer.
  name                  = "${var.lb_name}-backend"
  project               = var.project_id
  protocol              = "HTTP"
  port_name             = var.backend_port_name
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL_MANAGED"

  # Use the health check from the compute module (for MIG + LB).
  health_checks = [var.health_check_self_link]

  backend {
    # Attach the MIG's instance group as the backend.
    group           = var.backend_instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }

  # (Optional) Enable logging or session affinity later if needed.
}

resource "google_compute_url_map" "web_url_map" {
  # URL map routes incoming requests to backend services.
  name    = "${var.lb_name}-urlmap"
  project = var.project_id

  # For now, send all paths to the single backend service.
  default_service = google_compute_backend_service.web_backend.id
}

resource "google_compute_target_http_proxy" "web_http_proxy" {
  # HTTP proxy that uses the URL map.
  name    = "${var.lb_name}-http-proxy"
  project = var.project_id

  url_map = google_compute_url_map.web_url_map.id
}

resource "google_compute_global_forwarding_rule" "web_forwarding_rule" {
  # Public entry point: binds global IP + port 80 to the HTTP proxy.
  name       = "${var.lb_name}-http-fr"
  project    = var.project_id
  target     = google_compute_target_http_proxy.web_http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.web_ip.address
  ip_protocol = "TCP"
}