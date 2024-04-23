
variable "bucket_name" {
  description = "principal bucket name"
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