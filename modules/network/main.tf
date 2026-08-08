resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  project                 = var.project_id
}

resource "google_compute_subnetwork" "web" {
  name                     = "${var.network_name}-web-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = var.web_subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "app" {
  name                     = "${var.network_name}-app-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = var.app_subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "db" {
  name                     = "${var.network_name}-db-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = var.db_subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_router" "cloud_router" {
  name    = "${var.network_name}-cloud-router"
  region  = var.region
  project = var.project_id
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "cloud_nat" {
  count                              = var.enable_cloud_nat ? 1 : 0
  name                               = "${var.network_name}-cloud-nat"
  router                             = google_compute_router.cloud_router.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_endpoint_independent_mapping = true

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.network_name}-allow-http-https"
  project = var.project_id
  network = google_compute_network.main.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "allow_lb_health_check" {
  name    = "${var.network_name}-allow-lb-health-check"
  project = var.project_id
  network = google_compute_network.main.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["app-server"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "${var.network_name}-allow-iap-ssh"
  project = var.project_id
  network = google_compute_network.main.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
resource "google_compute_firewall" "allow_internal_communication" {
  name    = "${var.network_name}-allow-internal"
  project = var.project_id
  network = google_compute_network.main.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.web_subnet_cidr, var.app_subnet_cidr, var.db_subnet_cidr]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_web_to_app" {
  name    = "${var.network_name}-allow-web-to-app"
  project = var.project_id
  network = google_compute_network.main.name

  direction   = "INGRESS"
  priority    = 1000
  source_tags = ["web-server"]
  target_tags = ["app-server"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

resource "google_compute_firewall" "allow_app_to_db" {
  name    = "${var.network_name}-allow-app-to-db"
  project = var.project_id
  network = google_compute_network.main.name

  direction   = "INGRESS"
  priority    = 1000
  source_tags = ["app-server"]
  target_tags = ["db-server"]

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
}