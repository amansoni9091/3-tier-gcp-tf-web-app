variable "project_id" {
  type        = string
  description = "Google Cloud project ID."
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Initial Cloud SQL database password."
}