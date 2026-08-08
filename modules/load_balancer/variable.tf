variable "project_id" {
  description = "GCP project ID for the load balancer resources."
  type        = string
}

variable "backend_instance_group" {
  description = "Instance group URL (from MIG) used as backend."
  type        = string
}

variable "health_check_self_link" {
  description = "Self link of the HTTP health check used by the backend service."
  type        = string
}

variable "backend_port_name" {
  description = "Named port on the backend (e.g. http)."
  type        = string
  default     = "http"
}

variable "lb_name" {
  description = "Base name for load balancer resources."
  type        = string
  default     = "three-tier-web-lb"
}