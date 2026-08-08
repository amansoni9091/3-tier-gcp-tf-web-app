variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "Region where Cloud SQL will be created."
  type        = string
}

variable "network_self_link" {
  description = "Self-link of the existing VPC network."
  type        = string
}

variable "db_instance_name" {
  description = "Cloud SQL instance name."
  type        = string
}

variable "db_tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-f1-micro"
}

variable "database_name" {
  description = "Name of the application database."
  type        = string
}

variable "database_user" {
  description = "Application database username."
  type        = string
}

variable "database_password" {
  description = "Application database password."
  type        = string
  sensitive   = true
}