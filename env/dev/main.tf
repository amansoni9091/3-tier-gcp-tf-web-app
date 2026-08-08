module "network" {
  source = "../../modules/network"

  project_id   = var.project_id
  region       = var.region
  network_name = var.network_name

  web_subnet_cidr = var.web_subnet_cidr
  app_subnet_cidr = var.app_subnet_cidr
  db_subnet_cidr  = var.db_subnet_cidr

  enable_cloud_nat = var.enable_cloud_nat
  routing_mode     = var.routing_mode
}

module "compute" {
  source = "../../modules/compute"

  project_id           = var.project_id
  region               = var.region
  app_subnet_self_link = module.network.app_subnet_self_link

  instance_machine_type = "e2-small"
  instance_tags         = ["app-server", "iap-ssh"]
  app_port              = 80   # nginx default

  min_replicas          = 1
  max_replicas          = 3
  cpu_target_utilization = 0.6

  #startup_script = file("${path.module}/startup.sh")
  instance_service_account = module.security.app_service_account_email

  depends_on = [
    module.network,
    module.security
  ]
}

module "web" {
  source = "../../modules/load_balancer"

  project_id             = var.project_id
  backend_instance_group = module.compute.mig_instance_group
  health_check_self_link = module.compute.health_check_self_link
  backend_port_name      = "http"
  lb_name                = "three-tier-dev-web"

  depends_on = [module.compute]
}

module "database" {
  source = "../../modules/database"

  project_id        = var.project_id
  region            = var.region
  network_self_link = module.network.network_self_link

  db_instance_name = "three-tier-dev-db"
  db_tier          = "db-f1-micro"

  database_name     = "appdb"
  database_user     = "appuser"
  database_password = var.database_password

  depends_on = [module.network]
}

module "security" {
  source = "../../modules/security"

  project_id  = var.project_id
  db_password = var.database_password
}