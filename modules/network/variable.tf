variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region where the network resources will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "web_subnet_cidr" {
  description = "CIDR block for the web subnet."
  type        = string
}

variable "app_subnet_cidr" {
  description = "CIDR block for the app subnet."
  type        = string
}

variable "db_subnet_cidr" {
  description = "CIDR block for the db subnet."
  type        = string
}

variable "enable_cloud_nat" {
  description = "Whether to enable Cloud NAT for private subnet outbound internet access."
  type        = bool
  default     = true
}

variable "routing_mode" {
  description = "The routing mode for the VPC network. Valid values are GLOBAL or REGIONAL."
  type        = string
  default     = "GLOBAL"
}