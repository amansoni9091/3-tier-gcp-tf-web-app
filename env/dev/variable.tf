variable "project_id" {
  description = "The GCP project ID for dev"
  type        = string

}

variable "region" {
  description = "The GCP region for dev"
  type        = string
}

variable "network_name" {
  description = "The name of the GCP network for dev"
  type        = string
}

variable "web_subnet_cidr" {
  description = "The CIDR block for the web subnet in dev"
  type        = string
}

variable "app_subnet_cidr" {
  description = "The CIDR block for the app subnet in dev"
  type        = string
}

variable "db_subnet_cidr" {
  description = "The CIDR block for the db subnet in dev"
  type        = string
}

variable "enable_cloud_nat" {
  description = "Enable Cloud NAT for the network in dev"
  type        = bool
  default     = true
}

variable "routing_mode" {
  description = "The routing mode for the network in dev (GLOBAL or REGIONAL)"
  type        = string
}

variable "database_password" {
  description = "Password for the application database user."
  type        = string
  sensitive   = true
}