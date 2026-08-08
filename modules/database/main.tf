###############################################################################
# Private Services Access
#
# Cloud SQL private IP requires a reserved internal IP range and a
# Service Networking connection between your VPC and Google-managed services.
###############################################################################

resource "google_compute_global_address" "private_services" {
  name          = "${var.db_instance_name}-private-services"
  project       = var.project_id

  # Reserve an internal range for Google-managed services such as Cloud SQL.
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16

  # Attach the reserved range to the existing VPC.
  network = var.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network = var.network_self_link
  service = "servicenetworking.googleapis.com"

  # Use the internal range reserved above.
  reserved_peering_ranges = [
    google_compute_global_address.private_services.name
  ]
  # Terraform removes its state entry but leaves the Google connection.
  deletion_policy = "ABANDON"
}


###############################################################################
# Cloud SQL MySQL Instance
###############################################################################

resource "google_sql_database_instance" "main" {
  name             = var.db_instance_name
  project          = var.project_id
  region           = var.region
  database_version = "MYSQL_8_0"

  # Make sure private services access exists before creating Cloud SQL.
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]

  settings {
    # Example development tier. Use a larger tier for production.
    tier = var.db_tier

    # ZONAL is suitable for development.
    # Use REGIONAL for production high availability.
    availability_type = "ZONAL"

    disk_type         = "PD_SSD"
    disk_size         = 20
    disk_autoresize   = true

    # Enable automated backups.
    backup_configuration {
      enabled = true
    }

    ip_configuration {
      # false means Cloud SQL does not receive a public IPv4 address.
      ipv4_enabled = false

      # Attach Cloud SQL to your existing VPC using private IP.
      private_network = var.network_self_link
    }
  }

  # Convenient for development, but use true in production.
  deletion_protection = false
}

###############################################################################
# Application Database
###############################################################################

resource "google_sql_database" "app" {
  name     = var.database_name
  project  = var.project_id
  instance = google_sql_database_instance.main.name
}

###############################################################################
# Application Database User
###############################################################################

resource "google_sql_user" "app" {
  name     = var.database_user
  project  = var.project_id
  instance = google_sql_database_instance.main.name

  # For production, store this value in Secret Manager instead of plain
  # Terraform variables.
  password = var.database_password
}