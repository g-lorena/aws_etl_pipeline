variable "database" {
  description = "glue catalog database name"
  type        = string
}

variable "houston_crawler_name" {
  description = "glue houston crawler name"
  type        = string
}

variable "panamera_crawler_name" {
  description = "glue panamera crawler name"
  type        = string
}

variable "houston" {
  description = "houston value"
  type        = string
}

variable "panamera" {
  description = "panamera value"
  type        = string
}

variable "s3_target_path_houston" {
  description = "s3 target path"
  type        = string
}

variable "s3_target_path_panamera" {
  description = "s3 target path"
  type        = string
}



variable "glue_iam_role" {
  description = "glue iam role"
  type        = string
}

variable "classifiers" {
  description = "classifiers"
  type        = list(string)
}
