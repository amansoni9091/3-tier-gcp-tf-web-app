variable "project_id" {
  description = "GCP project ID for the compute resources."
  type        = string
}

variable "region" {
  description = "GCP region where the managed instance group will run."
  type        = string
}

variable "app_subnet_self_link" {
  description = "Self link of the app subnet where instances will be attached."
  type        = string
}

variable "instance_machine_type" {
  description = "Machine type for the app instances (e.g. e2-small)."
  type        = string
  default     = "e2-small"
}

variable "instance_tags" {
  description = "Network tags to apply to app instances (e.g. [\"app-server\", \"web-server\"])."
  type        = list(string)
  default     = ["app-server"]
}

variable "app_port" {
  description = "Port on which the application listens (e.g. 8080)."
  type        = number
  default     = 8080
}

variable "min_replicas" {
  description = "Minimum number of instances in the managed instance group."
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of instances in the managed instance group."
  type        = number
  default     = 3
}

variable "cpu_target_utilization" {
  description = "Target CPU utilization for autoscaling (0.0–1.0)."
  type        = number
  default     = 0.6
}


variable "instance_service_account" {
  description = "Service account email for the instances. If empty, the default compute SA will be used."
  type        = string
  default     = ""
}