resource "google_compute_instance_template" "app" {
  # Template used by the MIG to create app VMs.
  name_prefix  = "app-template-"
  project      = var.project_id
  machine_type = var.instance_machine_type

  # Tags are used by firewall rules to allow web -> app traffic.
  tags = var.instance_tags

  disk {
    # Boot disk for the VM.
    boot         = true
    auto_delete  = true
    source_image = "debian-cloud/debian-12"
    disk_size_gb = 20
  }

  network_interface {
    # Attach VM to the app subnet created in the network module.
    subnetwork = var.app_subnet_self_link

    # Keep this commented for private-only instances in prod.
    # For quick dev testing, you can enable a public IP.
    # access_config {}
  }

  # Startup script installs nginx and serves a simple app page.
  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    # Use a custom service account if provided; otherwise default.
    email  = var.instance_service_account != "" ? var.instance_service_account : null
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  labels = {
    env  = "dev"
    tier = "app"
  }

  lifecycle {
    # Helps avoid downtime when template changes.
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "app_health" {
  # Health check used by MIG auto-healing and later load balancing.
  name    = "app-health-check"
  project = var.project_id

  check_interval_sec = 10
  timeout_sec        = 5

  http_health_check {
    port         = var.app_port
    request_path = "/health"
  }
}

resource "google_compute_region_instance_group_manager" "app_mig" {
  # Regional MIG gives zone-level resilience within the region.
  name    = "app-mig"
  project = var.project_id
  region  = var.region

  base_instance_name = "app"
  target_size        = var.min_replicas

  version {
    # MIG uses the template above for every VM it creates.
    instance_template = google_compute_instance_template.app.self_link
  }

  named_port {
    # Backend service will use this port name later.
    name = "http"
    port = var.app_port
  }

  auto_healing_policies {
    # Replace unhealthy VMs automatically.
    health_check      = google_compute_health_check.app_health.self_link
    initial_delay_sec = 120
  }
}

resource "google_compute_region_autoscaler" "app_autoscaler" {
  # Automatically scales the MIG based on CPU usage.
  name    = "app-autoscaler"
  project = var.project_id
  region  = var.region
  target  = google_compute_region_instance_group_manager.app_mig.self_link

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = 60

    cpu_utilization {
      target = var.cpu_target_utilization
    }
  }
}