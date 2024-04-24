variable "database" {
  description = "glue catalog database name"
  type        = string
}

variable "name" {
  description = "glue crawler name"
  type        = string
}

variable "s3_target_path" {
  description = "s3 target path"
  type        = string
}

variable "glue_iam_role" {
  description = "glue iam role"
  type        = string
}

