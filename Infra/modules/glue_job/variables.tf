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
/*
variable "number_of_workers" {
  description = "number of workers"
  type        = integer
}

variable "worker_type" {
  description = "worker type"
  type        = string
}*/

variable "glue_version" {
  description = "glue version"
  type        = string
}

variable "class" {
  description = "argument glue class"
  type        = string
}

variable "enable-job-insights" {
  description = "argument enable job insights"
  type        = string
}

variable "enable-auto-scaling" {
  description = "argument enable job scaling"
  type        = string
}

variable "enable-glue-datacatalog" {
  description = "argument enable glue datacatalog"
  type        = string
}

variable "job-language" {
  description = "argument job language"
  type        = string
}

variable "job-bookmark-option" {
  description = "argument job bookmark option"
  type        = string
}

variable "datalake-formats" {
  description = "argument job datalake formats"
  type        = string
}

variable "conf" {
  description = "argument conf"
  type        = string
}