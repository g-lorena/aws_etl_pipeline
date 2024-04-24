
variable "bucket_name" {
  description = "principal bucket name"
  type        = string
  #default     = "real-estate-etl-101"
}

variable "utils_bucket_name" {
  description = "utils bucket name"
  type        = string
  #default     = "real-estate-etl-101"
}

variable "raw_repertory" {
  description = "raws data repertory"
  type        = string
  #default     = "raw_data"
}

variable "std_repertory" {
  description = "std data repertory"
  type        = string
  #default     = "std_data"
}

variable "glue_local_script_path"{
  description = "glue local script path"
  type        = string
  #default = "../glue_etl_job/transform_data.py"
}

variable "glue_script_key" {
  description = "glue script key"
  type        = string
}