variable "script_location" {
  description = "script_location"
  type        = string
}

variable "name" {
  description = "name"
  type        = string
}

variable "timeout" {
  description = "timeout"
  type        = string
}

variable "iam_glue_arn" {
  description = "iam glue arn"
  type        = string
}

variable "number_of_workers" {
  description = "number of workers"
  type        = string
}

variable "worker_type" {
  description = "worker type"
  type        = string
}

variable "glue_version" {
  description = "glue version"
  type        = string
}